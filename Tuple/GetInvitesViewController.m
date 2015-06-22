//
//  GetInvitesViewController.m
//  Tuple
//
//  Created by William Gu on 2/10/15.
//  Copyright (c) 2015 William Gu. All rights reserved.
//

#import "GetInvitesViewController.h"
#import "AppDelegate.h"
#import "Converter.h"
#import "MessagingViewController.h"
#import "ParseDatabase.h"
#import "Tuple-Swift.h"
#import "EventDetailsViewController.h"
@interface GetInvitesViewController ()

@property (nonatomic, strong) PullFromParseCloud *pullFromParseCloud;
@property (nonatomic, strong) NSArray *eventsInvitedTo;

@property (nonatomic, weak) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray *outletReferences;
@end

@implementation GetInvitesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    _pullFromParseCloud = [[PullFromParseCloud alloc] init];
    _pullFromParseCloud.delegate = self;
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refreshControl];
    

    
}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;

    [self queryForEvents];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Hooks

-(void)refresh:(id)sender
{
    [self queryForEvents];
    if ([sender isKindOfClass:[UIRefreshControl class]]) {
        [(UIRefreshControl *)sender endRefreshing];
    }
}

-(IBAction)leftButton:(UIButton *)sender
{
    UserProfileViewController *userVC = [[UserProfileViewController alloc] initWithNibName:@"UserProfileViewController" bundle:nil];
    [self.navigationController pushViewController:userVC animated:YES];
}
-(IBAction)rightButton:(UIButton *)sender
{
    WhereWhenViewController *addEventVC = [[WhereWhenViewController alloc] initWithNibName:@"WhereWhenViewController" bundle:nil];
    [self.navigationController pushViewController:addEventVC animated:YES];
}

#pragma mark - Pull Parse Cloud Delegate
-(void)pullEventSuccess:(NSArray *)eventsInvitedTo
{
    _eventsInvitedTo = eventsInvitedTo;
    [_tableView reloadData];
    
}
-(void)pullEventFailure:(NSError *)error
{
    
}

#pragma mark - UITableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_eventsInvitedTo count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];
    }
    
    PFObject *event = [_eventsInvitedTo objectAtIndex:indexPath.row];
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    cell.detailTextLabel.adjustsFontSizeToFitWidth = YES;
    
    NSString *mainText = [NSString stringWithFormat:@"%@ at %@ by %@", event[@"activity"], event[@"time"], event[@"hostName"]];
    
    cell.textLabel.text = mainText;
    
    NSDate *timeInvited = event.createdAt;
    NSString *detailText = [NSString stringWithFormat:@"Invited by: %@ at %@", event[@"inviterName"], [timeInvited description]];
    
    cell.detailTextLabel.text = detailText;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PFObject *event = [_eventsInvitedTo objectAtIndex:indexPath.row];
    EventDetailsViewController *eventVC = [[EventDetailsViewController alloc] initWithNibName:@"EventDetailsViewController" bundle:nil];
    
    [self.navigationController pushViewController:eventVC animated:YES];
}


#pragma mark - Helper functions
-(UILabel *)createLabel:(NSString *)message
{
    UILabel *label = [[UILabel alloc] init];
    label.text = message;
    [label sizeToFit];
    label.textColor = [UIColor grayColor];
    
    CGPoint centerPoint = [self centerPoint:label];
    
    label.frame = CGRectMake(centerPoint.x, centerPoint.y, label.frame.size.width, label.frame.size.height);
    
    return label;
}
-(UIButton *)createButton:(NSString *)message
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:message forState:UIControlStateNormal];
    [button sizeToFit];
    
    CGPoint centerPoint = [self centerPoint:button];
    button.frame = CGRectMake(centerPoint.x, centerPoint.y+40, button.frame.size.width, button.frame.size.height);
    
    [button addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

-(CGPoint)centerPoint:(UIView *)view
{
    CGFloat centerX = self.view.bounds.size.width/2 - view.frame.size.width/2;
    CGFloat centerY = self.view.bounds.size.height/2 - view.frame.size.height/2;
    return CGPointMake(centerX, centerY);
}

#pragma mark - Flavor

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


#pragma mark - Helper functions
-(void)queryForEvents
{
    PFQuery *query = [PFQuery queryWithClassName:@"Event"];
    [query whereKey:@"contactsInvited" equalTo:[PFUser currentUser].username];
    [query findObjectsInBackgroundWithBlock:^(NSArray *PF_NULLABLE_S objects, NSError *PF_NULLABLE_S error)
     {
         _eventsInvitedTo = objects;
         if ([_eventsInvitedTo count]) {
             _tableView.hidden = NO;
             [self deleteOutletsInReferences];
             [_tableView reloadData];
         } else {
             _tableView.hidden = YES;
             UIButton *newButton = [self createButton:@"Refresh"];
             UILabel *newLabel = [self createLabel:@"No events.. why not create one?"];
             _outletReferences = @[newLabel, newButton];
             [self.view addSubview:newButton];
             [self.view addSubview:newLabel];
             
         }
     }];
}

-(void)deleteOutletsInReferences
{
    for (int i = 0; i < [_outletReferences count]; i++)
    {
        id object = [_outletReferences objectAtIndex:i];
        [object removeFromSuperview];
        object = nil;
    }
}
@end
