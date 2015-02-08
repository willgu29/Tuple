//
//  DisplayData.m
//  Tuple
//
//  Created by William Gu on 2/8/15.
//  Copyright (c) 2015 William Gu. All rights reserved.
//

#import "DisplayData.h"

@interface DisplayData()

@property (nonatomic,strong) NSMutableArray *displayArray;

@end

@implementation DisplayData

-(instancetype)init
{
    self = [super init];
    if (self)
    {
        _displayArray = [[NSMutableArray alloc] init];
    }
    return self;
}



@end
