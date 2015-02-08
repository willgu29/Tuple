//
//  UserCellDisplayInfo.h
//  Tuple
//
//  Created by William Gu on 2/8/15.
//  Copyright (c) 2015 William Gu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserCellInfo : NSObject

@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *phoneNumber;
@property (nonatomic, strong) NSString *deviceToken;
@property (nonatomic) BOOL emailVerified;
@property (nonatomic) int userType; //check UserTypeEnums for types

@end
