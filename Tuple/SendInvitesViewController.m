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

@property (nonatomic, strong) PushToParseCloud *pushToParseCloud;
@property (nonatomic, strong) PullFromContactsList *pullFromContacts;

@property (nonatomic, weak) IBOutlet UITableView *tableView;

@end

@implementation SendInvitesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _pullFromContacts = [[PullFromContactsList alloc] init];
    _pullFromContacts.delegate = self;
    [_pullFromContacts fetchTableViewData];
    _pushToParseCloud = [[PushToParseCloud alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBActions

-(IBAction)backButton:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)sendInvites:(UIButton *)sender
{
    _pushToParseCloud = [[PushToParseCloud alloc] init];
    _pushToParseCloud.delegate = self;
    
    MessagingViewController *messageVC = [[MessagingViewController alloc] init];
    [self.navigationController pushViewController:messageVC animated:YES];
    
    [_pushToParseCloud separateAppUsersFromContactsAndSendPush:self.selectedPeopleArray];

    
}

#pragma mark - Push To Cloud Delegate

-(void)pushEventToParseFailure:(NSError *)error
{
    
}
-(void)sendInvitesSuccess
{
    
}

-(void)sendInvitesFailure:(NSError *)error
{
    if (error.code == 15)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Tuple with your friends!" message:@"Please invite some friends" delegate:nil cancelButtonTitle:@"Yah!" otherButtonTitles:nil];
        [alert show];
    }
}

#pragma mark - Contact List Delegate
-(void)contactListFetchSuccess:(NSArray *)contactListArray
{
    NSLog(@"Fetch Contact List Success!");
    [self.displayInfoArray addObjectsFromArray:contactListArray];
    [_tableView reloadData];
}
-(void)contactListFetchFailure:(NSError *)error
{
    [self.navigationController popViewControllerAnimated:YES];
    [[[UIAlertView alloc] initWithTitle:nil message:@"This app requires access to your contacts to function properly. Please visit to the \"Privacy\" section in the iPhone Settings app." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}



@end
