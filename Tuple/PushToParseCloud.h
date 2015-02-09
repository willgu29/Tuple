//
//  PushToParseCloud.h
//  Degrees
//
//  Created by William Gu on 2/7/15.
//  Copyright (c) 2015 William Gu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PushToParseCloud : NSObject

-(void)sendDeviceTokensToCloud:(NSArray *)peopleArray;

@end
