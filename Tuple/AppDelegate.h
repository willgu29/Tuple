//
//  AppDelegate.h
//  Degrees
//
//  Created by William Gu on 2/7/15.
//  Copyright (c) 2015 William Gu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SendData.h"

@class LYRClient;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) LYRClient *layerClient;
@property (strong, nonatomic) SendData *sendData;

-(void)setUpTimerToDeleteEventAndMessages;

@end

