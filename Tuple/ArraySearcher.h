//
//  ArraySearcher.h
//  Tuple
//
//  Created by William Gu on 2/23/15.
//  Copyright (c) 2015 William Gu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ArraySearcher : NSObject

+(NSArray *)getTextThatBeginsWith:(NSString *)searchText inArray:(NSArray *)arrayToSearch withPath:(NSString *)pathOfString;

@end
