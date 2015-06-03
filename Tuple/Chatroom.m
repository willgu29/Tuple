//
//  Chatroom.m
//  Tuple
//
//  Created by William Gu on 5/21/15.
//  Copyright (c) 2015 William Gu. All rights reserved.
//

#import "Chatroom.h"
#import "Tuple-Swift.h"
#import "Message.h"
#import "NSManagedObject+WGMethods.h"
@interface Chatroom()

@property (nonatomic, strong) SocketIOClient *socket;
@property (nonatomic, strong) NSMutableArray *messages;

@end

@implementation Chatroom


-(instancetype)init
{
    self = [super init];
    if (self)
    {
        _messages = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)joinChatroom
{
    _socket = [[SocketIOClient alloc] initWithSocketURL:@"http://tupleapp.com" options:nil];
    [self setHandlers];
    [_socket connect];
}

-(void)setHandlers
{
    [_socket on:@"connect" callback:^(NSArray* data, void (^ack)(NSArray*)) {
        NSLog(@"socket connected");
        [_delegate chatRoomConnected];
    }];
    
    [_socket on:@"chat message" callback:^(NSArray* data, void (^ack)(NSArray*)) {
        NSLog(@"DATA: %@", data);
        
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        dateFormat.timeStyle = NSDateFormatterNoStyle;
        dateFormat.dateStyle = NSDateFormatterMediumStyle;
        NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
        [dateFormat setLocale:usLocale];
        
        
        
        AppDelegate *delegate = [UIApplication sharedApplication].delegate;
        NSManagedObjectContext *context = [delegate managedObjectContext];
        Message *newMessage = [NSEntityDescription
                          insertNewObjectForEntityForName:@"Message"
                          inManagedObjectContext:context];
        [newMessage safeSetValuesForKeysWithDictionary:[data firstObject] dateFormatter:dateFormat];
        NSError *error;
        if (![context save:&error]) {
            NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
        }

        [_messages addObject:newMessage];
        [_delegate chatMessageReceived];
    }];
    
    [_socket on:@"disconnect" callback:^(NSArray* data, void (^ack)(NSArray*)) {
        NSLog(@"socket disconnected");
    }];
}

-(void)leaveChatroom
{
    [_socket closeWithFast:false];
}

-(void)sendMessage:(NSString *)message
{
   
    NSDate *now = [NSDate date];
    [_socket emit:@"chat message" withItems:@[@{@"senderID": @"willgu", @"roomID": @"102", @"message": message, @"time": [now description]}]];
}

-(int)messageCount
{
    return [_messages count];
}
-(Message*)getMessageAtIndex:(int)index
{
    return [_messages objectAtIndex:index];
}
@end
