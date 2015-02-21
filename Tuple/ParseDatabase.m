//
//  FetchUserData.m
//  Tuple
//
//  Created by William Gu on 2/8/15.
//  Copyright (c) 2015 William Gu. All rights reserved.
//

#import "ParseDatabase.h"
#import "PhoneNumberConvert.h"

@implementation ParseDatabase

+(PFUser *)lookupUsername:(NSString *)username
{
    if (username == nil)
    {
        return nil;
    }
    PFQuery *query = [PFUser query];
    [query whereKey:@"username" equalTo:username];
    PFUser *user = (PFUser *)[query getFirstObject];
    return user;
    
}

+(PFUser *)lookupPhoneNumber:(NSString *)phoneNumber
{
    NSString *justNumbersPhoneNumber = [PhoneNumberConvert convertPhoneNumberToOnlyNumbers:phoneNumber];
    PFQuery *query = [PFUser query];
    [query whereKey:@"phoneNumber" equalTo:justNumbersPhoneNumber];
    PFUser *user = (PFUser *)[query getFirstObject];
    return user;
}
+(PFUser *)lookupDeviceToken:(NSString *)deviceToken
{
    if (deviceToken == nil)
    {
        return nil;
    }
    PFQuery *query = [PFUser query];
    [query whereKey:@"deviceToken" equalTo:deviceToken];
    PFUser *user = (PFUser *)[query getFirstObject];
    return user;
}
+(PFObject *)lookupEventWithHost:(NSString *)hostUsername
{
    if (hostUsername == nil)
    {
        return nil;
    }
    PFQuery *query = [PFQuery queryWithClassName:@"Events"];
    [query whereKey:@"hostUsername" equalTo:hostUsername];
    PFObject *eventObject =[query getFirstObject];
    return eventObject;
}


+(BOOL)getPhoneVerificationStatusCurrentUser
{
    PFUser *user = [self lookupUsername:[PFUser currentUser].username];
    NSNumber *phoneStatus =  user[@"phoneVerified"];
    return phoneStatus.boolValue;
}

+(NSString *)getCurrentUserFirstAndLastNameFormattedString
{
    PFUser *user = [PFUser currentUser];
    NSString *firstName = user[@"firstName"];
    NSString *lastName = user[@"lastName"];
    NSString *format = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
    return format;
}

@end
