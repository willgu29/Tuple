//
//  SendMessages.m
//  Tuple
//
//  Created by William Gu on 2/9/15.
//  Copyright (c) 2015 William Gu. All rights reserved.
//

#import "SendMessages.h"
#import <LayerKit/LayerKit.h>
#import "AppDelegate.h"
#import "FetchUserData.h"

@implementation SendMessages

+(void)sendMessageWithoutPush:(NSString *)textString ToConversation:(LYRConversation *)conversation
{
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    // Creates a message part with text/plain MIME Type
    LYRMessagePart *messagePart = [LYRMessagePart messagePartWithText:textString];
    
    // Creates and returns a new message object with the given conversation and array of message parts
    LYRMessage *message = [delegate.layerClient newMessageWithParts:@[messagePart] options:nil error:nil];
    // Sends the specified message
    NSError *error;
    BOOL success = [conversation sendMessage:message error:&error];
    if (success) {
        NSLog(@"Message queued to be sent: %@", textString);
    } else {
        NSLog(@"Message send failed: %@", error);
    }
}

+(void)sendMessageWithPush:(NSString *)textString ToConversation:(LYRConversation *)conversation
{
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    // Creates a message part with text/plain MIME Type
    LYRMessagePart *messagePart = [LYRMessagePart messagePartWithText:textString];
    
    
    NSString *firstLastName = [FetchUserData getCurrentUserFirstAndLastNameFormattedString];
    NSString *pushNotificationString = [NSString stringWithFormat:@"%@: %@",firstLastName, textString];
    
    // Creates and returns a new message object with the given conversation and array of message parts
    LYRMessage *message = [delegate.layerClient newMessageWithParts:@[messagePart] options:@{LYRMessageOptionsPushNotificationAlertKey: pushNotificationString, LYRMessageOptionsPushNotificationSoundNameKey: @"default"} error:nil];
    // Sends the specified message
    NSError *error;
    BOOL success = [conversation sendMessage:message error:&error];
    if (success) {
        NSLog(@"Message queued to be sent: %@", textString);
    } else {
        NSLog(@"Message send failed: %@", error);
    }
}

@end
