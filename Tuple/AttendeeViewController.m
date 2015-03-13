//
//  AttendeeViewController.m
//  Tuple
//
//  Created by William Gu on 3/13/15.
//  Copyright (c) 2015 William Gu. All rights reserved.
//

#import "AttendeeViewController.h"
#import "ParseDatabase.h"
#import <AFNetworking/AFNetworking.h>
#import "SendInvitesViewController.h"

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
    PFUser *user = [PFUser currentUser];
    PFObject *event = [ParseDatabase lookupEventWithID:self.uuid];
    [event addUniqueObject:user.username forKey:@"peopleAttending"];
    [event saveInBackground];
    SendInvitesViewController *sendInvites = [[SendInvitesViewController alloc] initWithNibName:@"SendInvitesViewController" bundle:nil];
    [self.navigationController pushViewController:sendInvites animated:YES];
    
}
-(IBAction)decline:(UIButton *)sender
{
    //TODO: update
    PFUser *user = [PFUser currentUser];
    PFObject *event = [ParseDatabase lookupEventWithID:self.uuid];
    [event addUniqueObject:user.username forKey:@"peopleDeclined"];
    [event saveInBackground];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Okay" message:@"Your status has been confirmed!" delegate:nil cancelButtonTitle:@"Sure" otherButtonTitles:nil];
    [alert show];
}
-(IBAction)backButton:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
