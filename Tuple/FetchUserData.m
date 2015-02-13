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

+(NSURL *)lookupConvoIDWithUsername:(NSString *)username
{
    PFUser *user = [FetchUserData lookupUsername:username];
    NSString *convoID =  user[@"conversationID"];
    NSURL *convoIDNSURL  = [NSURL URLWithString:convoID];
    return convoIDNSURL;
}


@end
