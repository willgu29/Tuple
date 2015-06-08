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
@interface GetInvitesViewController ()

@property (nonatomic, strong) PullFromParseCloud *pullFromParseCloud;
@property (nonatomic, strong) NSArray *eventsInvitedTo;

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@end

@implementation GetInvitesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _pullFromParseCloud = [[PullFromParseCloud alloc] init];
    _pullFromParseCloud.delegate = self;
    
}

-(void)viewWillAppear:(BOOL)animated
{
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    
    //TODO: Fetch events user is invited to via local DB
    PFQuery *query = [PFQuery queryWithClassName:@"Event"];
    [query whereKey:@"contactsInvited" equalTo:[PFUser currentUser].username];
    [query findObjectsInBackgroundWithBlock:^(NSArray *PF_NULLABLE_S objects, NSError *PF_NULLABLE_S error)
    {
        _eventsInvitedTo = objects;
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)backButton:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
    cell.textLabel.text = event[@"hostID"];
    cell.detailTextLabel.text = event[@"inviterName"];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
   
    MessagingViewController *messageVC = [[MessagingViewController alloc] init];
    [self.navigationController pushViewController:messageVC animated:YES];
}


@end
