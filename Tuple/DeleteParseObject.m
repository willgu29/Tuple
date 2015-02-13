//
//  DeleteParseObject.m
//  Tuple
//
//  Created by William Gu on 2/12/15.
//  Copyright (c) 2015 William Gu. All rights reserved.
//

#import "DeleteParseObject.h"
#import <Parse/Parse.h>

@implementation DeleteParseObject

+(void)deleteCurrentUserEventFromParse
{
    PFQuery *query = [PFQuery queryWithClassName:@"Events"];
    [query whereKey:@"hostUsername" equalTo:[PFUser currentUser].username];
    PFObject *eventObject = [query getFirstObject];
    [eventObject deleteInBackground];
}

@end
