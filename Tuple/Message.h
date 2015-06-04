//
//  Message.h
//  Tuple
//
//  Created by William Gu on 6/3/15.
//  Copyright (c) 2015 William Gu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <JSQMessagesViewController/JSQMessages.h>


@interface Message : NSManagedObject <JSQMessageData>

@property (nonatomic, retain) NSString * senderID;
@property (nonatomic, retain) NSString * roomID;
@property (nonatomic, retain) NSString * message;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSNumber * isMediaMessage;
@property (nonatomic, retain) NSString * senderDisplayName;
@property (nonatomic, retain) NSData * media;
@property (nonatomic, retain) NSNumber * messageHash;

@end
