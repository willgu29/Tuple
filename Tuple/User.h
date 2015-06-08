//
//  User.h
//  Tuple
//
//  Created by William Gu on 6/7/15.
//  Copyright (c) 2015 William Gu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Contact, Event;

@interface User : NSManagedObject

@property (nonatomic, retain) NSString * avatarURL;
@property (nonatomic, retain) NSString * username;
@property (nonatomic, retain) NSDecimalNumber * score;
@property (nonatomic, retain) NSString * phoneNumber;
@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * fullName;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) Contact *contactCard;
@property (nonatomic, retain) NSSet *eventsCreated;
@property (nonatomic, retain) NSSet *eventsInvitedTo;
@end

@interface User (CoreDataGeneratedAccessors)

- (void)addEventsCreatedObject:(Event *)value;
- (void)removeEventsCreatedObject:(Event *)value;
- (void)addEventsCreated:(NSSet *)values;
- (void)removeEventsCreated:(NSSet *)values;

- (void)addEventsInvitedToObject:(Event *)value;
- (void)removeEventsInvitedToObject:(Event *)value;
- (void)addEventsInvitedTo:(NSSet *)values;
- (void)removeEventsInvitedTo:(NSSet *)values;

@end
