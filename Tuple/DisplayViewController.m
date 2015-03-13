//
//  DisplayViewController.m
//  Tuple
//
//  Created by William Gu on 3/12/15.
//  Copyright (c) 2015 William Gu. All rights reserved.
//

#import "DisplayViewController.h"
#import "AppDelegate.h"
#import "ParseDatabase.h"

@interface DisplayViewController ()

@property (nonatomic, weak) IBOutlet UILabel *event;
@property (nonatomic, weak) IBOutlet UILabel *eventLocation;
@property (nonatomic, weak) IBOutlet UILabel *eventTime;
@property (nonatomic, weak) IBOutlet UILabel *peopleAttending;




@end

@implementation DisplayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if (_uuid == nil)
    {
        NSLog(@"ERROR: Please pass down a uuid");
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [self setupLabel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setupLabel
{
     PFObject *event = [ParseDatabase lookupEventWithID:_uuid];
    _event.text = event[@"event"];
    _eventLocation.text = event[@"eventLocation"];
    _eventTime.text = event[@"eventTime"];
    _peopleAttending.text = event[@"peopleAttending"];
}

@end
