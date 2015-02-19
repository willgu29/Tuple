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
#import "CreateConversation.h"
#import "CreateFriendsList.h"
#import "AppDelegate.h"
@interface CreateAccountOnServer()

@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *phoneNumber;

@end

@implementation CreateAccountOnServer

-(BOOL)saveUserWithUsername:(NSString *)username andPassword:(NSString *)password andFirstName:(NSString *)firstName andLastName:(NSString *)lastName
{
    
    if ([firstName isEqualToString:@""] || [lastName isEqualToString:@""] || [username isEqualToString:@""] || [password isEqualToString:@""])
    {
        return NO;
    }
    else
    {
        _firstName = firstName;
        _lastName = lastName;
        _password = password;
        _username = username;
        return YES;
    }
    
}


-(BOOL)savePhoneNumber:(NSString *)phoneNumber andEmail:(NSString *)emailAddress
{
    if ([emailAddress isEqualToString:@""] || [phoneNumber isEqualToString:@""])
    {
        return NO;
        
    }
    else
    {
        _email = emailAddress;
        _phoneNumber = phoneNumber;
        //TODO: Phone + Email Verification
        return YES;
    }
}

-(void)createAccount
{
    
    CreateFriendsList *friendsList = [[CreateFriendsList alloc] init];
    [friendsList createParseFriendsListWithUser:_username];
    
    
    NSURL * convoID = [CreateConversation createInitialConversationWithUsername:_username];
    
    PFUser *newUser = [PFUser user];
    newUser.username = _username;
    newUser.password = _password;
    newUser.email = _email;
    newUser[@"firstName"] = _firstName;
    newUser[@"lastName"] = _lastName;
    newUser[@"deviceToken"] = [[NSUserDefaults standardUserDefaults] stringForKey:@"deviceToken"];
    newUser[@"phoneNumber"] = [PhoneNumberConvert convertPhoneNumberToOnlyNumbers:_phoneNumber];
    newUser[@"conversationID"] = convoID.absoluteString;
    newUser[@"phoneVerified"] = [NSNumber numberWithBool:NO];
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
