//
//  PhoneNumberConvert.m
//  Tuple
//
//  Created by William Gu on 2/9/15.
//  Copyright (c) 2015 William Gu. All rights reserved.
//

#import "PhoneNumberConvert.h"

@implementation PhoneNumberConvert

//In form (xxx)-xxx-xxxx
+(NSString *)convertPhoneNumberToOnlyNumbers:(NSString *)phoneNumber
{
    NSString *numbersOnlyPhoneNumber = [[phoneNumber componentsSeparatedByCharactersInSet:
                                         [[NSCharacterSet decimalDigitCharacterSet] invertedSet]]
                                        componentsJoinedByString:@""];
    
    if (numbersOnlyPhoneNumber.length == 11)
    {
        NSString *newStr = [numbersOnlyPhoneNumber substringFromIndex:1];
        return newStr;
    }
    else
    {
        return numbersOnlyPhoneNumber;
    }
}

@end
