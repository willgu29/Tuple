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
#import "SendInvitesViewController.h"

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
    [_pullFromParseCloud findEventsThatUsernameIsInvitedTo:delegate.sendData.currentUsername];
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
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    PFObject *eventObject = [_eventsInvitedTo objectAtIndex:indexPath.row];
    delegate.sendData.hostName = eventObject[@"hostName"];
    delegate.sendData.hostUsername = eventObject[@"hostUsername"];
    delegate.sendData.theTimeToEat = eventObject[@"whenToEat"];
    NSString *stringDiningInt =  eventObject[@"diningHall"];
    delegate.sendData.diningHallInt = stringDiningInt.intValue;
    delegate.sendData.clientType = 2;
    
    PFUser *user = [PFUser currentUser];
    NSString *firstName = user[@"firstName"];
    NSString *lastName = user[@"lastName"];
    NSString *inviterName = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
    delegate.sendData.inviterName = inviterName;
    
    SendInvitesViewController *sendInvitesVC = [[SendInvitesViewController alloc] init];
    [self.navigationController pushViewController:sendInvitesVC animated:YES];
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    PFObject *eventObject = [_eventsInvitedTo objectAtIndex:indexPath.row];
    
    NSArray *peopleAttending = eventObject[@"peopleInChatroom"];
    NSString *diningHall = eventObject[@"diningHall"];
    NSString *timeToEat = eventObject[@"whenToEat"];
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    cell.detailTextLabel.adjustsFontSizeToFitWidth = YES;
    cell.textLabel.text = [NSString stringWithFormat:@"Host: %@ Inviter: %@", eventObject[@"hostName"], eventObject[@"inviterName"]];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ at %@, %d Attending", [Converter convertDiningHallIntToString:diningHall.intValue], timeToEat, [peopleAttending count]];
}


@end
