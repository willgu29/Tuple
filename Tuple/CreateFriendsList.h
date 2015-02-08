//
//  CreateFriendsLIst.h
//  Tuple
//
//  Created by William Gu on 2/8/15.
//  Copyright (c) 2015 William Gu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CreateFriendsList;
@protocol CreateFriendsListDelegate

-(void)createFriendsListSuccess;
-(void)createFriendsListFailure:(NSError *)error;

@end


@interface CreateFriendsList : NSObject

@property (nonatomic, assign) id delegate;
-(void)createParseFriendsListWithUser:(NSString *)username;


@end
