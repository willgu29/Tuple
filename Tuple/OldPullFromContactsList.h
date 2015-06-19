//
//  PullFromContactsList.h
//  Tuple
//
//  Created by William Gu on 2/8/15.
//  Copyright (c) 2015 William Gu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class OldPullFromContactsList;
@protocol PullFromContactsListDelegate

-(void)contactListFetchSuccess:(NSArray *)contactListArray;
-(void)contactListFetchFailure:(NSError *)error;

@end

@interface OldPullFromContactsList : NSObject

@property (nonatomic, assign) id delegate;

-(void)fetchTableViewData;
-(instancetype)init;

@end
