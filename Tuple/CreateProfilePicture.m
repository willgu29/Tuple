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


+(UIImageView *)transformImageViewIntoRoundedRectangle:(UIImageView *)imageView
{
    CALayer *imageLayer = imageView.layer;
    [imageLayer setCornerRadius:5];
    [imageLayer setBorderWidth:1];
    [imageLayer setMasksToBounds:YES];
    return imageView;
}
+(UIImageView *)transformImageViewIntoCircle:(UIImageView *)imageView
{
    [imageView.layer setCornerRadius:imageView.frame.size.width/2];
    [imageView.layer setBorderWidth:1];
    [imageView.layer setMasksToBounds:YES];
    return imageView;
}
+(UIImage *)scaleImageDownToHalf:(UIImage *)image
{
    CGSize size = CGSizeApplyAffineTransform(image.size, CGAffineTransformMakeScale(0.5, 0.5));
    BOOL hasAlpha = NO;
    CGFloat scale = 0.0; //automatically use scale factor of main screen
    UIGraphicsBeginImageContextWithOptions(size, !hasAlpha, scale);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}
+(UIImage *)scaleImageDownToFourth:(UIImage *)image
{
    CGSize size = CGSizeApplyAffineTransform(image.size, CGAffineTransformMakeScale(0.25, 0.25));
    BOOL hasAlpha = NO;
    CGFloat scale = 0.0; //automatically use scale factor of main screen
    UIGraphicsBeginImageContextWithOptions(size, !hasAlpha, scale);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}


@end
