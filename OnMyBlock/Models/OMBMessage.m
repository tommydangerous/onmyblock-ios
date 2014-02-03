//
//  OMBMessage.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/24/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBMessage.h"

#import "NSString+Extensions.h"
#import "OMBMessageCollectionViewCell.h"
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

- (OMBUser *) otherUser
{
  if (_sender.uid == [OMBUser currentUser].uid)
    return _recipient;
  return _sender;
}

- (void) readFromDictionary: (NSDictionary *) dictionary
{
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  dateFormatter.dateFormat       = @"yyyy-MM-dd HH:mm:ss ZZZ";
  
  _content = [dictionary objectForKey: @"content"];
  // Created at
  if ([dictionary objectForKey: @"created_at"] != [NSNull null])
    _createdAt = [[dateFormatter dateFromString:
      [dictionary objectForKey: @"created_at"]] timeIntervalSince1970];

  // Recipient
  NSDictionary *recipientDict = [dictionary objectForKey: @"recipient"];
  NSInteger recipientUID = [[recipientDict objectForKey: @"id"] intValue];
  OMBUser *recipientUser = [[OMBUserStore sharedStore] userWithUID:
    recipientUID];
  if (!recipientUser) {
    recipientUser = [[OMBUser alloc] init];
    [recipientUser readFromDictionary: recipientDict];
  }
  _recipient = recipientUser;

  // Sender
  NSDictionary *senderDict = [dictionary objectForKey: @"sender"];
  NSInteger senderUID = [[senderDict objectForKey: @"id"] intValue];
  OMBUser *senderUser = [[OMBUserStore sharedStore] userWithUID:
    senderUID];
  if (!senderUser) {
    senderUser = [[OMBUser alloc] init];
    [senderUser readFromDictionary: senderDict];
  }
  _sender = senderUser;

  // Updated at
  if ([dictionary objectForKey: @"updated_at"] != [NSNull null])
    _updatedAt = [[dateFormatter dateFromString:
      [dictionary objectForKey: @"updated_at"]] timeIntervalSince1970];
  if ([[dictionary objectForKey: @"viewed"] intValue])
    _viewed = YES;
  else
    _viewed = NO;
  _uid = [[dictionary objectForKey: @"id"] intValue];
}

@end
