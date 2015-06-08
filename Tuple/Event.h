//
//  Event.h
//  Tuple
//
//  Created by William Gu on 6/7/15.
//  Copyright (c) 2015 William Gu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Contact, User;

@interface Event : NSManagedObject

@property (nonatomic, retain) NSString * activity;
@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) NSString * time;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * hostName;
@property (nonatomic, retain) NSString * hostID;
@property (nonatomic, retain) User *inviter;
@property (nonatomic, retain) User *host;
@property (nonatomic, retain) NSSet *usersInChatroom;
@property (nonatomic, retain) NSSet *contactsInvited;
@end

@interface Event (CoreDataGeneratedAccessors)

- (void)addUsersInChatroomObject:(User *)value;
- (void)removeUsersInChatroomObject:(User *)value;
- (void)addUsersInChatroom:(NSSet *)values;
- (void)removeUsersInChatroom:(NSSet *)values;

- (void)addContactsInvitedObject:(Contact *)value;
- (void)removeContactsInvitedObject:(Contact *)value;
- (void)addContactsInvited:(NSSet *)values;
- (void)removeContactsInvited:(NSSet *)values;

@end
