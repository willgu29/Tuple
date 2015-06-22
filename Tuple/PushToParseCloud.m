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
#import "AppDelegate.h"
#import "Converter.h"
#import "DeleteParseObject.h"
#import "AFNetworking.h"
#import "Event.h"
#import "Contact.h"
#import "User.h"
@interface PushToParseCloud()

@property (nonatomic, strong) NSMutableArray *phoneNumbersArray; //those without the app
@property (nonatomic, strong) NSMutableArray *deviceTokensArray; //those with the app
@property (nonatomic, strong) NSMutableArray *usernamesArray; //those with app
@end

@implementation PushToParseCloud

#pragma mark - Public Facing

-(void)createEventAt:(NSString *)location withActivity:(NSString *)activity atTime:(NSString *)time
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
    event[@"usersGoing"] = @[currentUser.username];
    event[@"contactsInvited"] = @[currentUser.username];
    event[@"inviterName"] = @"";
    [event saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            [_delegate pushEventToParseSuccess:event];
        } else {
            [_delegate pushEventToParseFailure:error];
        }
    }];
    
   
}
-(void)sendNotificationsToContacts:(NSArray *)contacts forEvent:(PFObject *)event
{
    for (int i = 0; i < [contacts count]; i++)
    {
        Contact *contact = [contacts objectAtIndex:i];
        if ([contact.hasTupleAccount isEqualToNumber:[NSNumber numberWithBool:YES]]){
            [self sendPushNotification:contact forEvent:event];
        } else {
            [self sendTextMessage:contact forEvent:event];
        }
        
    }
}

-(void)updateContactsInvited:(NSArray *)contacts forEvent:(PFObject *)event
{
    PFUser *currentUser = [PFUser currentUser];
    for (int i = 0; i < [contacts count]; i++)
    {
        Contact *contact = [contacts objectAtIndex:i];
        if ([contact.hasTupleAccount isEqualToNumber:[NSNumber numberWithBool:YES]]) {
            [event addUniqueObject:contact.userInfo.username forKey:@"contactsInvited"];
        } else {
            [event addUniqueObject:contact.phoneNumber forKey:@"contactsInvited"];
        }
    }
    event[@"inviterName"] = currentUser[@"fullName"];
    [event saveInBackground];
}

#pragma mark Private Methods

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




-(void)sendPushNotification:(Contact *)contact forEvent:(PFObject *)event
{
    
    PFUser *currentUser = [PFUser currentUser];
    User *user = contact.userInfo;
    
    
     [PFCloud callFunctionInBackground:@"hello"
                        withParameters:@{@"deviceToken": user.deviceToken, @"inviter": currentUser[@"fullName"], @"hostUsername":event[@"hostID"] , @"event" : event[@"activity"], @"eventLocation": event[@"location"], @"eventTime": event[@"time"]} block:^(id object, NSError *error) {
         if (!error) {
             NSLog(@"RESULTS: %@", object);
         } else {
             [_delegate sendInvitesFailure:error];
         }
     
     }];
}
-(void)sendTextMessage:(Contact *)contact forEvent:(PFObject *)event
{
    PFUser *currentUser = [PFUser currentUser];
    
    NSString *defaultMessage = [NSString stringWithFormat:@"%@ has invited you to %@ at %@ and %@", currentUser[@"fullName"], event[@"activity"], event[@"location"], event[@"time"]];
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *tuple = @"http://tupleapp.com/twilio/sms/";
    NSString *encoded = [NSString stringWithUTF8String:[tuple UTF8String]];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
      
        NSDictionary *body = @{@"number" : contact.phoneNumber, @"message" : defaultMessage};
        [manager POST:encoded parameters:body success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                
        }];
            
        
    });
    
    
}


@end
