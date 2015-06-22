//
//  EventDetailsViewController.m
//  Tuple
//
//  Created by William Gu on 6/16/15.
//  Copyright (c) 2015 William Gu. All rights reserved.
//

#import "EventDetailsViewController.h"

@interface EventDetailsViewController ()

@property (nonatomic, weak) IBOutlet UILabel *hostName;
@property (nonatomic, weak) IBOutlet UILabel *eventActivity;
@property (nonatomic, weak) IBOutlet UILabel *eventLocation;
@property (nonatomic, weak) IBOutlet UILabel *eventTime;


@end

@implementation EventDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"Event Details";

}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
