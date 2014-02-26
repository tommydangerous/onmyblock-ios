//
//  OMBMessageCollectionViewCell.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/25/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBMessageCollectionViewCell.h"

#import "NSString+Extensions.h"
#import "OMBCenteredImageView.h"
#import "OMBMessage.h"
#import "OMBUser.h"
#import "UIColor+Extensions.h"

@implementation OMBMessageCollectionViewCell

#pragma mark - Initializer

- (id) initWithFrame: (CGRect) rect
{
  if (!(self = [super initWithFrame: rect])) return nil;

  messageArrow = [UIView new];
  messageArrow.frame = CGRectMake(0.0f, 0.0f, 
    [OMBMessageCollectionViewCell minimumHeightForCell] * 0.5,
      [OMBMessageCollectionViewCell minimumHeightForCell] * 0.5);
  messageArrow.hidden = YES;
  [self.contentView addSubview: messageArrow];

  messageContentView = [UIView new];
  messageContentView.layer.cornerRadius = 5.0f;
  [self.contentView addSubview: messageContentView];

  messageContentLabel = [UILabel new];
  messageContentLabel.font = 
    [OMBMessageCollectionViewCell messageContentLabelFont];
  messageContentLabel.numberOfLines = 0;
  [messageContentView addSubview: messageContentLabel];

  otherUserImageView = [[OMBCenteredImageView alloc] init];
  otherUserImageView.frame = CGRectMake(0.0f, 0.0f, 
    [OMBMessageCollectionViewCell minimumHeightForCell],
      [OMBMessageCollectionViewCell minimumHeightForCell]);
  otherUserImageView.hidden = YES;
  otherUserImageView.layer.cornerRadius = 
    otherUserImageView.frame.size.width * 0.5;
  [self.contentView addSubview: otherUserImageView];

  return self;
}

#pragma mark - Override

#pragma mark - Override UICollectionReusableView

- (void) prepareForReuse
{
  // Performs any clean up necessary to prepare the view for use again
  [super prepareForReuse];

  message = nil;

  messageArrow.hidden    = YES;
  messageArrow.transform = CGAffineTransformIdentity;

  messageContentLabel.frame = CGRectZero;
  messageContentLabel.text  = @"";

  otherUserImageView.hidden = YES;
  otherUserImageView.image  = nil;
}

#pragma mark - Methods

#pragma mark - Class Methods

+ (CGFloat) maxWidthForMessageContentLabel
{
  return [OMBMessageCollectionViewCell maxWidthForMessageContentView] -
    ([OMBMessageCollectionViewCell paddingForCell] * 4);
}

+ (CGFloat) maxWidthForMessageContentView
{
  CGRect screen = [[UIScreen mainScreen] bounds];
  return screen.size.width * 0.7;
}

+ (UIFont *) messageContentLabelFont
{
  return [UIFont fontWithName: @"HelveticaNeue-Light" size: 15];
}

+ (CGFloat) messageContentLabelLineHeight
{
  return 22.0f;
}

+ (CGFloat) minimumHeightForCell
{
  CGFloat padding = [OMBMessageCollectionViewCell paddingForCell];
  return padding + 
    [OMBMessageCollectionViewCell messageContentLabelLineHeight] + 
    padding + 
    (padding * 0.5);
}

+ (CGFloat) paddingForCell
{
  return 10.0f;
}

#pragma mark - Instance Methods

- (void) loadMessageData: (OMBMessage *) object
{
  message = object;

  messageContentLabel.attributedText = 
    [message.content attributedStringWithFont: messageContentLabel.font 
      lineHeight: [OMBMessageCollectionViewCell messageContentLabelLineHeight]];

  CGRect screen   = [[UIScreen mainScreen] bounds];
  CGFloat padding = [OMBMessageCollectionViewCell paddingForCell];

  CGRect rect = CGRectMake(0.0f, 0.0f, 
    message.sizeForMessageCell.width, message.sizeForMessageCell.height);
  // Message content label
  messageContentLabel.frame = CGRectMake(padding, padding, 
    rect.size.width, rect.size.height);
  
  CGFloat paddingFromSides = padding * 2;
  CGFloat originX = 0.0f;
  if ([message isFromUser: [OMBUser currentUser]]) {
    originX = screen.size.width - 
      (padding + rect.size.width + padding + paddingFromSides);
    messageContentLabel.textColor      = [UIColor whiteColor];
    messageContentView.backgroundColor = [UIColor blueDark];
  }
  else {
    originX = padding + otherUserImageView.frame.size.width + padding;
    messageContentLabel.textColor      = [UIColor textColor];
    messageContentView.backgroundColor = [UIColor grayVeryLight];
  }
  // Message content view
  messageContentView.frame = CGRectMake(originX, 0.0f,
    padding + rect.size.width + padding,
      padding + rect.size.height + padding + (padding * 0.5));

  // Message arrow
  CGFloat messageArrowOriginY = messageContentView.frame.size.height - 
    (([OMBMessageCollectionViewCell minimumHeightForCell] - 
      messageArrow.frame.size.height) * 0.5);
  messageArrowOriginY -= messageArrow.frame.size.height;
  CGFloat messageArrowOriginX = 0.0f;
  // If current user is the sender of the message
  if ([message isFromUser: [OMBUser currentUser]]) {
    messageArrowOriginX = messageContentView.frame.origin.x + 
      messageContentView.frame.size.width - 
        (messageArrow.frame.size.width * 0.9);
  }
  else {
    messageArrowOriginX = messageContentView.frame.origin.x - 
      (messageArrow.frame.size.width * 0.1);
  }
  messageArrow.backgroundColor = messageContentView.backgroundColor;
  messageArrow.frame = CGRectMake(messageArrowOriginX, messageArrowOriginY,
    messageArrow.frame.size.width, messageArrow.frame.size.height);
  messageArrow.transform = CGAffineTransformMakeRotation(45 * M_PI / 180.0f);

  // Position the otherUserImageView
  otherUserImageView.frame = CGRectMake(padding, 
    messageContentView.frame.size.height - otherUserImageView.frame.size.height,
      otherUserImageView.frame.size.width, 
        otherUserImageView.frame.size.height);
  if (![message isFromUser: [OMBUser currentUser]])
    otherUserImageView.image = message.user.image;
}

- (void) setupForLastMessageFromSameUser
{
  if ([message isFromUser: [OMBUser currentUser]]) {

  }
  else {
    otherUserImageView.hidden = NO;
  }
  messageArrow.hidden = NO;
}

@end
