//
//  AddFriendsViewController.h
//  Tuple
//
//  Created by William Gu on 2/8/15.
//  Copyright (c) 2015 William Gu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewController.h"
#import "PullFromContactsList.h"

@interface AddFriendsViewController : BaseTableViewController <UITableViewDataSource, UITableViewDelegate, PullFromContactsListDelegate>

@end
