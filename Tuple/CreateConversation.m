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

+(NSURL *)createInitialConversationWithTitle:(NSString *)titleName
{
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    NSString *deviceTokenString = [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceToken"];

    NSError *error = nil;
    LYRConversation *conversation = [delegate.layerClient newConversationWithParticipants:[NSSet setWithArray:@[deviceTokenString, @"TupleUCLA"]] options:nil error:&error];
    if (error)
    {
        NSLog(@"Create Conversation Error: %@", error);
    }
    
    [SendMessages sendMessage:@"Welcome to Tuple!" ToConversation:conversation];
    [SendMessages sendMessage:@"Say hi!" ToConversation:conversation];
    
    [conversation setValue:titleName forKey:@"title"];
    
    [[NSUserDefaults standardUserDefaults] setURL:conversation.identifier forKey:@"convoID"];
    
    return conversation.identifier;
}



@end
