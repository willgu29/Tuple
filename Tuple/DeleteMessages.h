//
//  DeleteMessages.h
//  Tuple
//
//  Created by William Gu on 2/12/15.
//  Copyright (c) 2015 William Gu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeleteMessages : NSObject

+(void)deleteMessagesInConversationID:(NSURL *)convoID; //for host usage only
+(void)deleteMessagesInHostname:(NSString *)hostName;

@end

/* Just do it independently.. query, get conversation, get messages, delete those messages and boom. */
