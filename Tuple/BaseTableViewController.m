//
//  BaseTableViewController.m
//  Tuple
//
//  Created by William Gu on 2/8/15.
//  Copyright (c) 2015 William Gu. All rights reserved.
//

#import "BaseTableViewController.h"
#import "UserCellInfo.h"
#import "FetchUserData.h"

@interface BaseTableViewController ()


@end

@implementation BaseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _displayInfoArray = [[NSMutableArray alloc] init];
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
    static NSString *simpleTableIdentifier = @"SimpleTableCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];
    }
    
    return cell;
}


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
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    UserCellInfo *userInfo = [_displayInfoArray objectAtIndex:indexPath.row];
    
    if (userInfo.username)
    {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", userInfo.username];
    }
    else
    {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", userInfo.phoneNumber];
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
