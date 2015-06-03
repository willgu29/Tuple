//
//  Chatroom.h
//  Tuple
//
//  Created by William Gu on 5/21/15.
//  Copyright (c) 2015 William Gu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Message.h"
@protocol ChatroomDelegate <NSObject>

-(void)chatMessageReceived;
-(void)chatMessageSendFailure:(NSError *)error;

@end

@interface Chatroom : NSObject

-(void)joinChatroom;
-(void)sendMessage:(NSString *)message;

-(int)messageCount;
-(Message*)getMessageAtIndex:(int)index;


@property (nonatomic, assign) id delegate;

@end
