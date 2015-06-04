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
@property (nonatomic, strong) NSMutableArray *users;
@property (nonatomic, strong) NSMutableArray *messages;



//@property (strong, nonatomic) NSDictionary *users;


@end

@implementation Chatroom


-(instancetype)init
{
    self = [super init];
    if (self)
    {
        _messages = [[NSMutableArray alloc] init];
        _users = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)joinChatroom
{
    _socket = [[SocketIOClient alloc] initWithSocketURL:@"http://tupleapp.com" options:nil];
    [self setHandlers];
    [_socket connect];
    
    [_socket emit:@"join chatroom" withItems:@[[PFUser currentUser]]];
}

-(void)setHandlers
{
    [_socket on:@"connect" callback:^(NSArray* data, void (^ack)(NSArray*)) {
        NSLog(@"socket connected");
        NSLog(@"Data Connect: %@", data);
        [_delegate chatRoomReconnected];
    }];
    [_socket on:@"disconnect" callback:^(NSArray* data, void (^ack)(NSArray*)) {
        NSLog(@"socket disconnected");
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
    
    [_socket on:@"join chatroom" callback:^(NSArray* data, void (^ack)(NSArray*)) {
        NSLog(@"User joined");
        //TODO: Increment user count
        [self addUserToChatroom:[data firstObject]];
    }];
    [_socket on:@"leave chatroom" callback:^(NSArray* data, void (^ack)(NSArray*)) {
        NSLog(@"User left");
        //TODO: Cleanup
        [self removeUserFromChatroom:[data firstObject]];
    }];
}

-(void)leaveChatroom
{
    [_socket emit:@"leave chatroom" withItems:@[[PFUser currentUser]]];

    [_socket closeWithFast:false];
    [self cleanup];
}

-(void)sendMessage:(NSString *)message
{
   
    NSDate *now = [NSDate date];
    [_socket emit:@"chat message" withItems:@[@{@"senderID": @"willgu", @"roomID": @"102", @"message": message, @"date": [now description], @"isMediaMessage": @"false", @"senderDisplayName": @"Will Gu", @"messageHash": @"12o3i12"}]];

    //TODO: Send push notification to group as well
}

-(int)messageCount
{
    return [_messages count];
}
-(Message*)getMessageAtIndex:(int)index
{
    return [_messages objectAtIndex:index];
}


-(void)cleanup
{
    
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    NSManagedObjectContext *myContext = delegate.managedObjectContext;
    NSFetchRequest * allMessages = [[NSFetchRequest alloc] init];
    [allMessages setEntity:[NSEntityDescription entityForName:@"Message" inManagedObjectContext:myContext]];
    [allMessages setIncludesPropertyValues:NO]; //only fetch the managedObjectID
    
    NSError * error = nil;
    NSArray * messages = [myContext executeFetchRequest:allMessages error:&error];
    //error handling goes here
    for (Message *message in messages) {
        [myContext deleteObject:message];
    }
    NSError *saveError = nil;
    [myContext save:&saveError];
    //more error handling here
}
-(void)addUserToChatroom:(PFUser *)newUser
{
    [_users addObject:newUser];
}
-(void)removeUserFromChatroom:(PFUser *)removeUser
{
    [_users removeObject:removeUser];
}

@end
