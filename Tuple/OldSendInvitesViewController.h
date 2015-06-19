//
//  SendInvitesViewController.h
//  Degrees
//
//  Created by William Gu on 2/7/15.
//  Copyright (c) 2015 William Gu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OldPullFromContactsList.h"
#import "BaseTableViewController.h"
#import "PushToParseCloud.h"
#import <Parse/Parse.h>

@interface OldSendInvitesViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, PullFromContactsListDelegate, PushToParseCloudDelegate, UITextFieldDelegate>



// SET BY ANOTHER VC
@property (nonatomic, strong) NSString *event;
@property (nonatomic, strong) NSString *location;
@property (nonatomic, strong) NSString *time;
//*****

@property (nonatomic, strong) NSMutableArray *displayInfoArray;
@property (nonatomic, strong) NSMutableArray *cellData;
@property (nonatomic, strong) NSMutableArray *selectedPeopleArray;


@end
