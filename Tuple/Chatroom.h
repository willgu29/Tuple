//
//  Chatroom.h
//  Tuple
//
//  Created by William Gu on 5/21/15.
//  Copyright (c) 2015 William Gu. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ChatroomDelegate <NSObject>

-(void)messageReceived:(NSArray *)data;
-(void)messageSendFailure:(NSError *)error;

@end

@interface Chatroom : NSObject

-(void)joinChatroom;
-(void)sendMessage:(NSString *)message;


@property (nonatomic, assign) id delegate;

@end
