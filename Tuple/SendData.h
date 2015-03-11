//
//  PreSendData.h
//  Tuple
//
//  Created by William Gu on 2/8/15.
//  Copyright (c) 2015 William Gu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SendData : NSObject

@property (nonatomic, strong) NSURL *conversationID;
@property (nonatomic, strong) NSString *theTimeToEat;
@property (nonatomic, strong) NSString *hostUsername;
@property (nonatomic, strong) NSString *hostName; //first name last name
@property (nonatomic, strong) NSString *currentUsername;
@property (nonatomic, strong) NSString *inviterName; //First name last name
@property (nonatomic) int minutesTillMeetup;
@property (nonatomic) int diningHallInt;
@property (nonatomic) int clientType; //1 = host, 2 = attendee
@property (nonatomic, strong) NSString *event;
@property (nonatomic, strong) NSString *eventLocation;

@end

/* send data will deal with the data pertaining to the meetup event and the client type. This information must be filled out for the initiator and attendees.  These datas will be filled out in WhereWhenVC (all of it) for the initiator and filled out in partially in finishLaunching for attendee and then GetInvites. No other locations should set these values*/