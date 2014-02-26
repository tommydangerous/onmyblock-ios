//
//  OMBConversation.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 2/25/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBConversation.h"

#import "NSDateFormatter+JSON.h"
#import "OMBAllResidenceStore.h"
#import "OMBConversationDetailConnection.h"
#import "OMBConversationWithResidenceConnection.h"
#import "OMBConversationWithUserConnection.h"
#import "OMBMessage.h"
#import "OMBMessagesLastFetchedWithUserConnection.h"
#import "OMBResidence.h"
#import "OMBUser.h"
#import "OMBUserStore.h"

@interface OMBConversation ()
{
  NSMutableDictionary *messages;
}

@end

@implementation OMBConversation

#pragma mark - Initializer

- (id) init
{
  if (!(self = [super init])) return nil;

  messages = [NSMutableDictionary dictionary];

  return self;
}

#pragma mark - Protocol

#pragma mark - OMBConnectionProtocol

- (void) JSONDictionary: (NSDictionary *) dictionary
{
  [self readFromDictionary: [dictionary objectForKey: @"object"]];
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) addMessage: (OMBMessage *) message
{
  [messages setObject: message forKey:
    [NSNumber numberWithInt: message.uid]];
}

- (void) fetchConversationWithResidenceUID: (NSUInteger) uid
completion: (void (^) (NSError *error)) block
{
  OMBConversationWithResidenceConnection *conn =
    [[OMBConversationWithResidenceConnection alloc] initWithUID: uid];
  conn.completionBlock = block;
  conn.delegate = self;
  [conn start];
}

- (void) fetchConversationWithUserUID: (NSUInteger) uid
completion: (void (^) (NSError *error)) block
{
  OMBConversationWithUserConnection *conn =
    [[OMBConversationWithUserConnection alloc] initWithUserUID: uid];
  conn.completionBlock = block;
  conn.delegate = self;
  [conn start];
}

- (void) fetchMessagesAtPage: (NSUInteger) page delegate: (id) delegate
completion: (void (^) (NSError *error)) block
{
  OMBConversationDetailConnection *conn =
    [[OMBConversationDetailConnection alloc] initWithConversationUID: self.uid
      page: page];
  conn.completionBlock = block;
  conn.delegate = delegate;
  [conn start];
}

- (void) fetchMessagesWithTimeInterval: (NSTimeInterval) lastFetched
delegate: (id) delegate completion: (void (^)(NSError *error)) block
{
  OMBMessagesLastFetchedWithUserConnection *conn =
    [[OMBMessagesLastFetchedWithUserConnection alloc] initWithConversationUID:
      self.uid lastFetched: lastFetched];
  conn.completionBlock = block;
  conn.delegate = delegate;
  [conn start];
}

- (NSUInteger) numberOfMessages
{
  return [messages count];
}

- (void) readFromDictionary: (NSDictionary *) dictionary
{
  NSDateFormatter *dateFormatter = [NSDateFormatter JSONDateParser];

  // Created at
  if ([dictionary objectForKey: @"created_at"] != [NSNull null]) {
    self.createdAt = [[dateFormatter dateFromString:
      [dictionary objectForKey: @"created_at"]] timeIntervalSince1970];
  }

  // Most recent message content
  if ([dictionary objectForKey: 
    @"most_recent_message_content"] != [NSNull null]) {
    self.mostRecentMessageContent = [dictionary objectForKey: 
      @"most_recent_message_content"];
  }

  // Most recent message date
  if ([dictionary objectForKey: @"most_recent_message_date"] != [NSNull null]) {
    self.mostRecentMessageDate = [[dateFormatter dateFromString:
      [dictionary objectForKey: 
        @"most_recent_message_date"]] timeIntervalSince1970];
  }

  // Name of conversation
  if ([dictionary objectForKey: @"name_of_conversation"] != [NSNull null]) {
    self.nameOfConversation = [dictionary objectForKey: 
      @"name_of_conversation"];
  }

  // Residence
  if ([dictionary objectForKey: @"residence"] != [NSNull null]) {
    NSDictionary *resDict = [dictionary objectForKey: @"residence"];
    NSInteger residenceUID = [[resDict objectForKey: @"id"] intValue];
    OMBResidence *res = [[OMBAllResidenceStore sharedStore] residenceForUID:
      residenceUID];
    if (!res) {
      res = [[OMBResidence alloc] init];
    }
    [res readFromResidenceDictionary: resDict];
    self.residence = res;
  }

  // Updated at
  if ([dictionary objectForKey: @"updated_at"] != [NSNull null]) {
    self.updatedAt = [[dateFormatter dateFromString:
      [dictionary objectForKey: @"updated_at"]] timeIntervalSince1970];
  }
  
  // User IDs
  if ([dictionary objectForKey: @"user_ids"] != [NSNull null]) {
    self.userIDs = [dictionary objectForKey: @"user_ids"];
  }

  // UID
  if ([dictionary objectForKey: @"id"] != [NSNull null]) {
    self.uid = [[dictionary objectForKey: @"id"] intValue];
  }

  // Other user
  if ([dictionary objectForKey: @"other_user"] != [NSNull null]) {

  }

  // Other user
  if ([dictionary objectForKey: @"other_user"] != [NSNull null]) {
    NSDictionary *userDict = [dictionary objectForKey: @"other_user"];
    NSInteger userUID = [[userDict objectForKey: @"id"] intValue];
    self.otherUser = [[OMBUserStore sharedStore] userWithUID: userUID];
    if (!self.otherUser)
      self.otherUser = [[OMBUser alloc] init];
    [self.otherUser readFromDictionary: userDict];
  }

  // Viewed user IDs
  if ([dictionary objectForKey: @"viewed_user_ids"] != [NSNull null]) {
    self.viewedUserIDs = [dictionary objectForKey: @"viewed_user_ids"];
  }
}

- (void) readFromMessagesDictionary: (NSDictionary *) dictionary
{
  for (NSDictionary *dict in [dictionary objectForKey: @"objects"]) {
    NSUInteger messageUID = [[dict objectForKey: @"id"] intValue];
    OMBMessage *message = [messages objectForKey: 
      [NSNumber numberWithInt: messageUID]];
    if (!message)
      message = [[OMBMessage alloc] init];
    [message readFromDictionary: dict];
    [self addMessage: message];
  }
}

- (NSArray *) sortedMessagesWithKey: (NSString *) key 
ascending: (BOOL) ascending
{
  NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey: key
    ascending: ascending];
  return [[messages allValues] sortedArrayUsingDescriptors: @[sort]];
}

- (BOOL) viewedByUser: (OMBUser *) user
{
  if (self.viewedUserIDs) {
    NSArray *array = [self.viewedUserIDs componentsSeparatedByString: @","];
    NSUInteger index = [array indexOfObjectPassingTest: 
      ^BOOL (id obj, NSUInteger idx, BOOL *stop) {
        return [(NSString *) obj intValue] == (int) user.uid;
      }
    ];
    if (index != NSNotFound)
      return YES;
  }
  return NO;
}

@end
