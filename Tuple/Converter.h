//
//  Converter.h
//  Tuple
//
//  Created by William Gu on 2/21/15.
//  Copyright (c) 2015 William Gu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Converter : NSObject

+(NSDate *)convertTimeMinutesToDate:(int)minutesTillMeetup;
+(NSString *)convertDateToCurrentTimeZone:(NSDate *)date;
+(NSString *)formatDateTo12HoursPmAm:(NSDate *)date;
+(NSString *)convertPhoneNumberToOnlyNumbers:(NSString *)phoneNumber; // 10 digit form xxx-xxx-xxxx
+(NSString *)convertDiningHallIntToString:(int)diningHallInt; //check imple values


@end
