//
//  PushToParseCloud.m
//  Degrees
//
//  Created by William Gu on 2/7/15.
//  Copyright (c) 2015 William Gu. All rights reserved.
//

#import "PushToParseCloud.h"
#import "UserCellInfo.h"
#import "UserTypeEnums.h"

@interface PushToParseCloud()

@property (nonatomic, strong) NSMutableArray *phoneNumbersArray; //those without the app
@property (nonatomic, strong) NSMutableArray *deviceTokensArray; //those with the app

@end

@implementation PushToParseCloud

-(instancetype)init
{
    self = [super init];
    if (self)
    {
        _phoneNumbersArray = [[NSMutableArray alloc] init];
        _deviceTokensArray = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)separateAppUsersFromContacts:(NSArray *)selectedArray
{
    for (UserCellInfo *userInfo in selectedArray)
    {
        if (userInfo.userType == IS_CONTACT_NO_APP)
        {
            [_phoneNumbersArray addObject:userInfo.phoneNumber];
        }
        else if (userInfo.userType == IS_CONTACT_WITH_APP)
        {
            [_deviceTokensArray addObject:userInfo.deviceToken];
        }
    }
}

-(void)sendDeviceTokensToCloud:(NSArray *)peopleArray
{
    
}

-(void)sendMessageToPhoneNumbers:(NSArray *)phoneArray
{
    
}
@end
