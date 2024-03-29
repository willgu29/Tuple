//
//  Chatroom.h
//  Tuple
//
//  Created by William Gu on 5/21/15.
//  Copyright (c) 2015 William Gu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Message.h"
#import "User.h"
#import <Parse/Parse.h>
@protocol ChatroomDelegate <NSObject>

-(void)chatRoomReconnected;
-(void)chatMessageReceived;
-(void)chatMessageSendFailure:(NSError *)error;
-(void)chatRoomJoinedBy:(id)data;
-(void)chatRoomLeftBy:(id)data;

@end

@interface Chatroom : NSObject

-(void)setRoomID:(NSString *)newRoomID; //REQUIRED

-(void)connectToSocket;
-(void)joinChatroom:(NSString *)roomID; //Or set it here via argument
-(void)leaveChatroom;
-(void)sendMessage:(NSString *)message;

-(NSInteger)messageCount;
-(Message*)getMessageAtIndex:(int)index;
-(void)addUserToChatroom:(PFUser *)newUser;
-(void)removeUserFromChatroom:(PFUser *)removeUser;

@property (nonatomic, assign) id delegate;
//@property (strong, nonatomic) NSDictionary *avatars; //UIImages



@end
