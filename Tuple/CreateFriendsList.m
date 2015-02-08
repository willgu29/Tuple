//
//  CreateFriendsLIst.m
//  Tuple
//
//  Created by William Gu on 2/8/15.
//  Copyright (c) 2015 William Gu. All rights reserved.
//

#import "CreateFriendsList.h"
#import <Parse/Parse.h>

@implementation CreateFriendsList

-(void)createParseFriendsListWithUser:(NSString *)username
{
    PFObject *user = [PFObject objectWithClassName:@"Friends"];
    user[@"username"] = username;
    user[@"friendsList"] = @[];
    user[@"pendingRequestsTo"] = @[];
    user[@"pendingRequestsFrom"] = @[];
    
    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            [_delegate createFriendsListSuccess];
        } else {
            [_delegate createFriendsListFailure:error];
        }
    }];
}

@end
