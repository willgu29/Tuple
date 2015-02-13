//
//  DeleteMessages.m
//  Tuple
//
//  Created by William Gu on 2/12/15.
//  Copyright (c) 2015 William Gu. All rights reserved.
//

#import "DeleteMessages.h"
#import <LayerKit/LayerKit.h>
#import <Parse/Parse.h>
#import "QueryForConversation.h"
#import "AppDelegate.h"
#import "SendMessages.h"

@implementation DeleteMessages

+(void)deleteMessagesInCurrentUserConversation
{
    NSURL *convoID = [[NSUserDefaults standardUserDefaults] URLForKey:@"convoID"];
    LYRConversation *conversation = [QueryForConversation queryForConversationWithConvoID:convoID];
    if (conversation)
    {
        // Fetches all messages for a given conversation
        LYRQuery *query = [LYRQuery queryWithClass:[LYRMessage class]];
        query.predicate = [LYRPredicate predicateWithProperty:@"conversation" operator:LYRPredicateOperatorIsEqualTo value:conversation];
        query.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"index" ascending:YES]];
        
        AppDelegate *delegate = [UIApplication sharedApplication].delegate;
        NSError *error;
        NSOrderedSet *messages = [delegate.layerClient executeQuery:query error:&error];
        if (!error) {
            NSLog(@"%tu messages in conversation", messages.count);
            for (id message in messages)
            {
                BOOL success = [message delete:LYRDeletionModeAllParticipants error:&error];
            }
            [SendMessages sendMessage:@"Welcome to Tuple!" ToConversation:conversation];
        } else {
            NSLog(@"Query failed with error %@", error);
        }
    }
    else
    {
        //FATAL ERROR
    }
  
}

@end
