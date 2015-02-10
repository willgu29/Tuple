//
//  TimeNumberConvert.h
//  Tuple
//
//  Created by William Gu on 2/9/15.
//  Copyright (c) 2015 William Gu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimeNumberConvert : NSObject

+(NSDate *)convertTimeMinutesToDate:(int)minutesTillMeetup;
+(NSString *)convertDateToCurrentTimeZone:(NSDate *)date;
+(NSString *)formatDateTo12HoursPmAm:(NSDate *)date;

@end
