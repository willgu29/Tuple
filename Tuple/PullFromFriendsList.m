//
//  PullFromFriendsList.m
//  Tuple
//
//  Created by William Gu on 2/8/15.
//  Copyright (c) 2015 William Gu. All rights reserved.
//

#import "PullFromFriendsList.h"
#import <Parse/Parse.h>
#import "UserCellInfo.h"
#import "FetchUserData.h"
#import "UserTypeEnums.h"
@interface PullFromFriendsList()

@property (nonatomic, strong) NSMutableArray *friendsListArray;
@property (nonatomic, strong) FetchUserData *fetchUserData;

@end

@implementation PullFromFriendsList

-(void)fetchAllFriendsFromParse
{
    PFQuery *query = [PFQuery queryWithClassName:@"Friends"];
    [query whereKey:@"username" equalTo:[PFUser currentUser].username];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (object)
        {
            _friendsListArray = [[NSMutableArray alloc] init];
            _fetchUserData = [[FetchUserData alloc] init];
            
            for (NSString* friendUsername in object[@"friendsList"])
            {
                PFUser *user = [_fetchUserData lookupUsername:friendUsername];
                UserCellInfo *userInfo = [[UserCellInfo alloc] init];
                userInfo.username = user.username;
                userInfo.emailVerified = (BOOL)user[@"emailVerified"];
                userInfo.deviceToken = user[@"deviceToken"];
                userInfo.firstName = user[@"firstName"];
                userInfo.lastName = user[@"lastName"];
                userInfo.userType = IS_FRIEND;
                [_friendsListArray addObject:friendUsername];
            }
            [_delegate friendsListFetchSuccess:_friendsListArray];
        }
        else
        {
            [_delegate friendsListFetchFailure:error];
        }
    }];
    
}

@end
