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
    }];
    
    [_socket on:@"chat message" callback:^(NSArray* data, void (^ack)(NSArray*)) {
        NSLog(@"DATA: %@", data);
        Message *newMessage = [[Message alloc] init];
        [newMessage safeSetValuesForKeysWithDictionary:(NSDictionary *)data dateFormatter:nil];
        [_messages addObject:data];
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
    [_socket emit:@"chat message" withItems:@[@{@"senderID": @"willgu", @"roomID": @"102", @"message": message, @"time": [NSDate date]}]];
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
