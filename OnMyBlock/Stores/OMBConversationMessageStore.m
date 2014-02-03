//
//  OMBConversationMessageStore.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 1/15/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBConversationMessageStore.h"

#import "OMBMessage.h"
#import "OMBMessagesListConnection.h"
#import "OMBUser.h"

@implementation OMBConversationMessageStore

#pragma mark - Initializer

- (id) init
{
  if (!(self = [super init])) return nil;

  _messages = [NSMutableDictionary dictionary];

  return self;
}

#pragma mark - Methods

#pragma mark - Class Methods

+ (OMBConversationMessageStore *) sharedStore
{
  static OMBConversationMessageStore *store = nil;
  if (!store)
    store = [[OMBConversationMessageStore alloc] init];
  return store;
}

#pragma mark - Instance Methods

- (void) addMessage: (OMBMessage *) message
{
  NSNumber *number = [NSNumber numberWithInt: [message otherUser].uid];
  OMBMessage *msg  = [_messages objectForKey: number];
  if (msg && msg.uid == message.uid)
    return;
  [_messages setObject: message forKey: number];
}

- (void) fetchMessagesAtPage: (NSInteger) page 
completion: (void (^) (NSError *error)) block
{
  OMBMessagesListConnection *conn = 
    [[OMBMessagesListConnection alloc] initWithPage: page];
  conn.completionBlock = block;
  conn.delegate = self.delegate;
  [conn start];
}

- (void) readFromDictionary: (NSDictionary *) dictionary
{
  NSArray *array = [dictionary objectForKey: @"objects"];
  for (NSDictionary *dict in array) {
    OMBMessage *message = [[OMBMessage alloc] init];
    [message readFromDictionary: dict];
    [self addMessage: message];
  }
}

- (NSArray *) sortedMessages
{
  NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey: @"createdAt"
    ascending: NO];
  return [[_messages allValues] sortedArrayUsingDescriptors: 
    @[sort]];
}

@end
