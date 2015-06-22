//
//  SocketIO.h
//  Tuple
//
//  Created by William Gu on 6/22/15.
//  Copyright (c) 2015 William Gu. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SocketIODelegate <NSObject>

-(void)userReconnected;
-(void)channelJoinedBy:(id)data;
-(void)chanellLeftBy:(id)data;


@end

@interface SocketIO : NSObject

@property (nonatomic, assign) id delegate;


-(void)connectToSocket;
-(void)disconnectFromSocket;

-(void)joinChannelID:(NSString *)channelID;
-(void)leaveChannel;


//-(void)sendMessage:(NSString *)message;





@end
