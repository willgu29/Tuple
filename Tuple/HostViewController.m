//
//  HostViewController.m
//  Tuple
//
//  Created by William Gu on 3/12/15.
//  Copyright (c) 2015 William Gu. All rights reserved.
//

#import "HostViewController.h"

@interface HostViewController ()

@property (nonatomic,weak) IBOutlet UILabel *notAttendingLabel;


@end

@implementation HostViewController

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
    self.notAttendingLabel.text = self.notAttending;
}


@end
