//
//  OMBMessage.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/24/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBMessage.h"

#import "NSDateFormatter+JSON.h"
#import "NSString+Extensions.h"
#import "OMBConversation.h"
#import "OMBMessageCollectionViewCell.h"
#import "OMBMessageCreateConnection.h"
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
