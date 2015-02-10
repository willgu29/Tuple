//
//  PreSendData.h
//  Tuple
//
//  Created by William Gu on 2/8/15.
//  Copyright (c) 2015 William Gu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SendData : NSObject

@property (nonatomic, strong) NSString *theTimeToEat;
@property (nonatomic, strong) NSString *hostName; //Not set yet...
@property (nonatomic, strong) NSString *inviter;
@property (nonatomic) int minutesTillMeetup;
@property (nonatomic) int diningHallInt;
@property (nonatomic) int clientType; //1 = host, 2 = attendee



@end

/* send data will deal with the data pertaining to the meetup event and the client type. This information must be filled out for the initiator and attendees. */