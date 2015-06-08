//
//  PushToParseCloud.h
//  Degrees
//
//  Created by William Gu on 2/7/15.
//  Copyright (c) 2015 William Gu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@class PushToParseCloud;
@protocol PushToParseCloudDelegate

-(void)sendInvitesSuccess;
-(void)sendInvitesFailure:(NSError *)error;
-(void)pushEventToParseSuccess:(PFObject *)event;
-(void)pushEventToParseFailure:(NSError *)error;

@end

@interface PushToParseCloud : NSObject

@property (nonatomic, assign) id delegate;

-(void)createEvent:(NSString *)location withActivity:(NSString *)activity atTime:(NSString *)time;
-(void)sendNotificationsToContacts:(NSArray *)contacts forEvent:(PFObject *)event;

@end

