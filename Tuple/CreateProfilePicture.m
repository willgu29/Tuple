//
//  CreateProfilePicture.m
//  Tuple
//
//  Created by William Gu on 2/19/15.
//  Copyright (c) 2015 William Gu. All rights reserved.
//

#import "CreateProfilePicture.h"
#import <QuartzCore/QuartzCore.h>

@implementation CreateProfilePicture


+(UIImageView *)transformImageViewIntoCircle:(UIImageView *)image
{
    CALayer *imageLayer = image.layer;
    [imageLayer setCornerRadius:5];
    [imageLayer setBorderWidth:1];
    [imageLayer setMasksToBounds:YES];
    return image;
}

@end
