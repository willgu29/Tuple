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
@interface GetInvitesViewController ()

@property (nonatomic, strong) PullFromParseCloud *pullFromParseCloud;
@property (nonatomic, strong) NSMutableArray *eventsInvitedTo;

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
   
    MessagingViewController *messageVC = [[MessagingViewController alloc] init];
    [self.navigationController pushViewController:messageVC animated:YES];
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //TODO: Redo fetching
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    cell.detailTextLabel.adjustsFontSizeToFitWidth = YES;
    cell.textLabel.text = @"HAHA";
    cell.detailTextLabel.text = @":(";
}


@end
