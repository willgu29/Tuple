//
//  MessagingViewController.h
//  Degrees
//
//  Created by William Gu on 2/7/15.
//  Copyright (c) 2015 William Gu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <LayerKit/LayerKit.h>

@interface MessagingViewController : UIViewController <UIAlertViewDelegate,LYRQueryControllerDelegate, UITextFieldDelegate>

@property (nonatomic) int clientType; //PREVIOUS VC MUST SET THIS (1 for host, 2 for attendee)

@end
