//
//  DisplayViewController.h
//  Tuple
//
//  Created by William Gu on 3/12/15.
//  Copyright (c) 2015 William Gu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DisplayViewController : UIViewController

@property (nonatomic, strong) NSString *uuid;
@property (nonatomic, strong) NSString *notAttending;

-(void)setupLabel;

@end
