//
//  DiningHallConvert.m
//  Tuple
//
//  Created by William Gu on 2/9/15.
//  Copyright (c) 2015 William Gu. All rights reserved.
//

#import "DiningHallConvert.h"

@implementation DiningHallConvert

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
