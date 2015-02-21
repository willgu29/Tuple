//
//  SavePhotoToServer.h
//  Tuple
//
//  Created by William Gu on 2/19/15.
//  Copyright (c) 2015 William Gu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PhotoServer : NSObject

+(void)sendImageToServer:(UIImage *)image;
+(void)fetchImageFromServerForUsername:(NSString *)username;

@end