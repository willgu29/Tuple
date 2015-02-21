//
//  LayerConversation.m
//  Tuple
//
//  Created by William Gu on 2/21/15.
//  Copyright (c) 2015 William Gu. All rights reserved.
//

#import "LayerConversation.h"
#import "AppDelegate.h"
#import "SendMessages.h"

@implementation LayerConversation

+(NSURL *)createInitialConversationWithUsername:(NSString *)username
{
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    
    NSError *error = nil;
    LYRConversation *conversation = [delegate.layerClient newConversationWithParticipants:[NSSet setWithArray:@[username, @"TupleUCLA"]] options:nil error:&error];
    if (error)
    {
        NSLog(@"Create Conversation Error: %@", error);
    }
    
    [SendMessages sendMessageWithoutPush:@"Welcome to Tuple!" ToConversation:conversation];
    [SendMessages sendMessageWithoutPush:@"Say hi!" ToConversation:conversation];
    
    [conversation setValue:username forMetadataAtKeyPath:@"title"];
    
    [[NSUserDefaults standardUserDefaults] setURL:conversation.identifier forKey:@"convoID"];
    
    return conversation.identifier;
}

+(LYRConversation *)queryForConversationWithHostName:(NSString *)hostName
{
    LYRQuery *query = [LYRQuery queryWithClass:[LYRConversation class]];
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
        for (LYRConversation *conversation in conversations)
        {
            NSString *convoID = [conversation.metadata valueForKey:@"title"];
            if ([convoID isEqualToString:hostName])
            {
                return conversation;
            }
        }
        return nil;
    }
    else
    {
        return nil;
    }
}


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
