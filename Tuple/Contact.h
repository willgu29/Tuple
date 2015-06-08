//
//  Contact.h
//  Tuple
//
//  Created by William Gu on 6/7/15.
//  Copyright (c) 2015 William Gu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class User;

@interface Contact : NSManagedObject

@property (nonatomic, retain) NSString * phoneNumber;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSNumber * hasTupleAccount;
@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * fullName;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSNumber * isSelected;
@property (nonatomic, retain) User *userInfo;

@end
