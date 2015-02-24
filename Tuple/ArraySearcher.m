//
//  ArraySearcher.m
//  Tuple
//
//  Created by William Gu on 2/23/15.
//  Copyright (c) 2015 William Gu. All rights reserved.
//

#import "ArraySearcher.h"

@implementation ArraySearcher


+(NSArray *)getTextThatBeginsWith:(NSString *)searchText inArray:(NSArray *)arrayToSearch withPath:(NSString *)pathOfString
{
    NSString *predicateFormat = @"%K BEGINSWITH[cd] %@";
    //    NSString *searchAttribute = @"self";
//    NSString *searchAttribute = @"self.name";
    NSString *searchAttribute = pathOfString;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateFormat, searchAttribute, searchText];
    
    //BEGINSWITH, ENDSWITH LIKE MATCHES CONTAINS

    
    return [arrayToSearch filteredArrayUsingPredicate:predicate];
    
   
}

@end
