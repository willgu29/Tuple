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
    _socket = [[SocketIOClient alloc] initWithSocketURL:@"localhost:8080" options:nil];
}

-(void)leaveChatroom
{
    [_socket closeWithFast:false];
}

-(void)chatroom
{
    SocketIOClient* socket = [[SocketIOClient alloc] initWithSocketURL:@"http://tupleapp.com" options:nil];
    
    [socket on:@"connect" callback:^(NSArray* data, void (^ack)(NSArray*)) {
        NSLog(@"socket connected");
    }];
    
    [socket on:@"currentAmount" callback:^(NSArray* data, void (^ack)(NSArray*)) {
        double cur = [[data objectAtIndex:0] floatValue];
        
        [socket emitWithAck:@"canUpdate" withItems:@[@(cur)]](0, ^(NSArray* data) {
            [socket emit:@"update" withItems:@[@{@"amount": @(cur + 2.50)}]];
        });
        
        ack(@[@"Got your currentAmount, ", @"dude"]);
    }];
    
    [socket connect];
}
@end
