//
//  ArraySorter.m
//  Tuple
//
//  Created by William Gu on 2/13/15.
//  Copyright (c) 2015 William Gu. All rights reserved.
//

#import "ArraySorter.h"
#import "UserCellInfo.h"

@implementation ArraySorter

+(NSArray *)sortArrayAlphabetically:(NSArray *)array
{
    NSArray *sortedArray;
    sortedArray = [array sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSString *firstName1 = [(UserCellInfo *)obj1 firstName];
        NSString *firstName2 = [(UserCellInfo *)obj2 firstName];
        return [firstName1 compare:firstName2];
    }];
    return sortedArray;
}


@end
