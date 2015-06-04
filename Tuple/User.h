//
//  User.h
//  Tuple
//
//  Created by William Gu on 6/3/15.
//  Copyright (c) 2015 William Gu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Contact;

@interface User : NSManagedObject

@property (nonatomic, retain) NSString * avatarURL;
@property (nonatomic, retain) NSString * username;
@property (nonatomic, retain) NSDecimalNumber * score;
@property (nonatomic, retain) NSString * phoneNumber;
@property (nonatomic, retain) Contact *contactCard;

@end
