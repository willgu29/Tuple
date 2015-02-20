//
//  CreateConversation.m
//  Tuple
//
//  Created by William Gu on 2/9/15.
//  Copyright (c) 2015 William Gu. All rights reserved.
//

#import "CreateConversation.h"
#import <LayerKit/LayerKit.h>
#import "AppDelegate.h"
#import "SendMessages.h"

@interface CreateConversation()

@property (nonatomic, strong) LYRConversation *conversation;

@end

@implementation CreateConversation

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



@end
