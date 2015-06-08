//
//  SendInvitesViewController.m
//  Degrees
//
//  Created by William Gu on 2/7/15.
//  Copyright (c) 2015 William Gu. All rights reserved.
//

#import "SendInvitesViewController.h"
#import "UserCellInfo.h"
#import "UserTypeEnums.h"
#import "ArraySearcher.h"
#import "UserCellInfo.h"
#import "AppDelegate.h"
#import "MessagingViewController.h"
#import "Contact.h"
#import "Tuple-Swift.h"
@interface SendInvitesViewController ()

@property (nonatomic, strong) PushToParseCloud *pushToParseCloud;

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UITextField *searchBar;

@property (nonatomic) BOOL isClearing;

@property (nonatomic, strong) NSMutableArray *contacts;
@property (nonatomic, strong) NSArray *tupleUsers;
@property (nonatomic, strong) NSArray *phoneNumbers;

@property (nonatomic, strong) NSMutableArray *checkMarked;

@property (nonatomic, strong) NSArray *displayArray;



@end

@implementation SendInvitesViewController

#pragma mark - UITableView Delegate


#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_displayArray count];
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *simpleTableIdentifier = [NSString stringWithFormat:@"%ld_%ld", (long)indexPath.section, (long)indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];
        
    }
    Contact *contact;
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    contact = [_displayArray objectAtIndex:indexPath.item];
    
    if (contact.isSelected) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    cell.textLabel.text = contact.fullName;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Contact *contact = [_displayArray objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (contact.isSelected){
        contact.isSelected = NO;
        cell.accessoryType = UITableViewCellAccessoryNone;
        [_checkMarked removeObject:contact];
    } else {
        contact.isSelected = [NSNumber numberWithBool:YES];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [_checkMarked addObject:contact];
    }
    [self.contacts replaceObjectAtIndex:contact.contactID.intValue withObject:contact];
    [_tableView reloadData];
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
//    [self tableView:_tableView willDisplayCell:cell forRowAtIndexPath:indexPath];
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{

    
}

#pragma mark - View Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _pushToParseCloud = [[PushToParseCloud alloc] init];
    _searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    
    _checkMarked = [[NSMutableArray alloc] init];
    _contacts = [[NSMutableArray alloc] init];
    [self fetchAllContacts];
//    [self fetchTupleUsers];
//    [self fetchNonTupleUsers];
//    
  
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
   
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
    
    WhereWhenViewController *whereWhen = (WhereWhenViewController *)self.presentingViewController;
    
//    [_pushToParseCloud createEvent:whereWhen.eventLocationXIB.text withActivity:whereWhen.eventXIB.text atTime:whereWhen.eventTimeXIB.text];
    
    //TODO: Send text messages
    //TODO: Send push notifications
    
//    [self segueToMessaging];
    NSLog(@"Checked: %@", _checkMarked);

}

#pragma mark - Push To Cloud Delegate

-(void)pushEventToParseSuccess:(NSString *)uuid
{


}

-(void)pushEventToParseFailure:(NSError *)error
{
    //TODO: Fatal! Give user error and desegueway messaging vc.
}

-(void)sendInvitesFailure:(NSError *)error
{
    if (error.code == 15)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Tuple with your friends!" message:@"Please invite some friends" delegate:nil cancelButtonTitle:@"Yah!" otherButtonTitles:nil];
        [alert show];
    }
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
    NSArray *results = [ArraySearcher getTextThatBeginsWith:substring inArray:self.contacts withPath:@"self.fullName"];
    self.displayArray = results;
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
        self.displayArray = self.contacts;
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

-(void)segueToMessaging
{
    if (self.presentingViewController != [MessagingViewController class])
    {
        MessagingViewController *messageVC = [[MessagingViewController alloc] initWithNibName:@"MessagingViewController" bundle:nil];
        [self.navigationController pushViewController:messageVC animated:YES];
    }
    else
    {
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Success!" message:@"Your invites were sent." delegate:nil cancelButtonTitle:@"Great!" otherButtonTitles:nil];
        [alertView show];
    }
}
#pragma mark - Helpers
-(void)fetchAllContacts
{
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Contact" inManagedObjectContext:delegate.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSError *error;
    NSArray *contacts = [delegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    _displayArray = contacts.copy;
    _contacts = contacts.mutableCopy;
    [_tableView reloadData];
}
-(void)fetchTupleUsers
{
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSPredicate *onlyTupleUsers = [NSPredicate predicateWithFormat:@"hasTupleAccount == YES"];
    [fetchRequest setPredicate:onlyTupleUsers];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Contact" inManagedObjectContext:delegate.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSError *error;
    NSArray *tupleUsers = [delegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    
    _tupleUsers = tupleUsers;
}
-(void)fetchNonTupleUsers
{
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    
    NSFetchRequest *getNonTupleUsers = [[NSFetchRequest alloc] init];
    NSPredicate *nonTupleUsers = [NSPredicate predicateWithFormat:@"hasTupleAccount == NO"];
    [getNonTupleUsers setPredicate:nonTupleUsers];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Contact" inManagedObjectContext:delegate.managedObjectContext];
    [getNonTupleUsers setEntity:entity];
    NSError *error;
    NSArray *nonTuple = [delegate.managedObjectContext executeFetchRequest:getNonTupleUsers error:&error];
    
    
    _phoneNumbers = nonTuple;
}



@end
