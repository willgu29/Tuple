//
//  MessagingViewController.h
//  Tuple
//
//  Created by William Gu on 6/1/15.
//  Copyright (c) 2015 William Gu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Chatroom.h"
@interface MessagingViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, ChatroomDelegate, UITextFieldDelegate>

@property (nonatomic, strong) NSString *senderID;
@property (nonatomic, strong) NSString *displayName;

@end
