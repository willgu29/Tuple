//
//  BaseTableViewController.h
//  Tuple
//
//  Created by William Gu on 2/8/15.
//  Copyright (c) 2015 William Gu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseTableViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *displayInfoArray;

@end

/* Subclasses of BaseTableViewController should assign something to displayInfoArray, else nothing will be displayed. */