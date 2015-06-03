//
//  Chatroom.m
//  Tuple
//
//  Created by William Gu on 5/21/15.
//  Copyright (c) 2015 William Gu. All rights reserved.
//

#import "Chatroom.h"
#import "Tuple-Swift.h"

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
        [_delegate messageReceived:data];
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
    [_socket emit:@"chat message" withItems:@[@{@"roomID": @"100", @"message": message}]];
}
@end
