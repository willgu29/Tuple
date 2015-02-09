//
//  SendInvitesViewController.h
//  Degrees
//
//  Created by William Gu on 2/7/15.
//  Copyright (c) 2015 William Gu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullFromContactsList.h"
#import "BaseTableViewController.h"

@interface SendInvitesViewController : BaseTableViewController <UITableViewDataSource, UITableViewDelegate, PullFromContactsListDelegate>

@end
