//
//  CreateAccountOnServer.h
//  Tuple
//
//  Created by William Gu on 2/7/15.
//  Copyright (c) 2015 William Gu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CreateAccountOnServer;
@protocol CreateAccountOnServerDelegate

-(void)createAccountSuccess;
-(void)createAccountWithFailure:(NSError *)error;

@end

@interface CreateAccountOnServer : NSObject

@property (nonatomic, assign) id delegate;
-(void)saveUserWithUsername:(NSString *)username andPassword:(NSString *)password andEmail:(NSString *)email andFirstName:(NSString *)firstName andLastName:(NSString *)lastName andPhoneNumber:(NSString *)phoneNumber;

@end
