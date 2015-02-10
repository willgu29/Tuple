//
//  TimeNumberConvert.m
//  Tuple
//
//  Created by William Gu on 2/9/15.
//  Copyright (c) 2015 William Gu. All rights reserved.
//

#import "TimeNumberConvert.h"

@implementation TimeNumberConvert

+(NSDate *)convertTimeMinutesToDate:(int)minutesTillMeetup
{
    NSDate *laterDate = [NSDate dateWithTimeInterval:(minutesTillMeetup*60) sinceDate:[NSDate date]];
    return laterDate;
}

+(NSString *)convertDateToCurrentTimeZone:(NSDate *)date
{
    NSLocale *currentLocale = [NSLocale currentLocale];
    return [date descriptionWithLocale:currentLocale];
}

+(NSString *)formatDateTo12HoursPmAm:(NSDate *)date
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    dateFormat.dateStyle = NSDateFormatterNoStyle;
    dateFormat.timeStyle = NSDateFormatterShortStyle;
    NSString *formatedString = [dateFormat stringFromDate:date];
    return formatedString;
}


@end
