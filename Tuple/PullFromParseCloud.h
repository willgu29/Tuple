//
//  PullFromParseCloud.h
//  Tuple
//
//  Created by William Gu on 2/8/15.
//  Copyright (c) 2015 William Gu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@class PullFromParseCloud;
@protocol PullFromParseCloudDelegate

-(void)pullEventSuccess:(NSArray *)eventsInvitedTo;
-(void)pullEventFailure:(NSError *)error;

@end

@interface PullFromParseCloud : NSObject

@property (nonatomic, assign) id delegate;

@end
