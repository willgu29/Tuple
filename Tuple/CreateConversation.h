//
//  CreateConversation.h
//  Tuple
//
//  Created by William Gu on 2/9/15.
//  Copyright (c) 2015 William Gu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CreateConversation : NSObject

+(NSURL *)createInitialConversationWithTitle:(NSString *)titleName;


@end

/* this object should create the first initial conversation room upon make account so that the user has a specific channel/ id already for them  -> The title name is the username of the user and this metadata will be what is used to find the chatroom when trying to join a chatroom*/
