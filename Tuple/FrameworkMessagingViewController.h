//
//  FrameworkMessagingViewController.h
//  Tuple
//
//  Created by William Gu on 6/3/15.
//  Copyright (c) 2015 William Gu. All rights reserved.
//

#import <JSQMessagesViewController/JSQMessages.h> 
#import "DemoModelData.h"

@interface FrameworkMessagingViewController : JSQMessagesViewController

@property (strong, nonatomic) DemoModelData *demoData;

- (void)receiveMessagePressed:(UIBarButtonItem *)sender;

- (void)closePressed:(UIBarButtonItem *)sender;

@end
