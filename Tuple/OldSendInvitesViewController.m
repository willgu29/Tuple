//
//  SendInvitesViewController.m
//  Degrees
//
//  Created by William Gu on 2/7/15.
//  Copyright (c) 2015 William Gu. All rights reserved.
//

#import "OldSendInvitesViewController.h"
#import "UserCellInfo.h"
#import "UserTypeEnums.h"
#import "ArraySearcher.h"
#import "UserCellInfo.h"
#import "HostViewController.h"
#import "AppDelegate.h"
#import "MessagingViewController.h"

@interface OldSendInvitesViewController ()

@property (nonatomic, strong) PushToParseCloud *pushToParseCloud;
@property (nonatomic, strong) PullFromContactsList *pullFromContacts;

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UITextField *searchBar;

@property (nonatomic) BOOL isClearing;

@end

@implementation OldSendInvitesViewController
@synthesize displayInfoArray;
@synthesize cellData;
@synthesize selectedPeopleArray;

-(void)segueToNextViewController
{
    if (self.presentingViewController != [MessagingViewController class])
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Success!" message:@"Your invites were sent and your event created." delegate:nil cancelButtonTitle:@"Great!" otherButtonTitles:nil];
        [alertView show];
    }
    else
    {
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Success!" message:@"Your invites were sent." delegate:nil cancelButtonTitle:@"Great!" otherButtonTitles:nil];
        [alertView show];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _pullFromContacts = [[PullFromContactsList alloc] init];
    _pullFromContacts.delegate = self;
    [_pullFromContacts fetchTableViewData];
    _pushToParseCloud = [[PushToParseCloud alloc] init];
    _searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated
{
    BOOL isReturningUser = [[NSUserDefaults standardUserDefaults] boolForKey:@"isReturningUser"];
    if (! isReturningUser) //onboarding process
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Welcome to Tuple!" message:@"Tuple requires you to invite at least one friend to an event, whether your the host or attendee. It's just better that way!" delegate:nil cancelButtonTitle:@"Got it!" otherButtonTitles:nil];
        [alertView show];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isReturningUser"];
    }
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
    
    [_pushToParseCloud createEventAt:self.location withActivity:self.event atTime:self.time];

    
}

#pragma mark - Push To Cloud Delegate

-(void)pushEventToParseSuccess:(NSString *)uuid
{
    [_pushToParseCloud sendNotificationsToContacts:_checkMarked forEvent:event];
    [_pushToParseCloud updateContactsInvited:_checkMarked forEvent:event];
    [self segueToNextViewController];

}

-(void)pushEventToParseFailure:(NSError *)error
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
    NSArray *results = [ArraySearcher getTextThatBeginsWith:substring inArray:self.cellData withPath:@"self.fullName"];
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
#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_displayInfoArray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *simpleTableIdentifier = [NSString stringWithFormat:@"%ld_%ld", (long)indexPath.section, (long)indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];
        
    }
    
    return cell;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    
    UserCellInfo *userInfo = [self.displayInfoArray objectAtIndex:indexPath.row];
    
    
    PFUser *user = [ParseDatabase lookupPhoneNumber:userInfo.phoneNumber];
    if (!user)
    {
        //TODO: Remove on version release and add 1 to all parse data
        PFQuery *query = [PFUser query];
        NSString *number = [Converter convertPhoneNumberToOnlyNumbers:userInfo.phoneNumber];
        NSString *noOne = [number substringFromIndex:1];
        [query whereKey:@"phoneNumber" equalTo:noOne];
        user = (PFUser *)[query getFirstObject];
    }
    if (user)
    {
        userInfo.username = user.username;
        userInfo.deviceToken = user[@"deviceToken"];
        userInfo.phoneVerified = (BOOL)user[@"phoneVerified"];
        userInfo.userType = IS_CONTACT_WITH_APP;
        
    }
    else
    {
        
    }
    
    if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
        userInfo.isSelected = NO;
        [_selectedPeopleArray removeObject:userInfo];
    } else {
        userInfo.isSelected = YES;
        [_selectedPeopleArray addObject:userInfo];
    }
    
    [self.cellData replaceObjectAtIndex:userInfo.cellID withObject:userInfo];
    [tableView reloadData];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    
    UserCellInfo *userInfo = [self.displayInfoArray objectAtIndex:indexPath.row];
    if (userInfo.isSelected)
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        if (userInfo.username)
        {
            cell.detailTextLabel.text = userInfo.username;
        }
        else
        {
            cell.detailTextLabel.text = userInfo.phoneNumber;
        }
        
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.detailTextLabel.text = @"";
    }
    
    if (userInfo.lastName == nil)
    {
        cell.textLabel.text = [NSString stringWithFormat:@"%@", userInfo.firstName];
        return;
    }
    else if (userInfo.firstName == nil)
    {
        cell.textLabel.text = [NSString stringWithFormat:@"%@", userInfo.lastName];
        return;
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", userInfo.firstName, userInfo.lastName];
    
}


@end
