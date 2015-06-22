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
    
    if (self.event) {
        _hostName.text = self.event[@"hostName"];
        _eventActivity.text  = self.event[@"activity"];
        _eventLocation.text = self.event[@"location"];
        _eventTime.text = self.event[@"time"];
        
        if ([self hasRespondedToInvite]) {
            
        } else {
            [self addResponseButtonsToView];
        }
        
    } else {
        NSLog(@"Uhh ERROR NO EVENT");
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Helper functions

-(void)addResponseButtonsToView
{
    UIButton *going = [[UIButton alloc] init];
    [going setTitle:@"Going" forState:UIControlStateNormal];
    [going ]
}

-(BOOL)hasRespondedToInvite
{
    PFUser *currentUser = [PFUser currentUser];
    NSArray *usersResponded = self.event[@"usersResponded"];
    if ([usersResponded containsObject:currentUser.username]) {
        return true;
    } else {
        return false;
    }
}

@end
