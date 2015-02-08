//
//  PullFromFriendsList.h
//  Tuple
//
//  Created by William Gu on 2/8/15.
//  Copyright (c) 2015 William Gu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PullFromFriendsList;
@protocol PullFromFriendsListDelegate

-(void)friendsListFetchSuccess:(NSArray *)friendsListArray;
-(void)friendsListFetchFailure:(NSError *)error;

@end


@interface PullFromFriendsList : NSObject

@property (nonatomic, assign) id delegate;
-(void)fetchAllFriendsFromParse;

@end
