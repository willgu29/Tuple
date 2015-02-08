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
#import "UserCellDisplayInfo.h"

@interface SendInvitesViewController ()

@property (nonatomic, strong) PullFromContactsList *pullFromContacts;

@property (nonatomic, strong) NSArray *displayInfoArray;

@end

@implementation SendInvitesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _pullFromContacts = [[PullFromContactsList alloc] init];
    _pullFromContacts.delegate = self;
    [_pullFromContacts fetchTableViewData];
    
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

#pragma mark - Contact List Delegate
-(void)contactListFetchSuccess:(NSArray *)contactListArray
{
    NSLog(@"Fetch Contact List Success!");
    _displayInfoArray = contactListArray;
    
}
-(void)contactListFetchFailure:(NSError *)error
{
    [self.navigationController popViewControllerAnimated:YES];
    [[[UIAlertView alloc] initWithTitle:nil message:@"This app requires access to your contacts to function properly. Please visit to the \"Privacy\" section in the iPhone Settings app." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_displayInfoArray count];
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
    UserCellDisplayInfo *userInfo = [_displayInfoArray objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", userInfo.firstName, userInfo.lastName];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
