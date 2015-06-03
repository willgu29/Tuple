//
//  NSManagedObject.h
//  TheFactoryCode
//
//  Created by William Gu on 6/3/15.
//  Copyright (c) 2015 William Gu. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObject (WGMethods)

- (void)safeSetValuesForKeysWithDictionary:(NSDictionary *)keyedValues dateFormatter:(NSDateFormatter *)dateFormatter;

@end
