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
#import "DeleteParseObject.h"
#import "AFNetworking.h"
#import "PhoneNumberConvert.h"

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

-(void)getRidOfDuplicates
{
    
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
   
    NSString *inviter = delegate.sendData.inviterName;
    NSString *hostUsername = delegate.sendData.hostUsername;
    int diningHallInt = delegate.sendData.diningHallInt;
    NSString *timeToEat = delegate.sendData.theTimeToEat;
    
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
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    NSString *messageToSend = [NSString stringWithFormat:@"%@ would like to eat at %@.  Download Tuple on the App Store or visit tupleapp.com/download", delegate.sendData.inviterName, delegate.sendData.theTimeToEat];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    for (NSString *phoneNumber in phoneArray)
    {
        NSString *numbersOnly = [PhoneNumberConvert convertPhoneNumberToOnlyNumbers:phoneNumber];
        NSString *postURL =  [NSString stringWithFormat:@"https://rest.nexmo.com/sms/json?api_key=7b892d9a&api_secret=ddb44b4f&from=12198527594&to=%@&text=%@", numbersOnly, messageToSend]; //Requires UTF8 encoded (URL and UTF8)
        NSString *encoded = [postURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

        [manager GET:encoded parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"JSON: %@", responseObject);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
        }];
    }
}

#pragma mark - Push Event To Cloud
-(void)pushEventToParse:(NSArray *)usernames
{
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
        
    
    if (delegate.sendData.clientType == 2)
    {
        PFUser *user = [PFUser currentUser];
        PFQuery *query = [PFQuery queryWithClassName:@"Events"];
        [query whereKey:@"hostUsername" equalTo:delegate.sendData.hostUsername];
        PFObject *eventObject = (PFObject *)[query getFirstObject];
        NSMutableSet *usersInvited = eventObject[@"usersInvited"];
        NSMutableArray *peopleInChatroom = eventObject[@"peopleInChatRoom"];
        [peopleInChatroom addObject:user.username];
        [usersInvited addObjectsFromArray:usernames];
        eventObject[@"usersInvited"] = usersInvited;
        [eventObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                [self sendDeviceTokensToCloud:_deviceTokensArray];
                [self sendMessageToPhoneNumbers:_phoneNumbersArray];
            } else {
                [_delegate pushEventToParseFailure:error];
            }
        }];
        return;
    }
    
    [DeleteParseObject deleteCurrentUserEventFromParse];
    
    PFObject *event = [PFObject objectWithClassName:@"Events"];
    event[@"inviterName"] = delegate.sendData.inviterName;
    event[@"hostUsername"] = delegate.sendData.hostUsername;
    event[@"hostName"] = delegate.sendData.hostName;
    event[@"diningHall"] = [NSString stringWithFormat:@"%d", delegate.sendData.diningHallInt];
    event[@"whenToEat"] = delegate.sendData.theTimeToEat;
    event[@"peopleInChatRoom"] = [NSArray arrayWithObject:delegate.sendData.hostUsername];
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
