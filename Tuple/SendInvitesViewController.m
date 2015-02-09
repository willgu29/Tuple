//
//  SendInvitesViewController.m
//  Degrees
//
//  Created by William Gu on 2/7/15.
//  Copyright (c) 2015 William Gu. All rights reserved.
//

#import "SendInvitesViewController.h"
#import "MessagingViewController.h"
#import "UserCellInfo.h"
#import "UserTypeEnums.h"

@interface SendInvitesViewController ()

@property (nonatomic, strong) PullFromFriendsList *pullFromFriends;
@property (nonatomic, strong) PullFromContactsList *pullFromContacts;
@property (nonatomic, strong) NSMutableArray *selectedPeopleArray;

@property (nonatomic, weak) IBOutlet UITableView *tableView;

@end

@implementation SendInvitesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _pullFromFriends = [[PullFromFriendsList alloc] init];
    _pullFromFriends.delegate = self;
    [_pullFromFriends fetchAllFriendsFromParse];
    _pullFromContacts = [[PullFromContactsList alloc] init];
    _pullFromContacts.delegate = self;
    [_pullFromContacts fetchTableViewData];
    _selectedPeopleArray = [[NSMutableArray alloc] init];
    
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

#pragma mark - Friends List Delegate
-(void)friendsListFetchSuccess:(NSArray *)friendsListArray
{
    NSLog(@"Fetch Friends List Success!");
    [self.displayInfoArray addObjectsFromArray:friendsListArray];
}
-(void)friendsListFetchFailure:(NSError *)error
{
    
}

#pragma mark - Contact List Delegate
-(void)contactListFetchSuccess:(NSArray *)contactListArray
{
    NSLog(@"Fetch Contact List Success!");
    [self.displayInfoArray addObjectsFromArray:contactListArray];
}
-(void)contactListFetchFailure:(NSError *)error
{
    [self.navigationController popViewControllerAnimated:YES];
    [[[UIAlertView alloc] initWithTitle:nil message:@"This app requires access to your contacts to function properly. Please visit to the \"Privacy\" section in the iPhone Settings app." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
}

#pragma mark - Table view delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UserCellInfo *userInfo = [self.displayInfoArray objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        [_selectedPeopleArray removeObject:userInfo];
    }
    else {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [_selectedPeopleArray addObject:userInfo];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
