//
//  OMBConversation.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 2/25/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBObject.h"

#import "OMBConnectionProtocol.h"

@class OMBMessage;
@class OMBResidence;
@class OMBUser;

@interface OMBConversation : OMBObject <OMBConnectionProtocol>

@property (nonatomic) NSTimeInterval createdAt;
@property (nonatomic, strong) NSString *mostRecentMessageContent;
@property (nonatomic) NSTimeInterval mostRecentMessageDate;
@property (nonatomic, strong) NSString *nameOfConversation;
@property (nonatomic, strong) OMBResidence *residence;
@property (nonatomic) NSTimeInterval updatedAt;
@property (nonatomic, strong) NSString *userIDs;
@property (nonatomic) NSUInteger uid;

@property (nonatomic, strong) OMBUser *otherUser;
@property (nonatomic, strong) NSString *viewedUserIDs;

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) addMessage: (OMBMessage *) message;
- (void) fetchConversationWithResidenceUID: (NSUInteger) uid
completion: (void (^) (NSError *error)) block;
- (void) fetchConversationWithUserUID: (NSUInteger) uid
completion: (void (^) (NSError *error)) block;
- (void) fetchMessagesAtPage: (NSUInteger) page delegate: (id) delegate
completion: (void (^) (NSError *error)) block;
- (void) fetchMessagesWithTimeInterval: (NSTimeInterval) lastFetched
delegate: (id) delegate completion: (void (^)(NSError *error)) block;
- (NSUInteger) numberOfMessages;
- (NSArray *) otherUserIDs: (OMBUser *) user;
- (void) readFromDictionary: (NSDictionary *) dictionary;
- (void) readFromMessagesDictionary: (NSDictionary *) dictionary;
- (NSArray *) sortedMessagesWithKey: (NSString *) key 
ascending: (BOOL) ascending;
- (void) updateMessageUID: (OMBMessage *) message 
withUID: (NSUInteger) messageUID;
- (BOOL) viewedByUser: (OMBUser *) user;

@end
