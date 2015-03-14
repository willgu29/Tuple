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
#import "Converter.h"
#import "DeleteParseObject.h"
#import "AFNetworking.h"

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
            NSString *numbersOnly = [Converter convertPhoneNumberToOnlyNumbers:userInfo.phoneNumber];
            [_phoneNumbersArray addObject:numbersOnly];
        }
        else if (userInfo.userType == IS_CONTACT_WITH_APP)
        {
            [_deviceTokensArray addObject:userInfo.deviceToken];
            [_usernamesArray addObject:userInfo.username];
        }
    }
    [self pushEventToParse:_usernamesArray andNumbers:_phoneNumbersArray];
}

-(void)sendDeviceTokensToCloud:(NSArray *)deviceTokenArray
{
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    
    NSString *inviter = delegate.sendData.inviterName;
    NSString *hostUsername = delegate.sendData.hostUsername;
    NSString *eventTime = delegate.sendData.eventTime;
    NSString *event = delegate.sendData.event;
    NSString *eventLocation = delegate.sendData.eventLocation;
    
    [PFCloud callFunctionInBackground:@"hello"
                       withParameters:@{@"deviceTokenArray": deviceTokenArray, @"inviter": inviter, @"hostUsername":hostUsername , @"event" : event, @"eventLocation": eventLocation, @"eventTime": eventTime}
                                block:^(id object, NSError *error) {
                                    if (!error) {
                                        // this is where you handle the results and change the UI.
                                        NSLog(@"RESULTS: %@", object);
                                    }
                                    else
                                    {
                                        [_delegate sendInvitesFailure:error];
                                    }
                                    
                                }];
    
}

//phoneArray already parsed to 10 digits
-(void)sendMessage:(NSString *)message  ToPhoneNumbers:(NSArray *)phoneArray
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *tuple = @"http://tupleapp.com/twilio/sms/";
    NSString *encoded = [NSString stringWithUTF8String:[tuple UTF8String]];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (NSString *phoneNumber in phoneArray)
        {
            NSDictionary *body = @{@"number" : phoneNumber, @"message" : message};
            [manager POST:encoded parameters:body success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                
            }];
        
        }
    });
   
}

#pragma mark - Push Event To Cloud
-(void)pushEventToParse:(NSArray *)usernames andNumbers:(NSArray *)phoneNumbers
{
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    PFUser *user = [PFUser currentUser];

    NSString *textMessage = [NSString stringWithFormat:@"%@ wants to %@ at %@ at %@ via tuple.",  delegate.sendData.inviterName, delegate.sendData.event, delegate.sendData.eventLocation, delegate.sendData.eventTime];
    
    PFObject *event;
    NSString *uuid = [[NSUUID UUID] UUIDString];

    if (delegate.sendData.clientType == 1) //create event
    {
        NSMutableArray *invitedAndHost = [NSMutableArray arrayWithArray:usernames];
        [invitedAndHost addObject:user.username];
        [DeleteParseObject deleteCurrentUserEventFromParse];
        event = [PFObject objectWithClassName:@"Events"];
        event[@"inviterName"] = delegate.sendData.inviterName;
        event[@"hostUsername"] = delegate.sendData.hostUsername;
        event[@"hostName"] = delegate.sendData.hostName;
        event[@"event"] = delegate.sendData.event;
        event[@"eventLocation"] = delegate.sendData.eventLocation;
        event[@"eventTime"] = delegate.sendData.eventTime;
        event[@"peopleAttending"] = [NSArray arrayWithObject:delegate.sendData.hostUsername];
        event[@"peopleDeclined"] = @[];
        event[@"phoneNumbersInvited"] = [NSArray arrayWithArray:_phoneNumbersArray];
        event[@"hostPhoneNumber"] = user[@"phoneNumber"];
        event[@"usersInvited"] = invitedAndHost;
        event[@"eventID"] = uuid;

        delegate.sendData.eventID = uuid;
    }
    else if (delegate.sendData.clientType == 2) //update event
    {
        PFQuery *query = [PFQuery queryWithClassName:@"Events"];
        [query whereKey:@"eventID" equalTo:delegate.sendData.eventID];
        event = (PFObject *)[query getFirstObject];
        if (delegate.sendData.isAttending)
        {
            [event addUniqueObject:user.username forKey:@"peopleAttending"];
            [event addUniqueObjectsFromArray:usernames forKey:@"usersInvited"];
            [event addUniqueObjectsFromArray:phoneNumbers forKey:@"phoneNumbersInvited"];
        }
        else
        {
            [event addUniqueObject:user.username forKey:@"peopleDeclined"];
        }
        
    }
    
    
    [event saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            [_delegate pushEventToParseSuccess:uuid];
            [self sendDeviceTokensToCloud:_deviceTokensArray];
            [self sendMessage:textMessage ToPhoneNumbers:_phoneNumbersArray];
        } else {
            [_delegate pushEventToParseFailure:error];
        }
        
    }];
    
    
 
    
}


//Nexmo
//NSString *postURL =  [NSString stringWithFormat:@"https://rest.nexmo.com/sms/json?api_key=7b892d9a&api_secret=ddb44b4f&from=12198527594&to=%@&text=%@", phoneNumber, messageToSend]; //Requires UTF8 encoded (URL and UTF8)
//NSString *encoded = [postURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];






@end
