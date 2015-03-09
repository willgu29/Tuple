//
//  Converter.m
//  Tuple
//
//  Created by William Gu on 2/21/15.
//  Copyright (c) 2015 William Gu. All rights reserved.
//

#import "Converter.h"

@implementation Converter

#pragma mark - Time Convert

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

#pragma mark - Phone number convert

//In form 1-(xxx)-xxx-xxxx
+(NSString *)convertPhoneNumberToOnlyNumbers:(NSString *)phoneNumber
{
    NSString *numbersOnlyPhoneNumber = [[phoneNumber componentsSeparatedByCharactersInSet:
                                         [[NSCharacterSet decimalDigitCharacterSet] invertedSet]]
                                        componentsJoinedByString:@""];
    
    if (numbersOnlyPhoneNumber.length == 11)
    {
        return numbersOnlyPhoneNumber;
    }
    else
    {
        NSString *newStr = [NSString stringWithFormat:@"1%@",numbersOnlyPhoneNumber];
        return newStr;
    }
}

#pragma mark - dining hall convert

+(NSString *)convertDiningHallIntToString:(int)diningHallInt
{
    if (diningHallInt == 0)
    {
        return @"No Preference";
    }
    else if (diningHallInt == 1)
    {
        return @"De Neve";
    }
    else if (diningHallInt == 2)
    {
        return @"B Plate";
    }
    else if (diningHallInt == 3)
    {
        return @"Feast";
    }
    else if (diningHallInt == 4)
    {
        return @"Covel";
    }
    else if (diningHallInt == 5)
    {
        return @"Rendezvous";
    }
    else if (diningHallInt == 6)
    {
        return @"Cafe 1919";
    }
    else if (diningHallInt == 7)
    {
        return @"B Cafe";
    }
    else
    {
        [NSException raise:@"Invalid Dining Hall Value" format:@"%d number must be inbetween 0 and 7", diningHallInt];
    }
    return nil;
}

@end
