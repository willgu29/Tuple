//
//  PushToParseCloud.h
//  Degrees
//
//  Created by William Gu on 2/7/15.
//  Copyright (c) 2015 William Gu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PushToParseCloud;
@protocol PushToParseCloudDelegate

-(void)sendInvitesSuccess:(NSArray *)deviceTokenArray;
-(void)sendInvitesFailure:(NSError *)error;
//-(void)pushEventToParseSuccess;
-(void)pushEventToParseFailure:(NSError *)error;

@end

@interface PushToParseCloud : NSObject

@property (nonatomic, assign) id delegate;
-(void)separateAppUsersFromContactsAndSendPush:(NSArray *)selectedArray;

@end

/* Data Flow: -> separateApp -> Call push parse event -> on success -> sendInvites -> on success segue  */