//
//  PreSendData.h
//  Tuple
//
//  Created by William Gu on 2/8/15.
//  Copyright (c) 2015 William Gu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PreSendData : NSObject

@property (nonatomic) int minutesTillMeetup;
@property (nonatomic) int diningHallInt;
@property (nonatomic) int clientType; //1 = host, 2 = attendee

@end

/* Pre send data will deal with the data of the initiator. This person that wants to start the chatroom and event time. */