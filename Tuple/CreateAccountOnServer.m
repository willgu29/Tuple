//
//  CreateAccountOnServer.m
//  Tuple
//
//  Created by William Gu on 2/7/15.
//  Copyright (c) 2015 William Gu. All rights reserved.
//

#import "CreateAccountOnServer.h"
#import <Parse/Parse.h>
#import "PhoneNumberConvert.h"
@interface CreateAccountOnServer()

@end

@implementation CreateAccountOnServer

-(void)saveUserWithUsername:(NSString *)username andPassword:(NSString *)password andEmail:(NSString *)email andFirstName:(NSString *)firstName andLastName:(NSString *)lastName andPhoneNumber:(NSString *)phoneNumber
{
    
    PFUser *newUser = [PFUser user];
    newUser.username = username;
    newUser.password = password;
    newUser.email = email;
    newUser[@"firstName"] = firstName;
    newUser[@"lastName"] = lastName;
    newUser[@"deviceToken"] = [[NSUserDefaults standardUserDefaults] stringForKey:@"deviceToken"];
    newUser[@"phoneNumber"] = [PhoneNumberConvert convertPhoneNumberToOnlyNumbers:phoneNumber];
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            // Hooray! Let them use the app now.
            [_delegate createAccountSuccess];
        } else {
            [_delegate createAccountWithFailure:error];
            // Show the errorString somewhere and let the user try again.
        }
    }];
    
}



@end
