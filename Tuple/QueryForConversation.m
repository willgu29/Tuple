//
//  QueryForConversation.m
//  Tuple
//
//  Created by William Gu on 2/9/15.
//  Copyright (c) 2015 William Gu. All rights reserved.
//

#import "QueryForConversation.h"
#import <LayerKit/LayerKit.h>
#import "AppDelegate.h"
@implementation QueryForConversation



+(LYRConversation *)queryForConversationWithConvoID:(NSURL *)convoID
{
    LYRQuery *query = [LYRQuery queryWithClass:[LYRConversation class]];
    query.predicate = [LYRPredicate predicateWithProperty:@"identifier" operator:LYRPredicateOperatorIsEqualTo value:convoID];
    query.sortDescriptors = @[ [NSSortDescriptor sortDescriptorWithKey:@"createdAt" ascending:NO] ];
    
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    NSError *error;
    NSOrderedSet *conversations = [delegate.layerClient executeQuery:query error:&error];
    if (!error) {
        NSLog(@"%tu conversations with participants %@", conversations.count, @[ @"<PARTICIPANT>" ]);
    } else {
        NSLog(@"Query failed with error %@", error);
    }
    
    
    // Retrieve the last conversation
    if (conversations.count) {
        return [conversations lastObject];
    }
    else
    {
        return nil;
    }
}


@end
