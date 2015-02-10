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
#import <Parse/Parse.h>
#import "AppDelegate.h"

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
    if ([selectedArray count] == 0)
    {
        NSError *error = [[NSError alloc] initWithDomain:@"Please select people to send invites to!" code:15 userInfo:nil];
        [_delegate sendInvitesFailure:error];
        return;
    }
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
    [self sendDeviceTokensToCloud:_deviceTokensArray];
    [self sendMessageToPhoneNumbers:_phoneNumbersArray];
}

-(void)sendDeviceTokensToCloud:(NSArray *)deviceTokenArray
{
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    int diningHallInt;
    NSString *hostName;
    int minutesTillMeetup;
    if (delegate.sendData.clientType == 1)
    {
        PFUser *user = [PFUser currentUser];
        hostName = [NSString stringWithFormat:@"%@ %@", user[@"firstName"], user[@"lastName"]];
        diningHallInt = delegate.sendData.diningHallInt;
        minutesTillMeetup = delegate.sendData.minutesTillMeetup;
    }
    else if (delegate.sendData.clientType == 2)
    {
        
    }
    delegate.sendData.hostName = hostName;
    NSString *diningHallString = [NSString stringWithFormat:@"%d", diningHallInt];
    NSString *minutesString = [NSString stringWithFormat:@"%d", minutesTillMeetup];
    [PFCloud callFunctionInBackground:@"hello"
                       withParameters:@{@"deviceTokenArray": deviceTokenArray, @"hostName":hostName , @"diningHall": diningHallString, @"inMinutes": minutesString}
                                block:^(id object, NSError *error) {
                                    if (!error) {
                                        // this is where you handle the results and change the UI.
                                        NSLog(@"RESULTS: %@", object);
                                        [_delegate sendInvitesSuccess];
                                    }
                                    else
                                    {
                                        [_delegate sendInvitesFailure:error];
                                    }
                                    
                                }];
    
}

-(void)sendMessageToPhoneNumbers:(NSArray *)phoneArray
{
    
}
@end
