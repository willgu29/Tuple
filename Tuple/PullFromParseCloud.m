//
//  PullFromParseCloud.m
//  Tuple
//
//  Created by William Gu on 2/8/15.
//  Copyright (c) 2015 William Gu. All rights reserved.
//

#import "PullFromParseCloud.h"

@implementation PullFromParseCloud


-(void)findEventsThatUsernameIsInvitedTo:(NSString *)username
{
    PFQuery *query = [PFQuery queryWithClassName:@"Events"];
    [query whereKey:@"usersInvited" equalTo:username];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
       if (error)
       {
           [_delegate pullEventFailure:error];
       }
       else
       {
           [_delegate pullEventSuccess:objects];
           //TODO: Parse data to display easily.
       }
    }];
}

-(void)findEventsThatUsernameIsHosting:(NSString *)username
{
    PFQuery *query = [PFQuery queryWithClassName:@"Events"];
    [query whereKey:@"hostUsername" equalTo:username];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error)
        {
            [_delegate pullEventFailure:error];
        }
        else
        {
            [_delegate pullEventSuccess:objects];
            //TODO: Parse data to display easily.
        }
    }];
}



@end
