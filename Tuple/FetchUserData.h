//
//  FetchUserData.h
//  Tuple
//
//  Created by William Gu on 2/8/15.
//  Copyright (c) 2015 William Gu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface FetchUserData : NSObject

+(PFUser *)lookupUsername:(NSString *)username;
+(PFUser *)lookupPhoneNumber:(NSString *)phoneNumber;
+(PFUser *)lookupDeviceToken:(NSString *)deviceToken;
+(PFObject *)lookupEventWithHost:(NSString *)hostUsername;
+(NSURL *)lookupConvoIDWithUsername:(NSString *)username;
@end
