//
//  SendInvitesViewController.m
//  Degrees
//
//  Created by William Gu on 2/7/15.
//  Copyright (c) 2015 William Gu. All rights reserved.
//

#import "SendInvitesViewController.h"
#import "MessagingViewController.h"
#import "PullFromContactsList.h"

@interface SendInvitesViewController ()

@property (nonatomic, strong) PullFromContactsList *pullFromContacts;

@end

@implementation SendInvitesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _pullFromContacts = [[PullFromContactsList alloc] init];
    [_pullFromContacts fetchAllFromContactsList];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBActions

-(IBAction)sendInvites:(UIButton *)sender
{
    MessagingViewController *messageVC = [[MessagingViewController alloc] init];
    [self.navigationController pushViewController:messageVC animated:YES];
    
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.textLabel.text = @"HI!!!";
}


@end
