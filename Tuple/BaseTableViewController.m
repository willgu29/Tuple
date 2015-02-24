//
//  BaseTableViewController.m
//  Tuple
//
//  Created by William Gu on 2/8/15.
//  Copyright (c) 2015 William Gu. All rights reserved.
//

#import "BaseTableViewController.h"
#import "UserCellInfo.h"
#import "ParseDatabase.h"
#import "UserTypeEnums.h"

@interface BaseTableViewController ()


@end

@implementation BaseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _displayInfoArray = [[NSMutableArray alloc] init];
    _cellData = [[NSMutableArray alloc] init];
    _selectedPeopleArray = [[NSMutableArray alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)updateSelectedRow
{
    
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
//        cell.accessoryType = UITableViewCellAccessoryNone;
        [_selectedPeopleArray removeObject:userInfo];
//        cell.detailTextLabel.alpha = 1;
//        [UIView animateWithDuration:1.0 animations:^{
//            cell.detailTextLabel.alpha = 0;
//        }];
//        cell.detailTextLabel.text = @"";

    }
    else {
//        cell.accessoryType = UITableViewCellAccessoryCheckmark;
//        cell.detailTextLabel.alpha = 0;
//        if (userInfo.username)
//        {
//            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", userInfo.username];
//        }
//        else
//        {
//            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", userInfo.phoneNumber];
//        }
//        [UIView animateWithDuration:1.5 animations:^{
//            cell.detailTextLabel.alpha = 1;
//        }];
//
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
//    cell.detailTextLabel.text = cell.detailTextLabel.text;

}




@end
