//
//  EventDetailsViewController.h
//  Tuple
//
//  Created by William Gu on 6/16/15.
//  Copyright (c) 2015 William Gu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventDetailsViewController : UIViewController

@property (nonatomic, weak) IBOutlet UILabel *hostName;
@property (nonatomic, weak) IBOutlet UILabel *eventActivity;
@property (nonatomic, weak) IBOutlet UILabel *eventLocation;
@property (nonatomic, weak) IBOutlet UILabel *eventTime;

@property (nonatomic, strong) NSArray *peopleGoing; //fullName

@end
