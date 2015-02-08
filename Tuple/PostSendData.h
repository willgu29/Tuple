//
//  PostSendData.h
//  Tuple
//
//  Created by William Gu on 2/8/15.
//  Copyright (c) 2015 William Gu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PostSendData : NSObject

@property (nonatomic) BOOL acceptedInvite;
@property (nonatomic, strong) NSArray *postPushNotificationsDeviceTokensArray;
@property (nonatomic, strong) NSString *diningHallName;
@property (nonatomic, strong) NSDate *meetupTime;

@end

/* Post send data will deal with those degrees of separation of which people can continue adding people, however since the time and dining hall has already been decided, these need to conveyed instead of chosen */