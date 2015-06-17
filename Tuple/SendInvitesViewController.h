//
//  SendInvitesViewController.h
//  Degrees
//
//  Created by William Gu on 2/7/15.
//  Copyright (c) 2015 William Gu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullFromContactsList.h"
#import "PushToParseCloud.h"

@interface SendInvitesViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, PushToParseCloudDelegate, UITextFieldDelegate>

// SET BY ANOTHER VC
@property (nonatomic, strong) NSString *event;
@property (nonatomic, strong) NSString *location;
@property (nonatomic, strong) NSString *time;
//*****

@end
