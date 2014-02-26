//
//  OMBConversationStore.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 2/25/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBConversationStore.h"

#import "OMBConversation.h"
#import "OMBMessagesListConnection.h"

@interface OMBConversationStore()
{
  NSMutableDictionary *conversations;
}

@end

@implementation OMBConversationStore

#pragma mark - Initializer

- (id) init
{
  if (!(self = [super init])) return nil;

  conversations = [NSMutableDictionary dictionary];

  return self;
}

#pragma mark - Methods

#pragma mark - Class Methods

+ (OMBConversationStore *) sharedStore
{
  static OMBConversationStore *store = nil;
  if (!store)
    store = [[OMBConversationStore alloc] init];
  return store;
}

#pragma mark - Instance Methods

- (void) addConversation: (OMBConversation *) conversation
{
  [conversations setObject: conversation 
    forKey: [NSNumber numberWithInt: conversation.uid]];
}

- (OMBConversation *) conversationForUID: (NSUInteger) conversationUID
{
  return [conversations objectForKey: 
    [NSNumber numberWithInt: conversationUID]];
}

- (void) fetchConversationsAtPage: (NSUInteger) page delegate: (id) delegate
completion: (void (^) (NSError *error)) block
{
  OMBMessagesListConnection *conn = 
    [[OMBMessagesListConnection alloc] initWithPage: page];
  conn.completionBlock = block;
  conn.delegate = delegate;
  [conn start];
}

- (NSUInteger) numberOfConversations
{
  return [conversations count];
}

- (void) readFromDictionary: (NSDictionary *) dictionary
{
  for (NSDictionary *dict in [dictionary objectForKey: @"objects"]) {
    NSUInteger conversationUID = [[dict objectForKey: @"id"] intValue];
    OMBConversation *conversation = [self conversationForUID: conversationUID];
    if (!conversation)
      conversation = [[OMBConversation alloc] init];
    [conversation readFromDictionary: dict];
    [self addConversation: conversation];
  }
}

- (void) removeAllObjects
{
  [conversations removeAllObjects];
}

- (NSArray *) sortedConversationsWithKey: (NSString *) key 
ascending: (BOOL) ascending
{
  NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey: key
    ascending: ascending];
  return [[conversations allValues] sortedArrayUsingDescriptors: @[sort]];
}

@end
