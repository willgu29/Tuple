//
//  PushToParseCloud.m
//  Degrees
//
//  Created by William Gu on 2/7/15.
//  Copyright (c) 2015 William Gu. All rights reserved.
//

#import "PushToParseCloud.h"

@interface PushToParseCloud()

@property (nonatomic, strong) NSMutableArray *phoneNumbersArray; //those without the app
@property (nonatomic, strong) NSMutableArray *deviceTokensArray; //those with the app

@end

@implementation PushToParseCloud

-(void)separateAppUsersFromContacts:(NSArray *)selectedArray
{
    
}

-(void)sendDeviceTokensToCloud:(NSArray *)peopleArray
{
    
}

@end
