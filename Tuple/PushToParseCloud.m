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
#import "Event.h"

@interface PushToParseCloud()

@property (nonatomic, strong) NSMutableArray *phoneNumbersArray; //those without the app
@property (nonatomic, strong) NSMutableArray *deviceTokensArray; //those with the app
@property (nonatomic, strong) NSMutableArray *usernamesArray; //those with app
@end

@implementation PushToParseCloud

-(void)createEvent:(NSString *)location withActivity:(NSString *)activity atTime:(NSString *)time
{
    PFUser *currentUser = [PFUser currentUser];
   NSString *uuid = [[NSUUID UUID] UUIDString];
    PFObject *event = [PFObject objectWithClassName:@"Event"];
    event[@"UUID"] = uuid;
    event[@"location"] = location;
    event[@"activity"] = activity;
    event[@"time"] = time;
    event[@"hostID"] = currentUser.username;
    event[@"hostName"] = [self getFullNameFromUser:currentUser];
    event[@"usersInChatroom"] = @[];
    
    [event saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            [_delegate pushEventToParseSuccess:uuid];
        } else {
            [_delegate pushEventToParseFailure:error];
        }
    }];
    
   
}

-(void)saveToContext:(PFObject *)event
{
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    NSManagedObjectContext *context = [delegate managedObjectContext];
    Event *newEvent = [NSEntityDescription insertNewObjectForEntityForName:@"Event" inManagedObjectContext:context];
    newEvent.hostID = event[@"hostID"];
    newEvent.hostName = event[@"hostName"];
    newEvent.location = event[@"location"];
    newEvent.activity = event[@"activity"];
    newEvent.time = event[@"time"];

//    newEvent.usersInChatroom =
}

-(NSString *)getFullNameFromUser:(PFUser *)currentUser
{
    if (currentUser[@"fullName"]){
        return currentUser[@"fullName"];
    } else {
        return [NSString stringWithFormat:@"%@ %@", currentUser[@"firstName"], currentUser[@"lastName"]];
    }
}

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


-(void)sendDeviceTokensToCloud:(NSArray *)deviceTokenArray
{
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;

    /* Reimplement push notifications
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
     */
    
}

//phoneArray already parsed to 11 digits
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




@end
