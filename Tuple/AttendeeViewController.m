//
//  AttendeeViewController.m
//  Tuple
//
//  Created by William Gu on 3/13/15.
//  Copyright (c) 2015 William Gu. All rights reserved.
//

#import "AttendeeViewController.h"

@interface AttendeeViewController ()

@end

@implementation AttendeeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [self setupLabel];
}

-(IBAction)attend:(UIButton *)sender
{
    //TODO: update
}
-(IBAction)decline:(UIButton *)sender
{
    //TODO: update
}
@end
