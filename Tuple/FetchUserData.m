//
//  FetchUserData.m
//  Tuple
//
//  Created by William Gu on 2/8/15.
//  Copyright (c) 2015 William Gu. All rights reserved.
//

#import "FetchUserData.h"
#import "PhoneNumberConvert.h"

@implementation FetchUserData

+(PFUser *)lookupUsername:(NSString *)username
{
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
    PFQuery *query = [PFUser query];
    [query whereKey:@"deviceToken" equalTo:deviceToken];
    PFUser *user = (PFUser *)[query getFirstObject];
    return user;
}
+(PFObject *)lookupEventWithHost:(NSString *)hostUsername
{
    PFQuery *query = [PFQuery queryWithClassName:@"Events"];
    [query whereKey:@"hostUsername" equalTo:hostUsername];
    PFObject *eventObject =[query getFirstObject];
    return eventObject;
}


@end
