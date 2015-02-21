//
//  LayerConversation.h
//  Tuple
//
//  Created by William Gu on 2/21/15.
//  Copyright (c) 2015 William Gu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <LayerKit/LayerKit.h>

@interface LayerConversation : NSObject

+(NSURL *)createInitialConversationWithUsername:(NSString *)username;
+(LYRConversation *)queryForConversationWithHostName:(NSString *)hostName; //client 2 usage
+(LYRConversation *)queryForConversationWithConvoID:(NSURL *)convoID; //client 1 usage

@end
