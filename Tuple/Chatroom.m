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

@end

@implementation Chatroom




-(void)joinChatroom
{
    _socket = [[SocketIOClient alloc] initWithSocketURL:@"http://tupleapp.com" options:nil];
    
    [_socket on:@"connect" callback:^(NSArray* data, void (^ack)(NSArray*)) {
        NSLog(@"socket connected");
    }];
    
    [_socket on:@"chat message" callback:^(NSArray* data, void (^ack)(NSArray*)) {
        NSLog(@"DATA: %@", data);
    }];
    
    [_socket connect];
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
