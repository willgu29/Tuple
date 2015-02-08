//
//  DisplayData.h
//  Tuple
//
//  Created by William Gu on 2/8/15.
//  Copyright (c) 2015 William Gu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DisplayData : NSObject

@property (nonatomic, strong) NSArray *peopleArray; //an array that holds UserInfo to display on tableview
-(instancetype)init;

@end
