//
//  Event.h
//  Tuple
//
//  Created by William Gu on 6/3/15.
//  Copyright (c) 2015 William Gu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Event : NSManagedObject

@property (nonatomic, retain) NSString * activity;
@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) NSString * time;
@property (nonatomic, retain) NSString * title;

@end

//Old event
//@property (nonatomic, strong) NSString *eventID;
//@property (nonatomic, strong) NSString *eventTime;
//@property (nonatomic, strong) NSString *hostUsername;
//@property (nonatomic, strong) NSString *hostName; //first name last name
//@property (nonatomic, strong) NSString *currentUsername;
//@property (nonatomic, strong) NSString *inviterName; //First name last name
//@property (nonatomic) int minutesTillMeetup;
//@property (nonatomic) int clientType; //1 = host, 2 = attendee
//@property (nonatomic, strong) NSString *event;
//@property (nonatomic, strong) NSString *eventLocation;
//@property (nonatomic) BOOL isAttending;