//
//  OMBMessage.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/24/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBMessage.h"

#import <Parse/Parse.h>

#import "NSDateFormatter+JSON.h"
#import "NSString+Extensions.h"
#import "NSString+OnMyBlock.h"
#import "OMBConversation.h"
#import "OMBMessageCollectionViewCell.h"
#import "OMBMessageCreateConnection.h"
#import "OMBOffer.h"
#import "OMBUser.h"
#import "OMBUserStore.h"

@implementation OMBMessage

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) calculateSizeForMessageCell
{
  NSAttributedString *aString = [self.content attributedStringWithFont:
    [OMBMessageCollectionViewCell messageContentLabelFont]
      lineHeight: [OMBMessageCollectionViewCell messageContentLabelLineHeight]];
  CGRect rect = [aString boundingRectWithSize:
    CGSizeMake([OMBMessageCollectionViewCell maxWidthForMessageContentLabel], 
      9999) options: NSStringDrawingUsesLineFragmentOrigin context: nil];
  self.sizeForMessageCell = rect.size;
}

- (void) createMessageConnectionWithConversation: 
(OMBConversation *) conversation
{
  OMBMessageCreateConnection *conn =
    [[OMBMessageCreateConnection alloc] initWithMessage: self
      conversation: conversation];
  [conn start];
}

- (void) createMessageWithContent: (NSString *) string
forConversation: (OMBConversation *) conversation
{
  self.content = string;
  NSInteger offset = kWebServerTimeOffsetInSeconds;
  if (offset > 0)
    offset += 11; // Server time is ahead by X + 11 seconds
  offset += [[NSDate date] timeIntervalSince1970];
  self.createdAt = offset;
  self.uid       = -999 + arc4random_uniform(100);
  self.updatedAt = offset;
  self.user      = [OMBUser currentUser];
  self.viewedUserIDs = [NSString stringWithFormat: @"%i", self.user.uid];

  NSString *alert = [NSString stringWithFormat: @"%@: %@",
    [self.user.firstName capitalizedString], self.content];
  NSTimeInterval interval = 60 * 60 * 24 * 7;
  NSDictionary *data = @{
    @"alert": alert,
    @"badge": ParseBadgeIncrement,
    @"conversation_name": [self.user shortName],
    @"conversation_id":   [NSNumber numberWithInt: conversation.uid],
    @"user_id":           [NSNumber numberWithInt: self.user.uid]
  };
  // Sending push notifications
  for (NSNumber *number in [conversation otherUserIDs: self.user]) {
    PFPush *push = [[PFPush alloc] init];
    [push expireAfterTimeInterval: interval];
    [push setChannel: 
      [OMBUser pushNotificationChannelForConversations: [number intValue]]];
    [push setData: data];
    [push sendPushInBackground];
  }
}

- (BOOL) isFromUser: (OMBUser *) user
{
  return self.user.uid == user.uid;
}

- (void) readFromDictionary: (NSDictionary *) dictionary
{
  NSDateFormatter *dateFormatter = [NSDateFormatter JSONDateParser];

  // Created at
  if ([dictionary objectForKey: @"created_at"] != [NSNull null]) {
    self.createdAt = [[dateFormatter dateFromString:
      [dictionary objectForKey: @"created_at"]] timeIntervalSince1970];
  }

  // Content
  if ([dictionary objectForKey: @"content"] != [NSNull null])
    self.content = [dictionary objectForKey: @"content"];

  // UID
  if ([dictionary objectForKey: @"id"] != [NSNull null]) {
    self.uid = [[dictionary objectForKey: @"id"] intValue];
  }

  // Updated at
  if ([dictionary objectForKey: @"updated_at"] != [NSNull null]) {
    self.updatedAt = [[dateFormatter dateFromString:
      [dictionary objectForKey: @"updated_at"]] timeIntervalSince1970];
  }

  // User
  if ([dictionary objectForKey: @"user"] != [NSNull null]) {
    NSDictionary *userDict = [dictionary objectForKey: @"user"];
    NSInteger userUID = [[userDict objectForKey: @"id"] intValue];
    self.user = [[OMBUserStore sharedStore] userWithUID: userUID];
    if (!self.user)
      self.user = [[OMBUser alloc] init];
    [self.user readFromDictionary: userDict];
  }

  // Viewed user IDs  
  if ([dictionary objectForKey: @"viewed_user_ids"])
    self.viewedUserIDs = [dictionary objectForKey: @"viewedUserIDs"];
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
