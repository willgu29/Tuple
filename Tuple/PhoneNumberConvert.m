//
//  PhoneNumberConvert.m
//  Tuple
//
//  Created by William Gu on 2/9/15.
//  Copyright (c) 2015 William Gu. All rights reserved.
//

#import "PhoneNumberConvert.h"

@implementation PhoneNumberConvert

+(NSString *)convertPhoneNumberToOnlyNumbers:(NSString *)phoneNumber
{
    NSString *numbersOnlyPhoneNumber = [[phoneNumber componentsSeparatedByCharactersInSet:
                                         [[NSCharacterSet decimalDigitCharacterSet] invertedSet]]
                                        componentsJoinedByString:@""];
    return numbersOnlyPhoneNumber;
}

@end
