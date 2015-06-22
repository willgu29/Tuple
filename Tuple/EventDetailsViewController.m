//
//  EventDetailsViewController.m
//  Tuple
//
//  Created by William Gu on 6/16/15.
//  Copyright (c) 2015 William Gu. All rights reserved.
//

#import "EventDetailsViewController.h"
#import "LeftRightSelectorScrollView.h"

@interface EventDetailsViewController ()

@property (nonatomic, weak) IBOutlet UILabel *hostName;
@property (nonatomic, weak) IBOutlet UILabel *eventActivity;
@property (nonatomic, weak) IBOutlet UILabel *eventLocation;
@property (nonatomic, weak) IBOutlet UILabel *eventTime;

@property (nonatomic, strong) LeftRightSelectorScrollView *personScroller;


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
        [self updatePersonSelectorView];
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


-(void)updatePersonSelectorView
{
    _personScroller = [[LeftRightSelectorScrollView alloc] init];
    [_personScroller setTextToDisplayArray:self.event[@"usersGoing"]];
    _personScroller.contentSize = [_personScroller calculateContentSize];
}
#pragma mark Button Selectors



-(void)updateResponse:(UIButton *)sender
{
    if (sender.tag == 1) {
        //Going
        [self refresh:YES];
    } else {
        //Busy
        [self refresh:NO];
    }
    
    [self removeButtonsFromView];
}

-(void)refresh:(BOOL)isGoing
{
    PFUser *currentUser = [PFUser currentUser];
    
    NSString *UUID = self.event[@"UUID"];
    PFQuery *query = [PFQuery queryWithClassName:@"Event"];
    [query whereKey:@"UUID" equalTo:UUID];
    PFObject *newEvent = [query getFirstObject];
    [newEvent addUniqueObject:currentUser.username forKey:@"usersResponded"];
    if (isGoing) {
        [newEvent addUniqueObject:currentUser.username forKey:@"usersGoing"];
    }
    
    [newEvent saveInBackground];
    
    self.event = newEvent;
    [self updatePersonSelectorView];

}



#pragma mark - Helper functions

-(void)removeButtonsFromView
{
    NSArray *subviews = self.view.subviews;
    for (int i = 0; i < [subviews count]; i++)
    {
        UIView *view = [subviews objectAtIndex:i];
        if ([view isKindOfClass:[UIButton class]])
        {
            [view removeFromSuperview];
            view = nil;
        }
    }
}

-(void)addResponseButtonsToView
{
    UIButton *going = [[UIButton alloc] init];
    going.tag = 1;
    [going setTitle:@"Going" forState:UIControlStateNormal];
    [going sizeToFit];
    [going addTarget:self action:@selector(updateResponse:) forControlEvents:UIControlEventTouchUpOutside];
    
    going.frame = CGRectMake(40, self.view.bounds.size.height-40, going.frame.size.width, going.frame.size.width);
    
    
    UIButton *busy = [[UIButton alloc] init];
    busy.tag = 0;
    [busy setTitle:@"Busy" forState:UIControlStateNormal];
    [busy sizeToFit];
    [busy addTarget:self action:@selector(updateResponse:) forControlEvents:UIControlEventTouchUpOutside];
    
    busy.frame = CGRectMake(self.view.bounds.size.width-40, self.view.bounds.size.height-40, going.frame.size.width, going.frame.size.width);
    
    [self.view addSubview:going];
    [self.view addSubview:busy];

    
    
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

-(CGPoint)centerPoint:(UIView *)view
{
    CGFloat centerX = self.view.bounds.size.width/2 - view.frame.size.width/2;
    CGFloat centerY = self.view.bounds.size.height/2 - view.frame.size.height/2;
    return CGPointMake(centerX, centerY);
}

@end
