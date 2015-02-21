//
//  AddFriendsViewController.m
//  Tuple
//
//  Created by William Gu on 2/8/15.
//  Copyright (c) 2015 William Gu. All rights reserved.
//

#import "AddFriendsViewController.h"
#import "PullFromContactsList.h"
#import "UserCellInfo.h"
#import "ParseDatabase.h"
@interface AddFriendsViewController ()

@property (nonatomic, strong) PullFromContactsList *pullFromContacts;

@end

@implementation AddFriendsViewController

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

-(IBAction)backButton:(UIButton *)sender
{
    //TODO: Add friends
    [self.navigationController popViewControllerAnimated:YES];
}



#pragma mark - Table view delegate
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    PFUser *user = [ParseDatabase lookupUsername:textField.text];
    if (user)
    {
        UserCellInfo *userInfo = [[UserCellInfo alloc] init];
        userInfo.username = user.username;
        userInfo.firstName = user[@"firstName"];
        userInfo.lastName = user[@"lastName"];
        userInfo.emailVerified = (BOOL)user[@"emailVerified"];
        [self.displayInfoArray insertObject:userInfo atIndex:0];
    }
    [textField resignFirstResponder];
    return YES;
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



@end
