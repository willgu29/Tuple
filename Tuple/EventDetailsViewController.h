//
//  EventDetailsViewController.h
//  Tuple
//
//  Created by William Gu on 6/16/15.
//  Copyright (c) 2015 William Gu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
@interface EventDetailsViewController : UIViewController


@property (nonatomic, strong) PFObject *event;

@property (nonatomic, strong) NSArray *peopleGoing; //fullName

@end
