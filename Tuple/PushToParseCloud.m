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
#import "TimeNumberConvert.h"
#import "FetchUserData.h"

@interface PushToParseCloud()

@property (nonatomic, strong) NSMutableArray *phoneNumbersArray; //those without the app
@property (nonatomic, strong) NSMutableArray *deviceTokensArray; //those with the app
@property (nonatomic, strong) NSMutableArray *usernamesArray; //those with app
@end

@implementation PushToParseCloud

-(instancetype)init
{
    self = [super init];
    if (self)
    {
        _phoneNumbersArray = [[NSMutableArray alloc] init];
        _deviceTokensArray = [[NSMutableArray alloc] init];
        _usernamesArray = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)separateAppUsersFromContactsAndSendPush:(NSArray *)selectedArray
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
            [_usernamesArray addObject:userInfo.username];
        }
    }
    [self pushEventToParse:_usernamesArray];
}

-(void)sendDeviceTokensToCloud:(NSArray *)deviceTokenArray
{
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    int diningHallInt;
    NSString *hostUsername;
    NSString *inviter;
    NSString *timeToEat;
    if (delegate.sendData.clientType == 1)
    {
        PFUser *user = [PFUser currentUser];
        hostUsername = user.username;
        inviter = [NSString stringWithFormat:@"%@ %@", user[@"firstName"], user[@"lastName"]];
        diningHallInt = delegate.sendData.diningHallInt;
        timeToEat = delegate.sendData.theTimeToEat;
        
    }
    else if (delegate.sendData.clientType == 2)
    {
        
    }
    delegate.sendData.hostUsername = hostUsername;
    delegate.sendData.inviter = inviter;
    NSString *diningHallString = [NSString stringWithFormat:@"%d", diningHallInt];
    [PFCloud callFunctionInBackground:@"hello"
                       withParameters:@{@"deviceTokenArray": deviceTokenArray, @"inviter": inviter, @"hostUsername":hostUsername , @"diningHall": diningHallString, @"timeToEat": timeToEat}
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

#pragma mark - Push Event To Cloud
-(void)pushEventToParse:(NSArray *)usernames
{
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
        
    
    PFObject *event = [PFObject objectWithClassName:@"Events"];
    event[@"hostUsername"] = delegate.sendData.hostUsername;
    event[@"diningHall"] = [NSString stringWithFormat:@"%d", delegate.sendData.diningHallInt];
    event[@"whenToEat"] = delegate.sendData.theTimeToEat;
    event[@"peopleInChatRoom"] = [NSString stringWithFormat:@"1"];
    event[@"usersInvited"] = usernames;
    
    [event saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            [self sendDeviceTokensToCloud:_deviceTokensArray];
            [self sendMessageToPhoneNumbers:_phoneNumbersArray];
        } else {
            [_delegate pushEventToParseFailure:error];
        }
        
    }];
}







@end
