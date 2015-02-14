//
//  QueryForConversation.h
//  Tuple
//
//  Created by William Gu on 2/9/15.
//  Copyright (c) 2015 William Gu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LYRConversation;

@interface QueryForConversation : NSObject

+(LYRConversation *)queryForConversationWithConvoID:(NSURL *)convoID;
+(LYRConversation *)queryForConversationWithHostName:(NSString *)hostName;

@end
