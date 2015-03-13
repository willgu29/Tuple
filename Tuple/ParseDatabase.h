//
//  FetchUserData.h
//  Tuple
//
//  Created by William Gu on 2/8/15.
//  Copyright (c) 2015 William Gu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface ParseDatabase : NSObject

+(PFUser *)lookupUsername:(NSString *)username;
+(PFUser *)lookupPhoneNumber:(NSString *)phoneNumber;
+(PFUser *)lookupDeviceToken:(NSString *)deviceToken;
+(PFObject *)lookupEventWithHost:(NSString *)hostUsername;
+(BOOL)getPhoneVerificationStatusCurrentUser;
+(NSString *)getCurrentUserFirstAndLastNameFormattedString;
+(PFObject *)lookupEventWithID:(NSString *)uuid;

@end
