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
#import "ArraySearcher.h"
#import "UserCellInfo.h"
//#import "LayerConversation.h"

@interface SendInvitesViewController ()

@property (nonatomic, strong) PushToParseCloud *pushToParseCloud;
@property (nonatomic, strong) PullFromContactsList *pullFromContacts;

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UITextField *searchBar;

@property (nonatomic) BOOL isClearing;

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
    
    [_pushToParseCloud separateAppUsersFromContactsAndSendPush:self.selectedPeopleArray];

    
}

#pragma mark - Push To Cloud Delegate

-(void)pushEventToParseFailure:(NSError *)error
{
    
}
-(void)sendInvitesSuccess:(NSArray *)usernamesArray //add these to conversation after push notification success
{
    MessagingViewController *messageVC = [[MessagingViewController alloc] init];
    messageVC.usernameParticipants = usernamesArray;
    [self.navigationController pushViewController:messageVC animated:YES];
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
    int i = 0;
    NSLog(@"Fetch Contact List Success!");
    for (UserCellInfo *cellInfo in contactListArray)
    {
        cellInfo.cellID = i;
        i++;
    }
    [self.cellData addObjectsFromArray:contactListArray];
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

#pragma mark - TextFieldDelegate

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    NSString *substring = _searchBar.text;
    substring = [substring stringByReplacingCharactersInRange:range withString:string];
    NSArray *results = [ArraySearcher getTextThatBeginsWith:substring inArray:self.cellData withPath:@"self.firstName"];
    self.displayInfoArray = results.mutableCopy;
    [_tableView reloadData];
    
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([textField.text isEqualToString:@""])
    {
        self.displayInfoArray = self.cellData;
        [_tableView reloadData];
    }
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
}

-(BOOL)textFieldShouldClear:(UITextField *)textField
{
    
    if ([textField.text isEqualToString:@""])
    {
        return NO;
    }
    [textField resignFirstResponder];
    return YES;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}

@end
