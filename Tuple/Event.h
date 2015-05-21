//
//  Event.h
//  Tuple
//
//  Created by William Gu on 5/21/15.
//  Copyright (c) 2015 William Gu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Event : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * activity;
@property (nonatomic, retain) NSString * location;

@end
