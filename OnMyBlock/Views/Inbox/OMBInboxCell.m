//
//  OMBInboxCell.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/24/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBInboxCell.h"

#import "NSString+Extensions.h"
#import "OMBMessage.h"
#import "OMBCenteredImageView.h"
#import "OMBUser.h"

@implementation OMBInboxCell

#pragma mark - Initializer

- (id) initWithStyle: (UITableViewCellStyle) style 
reuseIdentifier: (NSString *)reuseIdentifier
{ 
  if (!(self = [super initWithStyle: style reuseIdentifier: reuseIdentifier])) 
    return nil;

  CGRect screen = [[UIScreen mainScreen] bounds];
  CGFloat screenWidth = screen.size.width;
  CGFloat padding = 15.0f;

  CGFloat imageSize = screenWidth * 0.2f;
  // User image
  userImageView = [[OMBCenteredImageView alloc] init];
  userImageView.frame = CGRectMake(padding, padding, imageSize, imageSize);
  userImageView.layer.cornerRadius = userImageView.frame.size.width * 0.5f;
  [self.contentView addSubview: userImageView];

  // User name
  userNameLabel = [UILabel new];
  userNameLabel.frame = CGRectMake(
    userImageView.frame.origin.x + userImageView.frame.size.width + padding,
      userImageView.frame.origin.y, 0.0f, 27.0f);
  userNameLabel.textColor = [UIColor textColor];
  [self.contentView addSubview: userNameLabel];

  CGFloat messageContentWidth = screenWidth - 
    (padding + userImageView.frame.size.width + padding + padding);
  // Message content
  messageContentLabel = [UILabel new];
  messageContentLabel.frame = CGRectMake(userNameLabel.frame.origin.x,
    userNameLabel.frame.origin.y + userNameLabel.frame.size.height + 
    (padding * 0.5),
      messageContentWidth, 23.0f);
  [self.contentView addSubview: messageContentLabel];

  // Date time
  dateTimeLabel = [UILabel new];
  dateTimeLabel.font = [UIFont fontWithName: @"HelveticaNeue-Light" size: 15];
  dateTimeLabel.textAlignment = NSTextAlignmentRight;
  [self.contentView addSubview: dateTimeLabel];

  return self;
}

#pragma mark - Methods

#pragma mark - Instance Methods

+ (CGFloat) heightForCell
{
  CGRect screen = [[UIScreen mainScreen] bounds];
  CGFloat padding = 15.0f;
  return padding + (screen.size.width * 0.2) + padding;
}

- (void) loadMessageData: (OMBMessage *) object
{
  message = object;

  // See who sent this message
  OMBUser *otherUser = [message otherUser];

  CGRect screen = [[UIScreen mainScreen] bounds];
  CGFloat screenWidth = screen.size.width;
  CGFloat padding = 15.0f;

  // User image
  NSString *sizeKey = [NSString stringWithFormat: @"%f,%f",
    userImageView.frame.size.width, userImageView.frame.size.height];
  if (otherUser.image) {
    userImageView.image = [otherUser imageForSizeKey: sizeKey];
  }
  else {
    [otherUser downloadImageFromImageURLWithCompletion: 
      ^(NSError *error) {
        userImageView.image = [otherUser imageForSizeKey: sizeKey];
      }
    ];
  }

  // Message content
  messageContentLabel.text = message.content;

  // Date time
  NSDateFormatter *dateFormatter = [NSDateFormatter new];
  NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
  float secondsInADay = 60 * 60 * 24;
  // Within a day
  if (message.createdAt > now - (secondsInADay * 1)) {
    // 4:31 pm
    dateFormatter.dateFormat = @"h:mm a";
  }
  // Within the week
  else if (message.createdAt > now - (secondsInADay * 7)) {
    // Sun
    dateFormatter.dateFormat = @"EEE";
  }
  else if (message.createdAt > now - (secondsInADay * 365)) {
    // Jan 4
    dateFormatter.dateFormat = @"MMM d";
  }
  else {
    // 11/04/13
    dateFormatter.dateFormat = @"M/d/yy";
  }
  dateTimeLabel.text = [dateFormatter stringFromDate: 
    [NSDate dateWithTimeIntervalSince1970: message.createdAt]];
  if (message.createdAt > now - (secondsInADay * 1))
    dateTimeLabel.text = [dateTimeLabel.text lowercaseString];
  // CGRect dateTimeRect = [dateTimeLabel.text boundingRectWithSize: 
  //   CGSizeMake(screenWidth, 22.0f) font: dateTimeLabel.font];
  dateTimeLabel.frame = CGRectMake(
    screenWidth - (100.0f + padding), 
      userNameLabel.frame.origin.y + 
      ((userNameLabel.frame.size.height - 20.0f) * 0.5), 
        100.0f, 20.0f);

  // User name
  userNameLabel.text = [otherUser fullName];
  CGRect userNameRect = userNameLabel.frame;
  userNameRect.size.width = screenWidth - 
    (padding + userImageView.frame.size.width + padding + padding +
      dateTimeLabel.frame.size.width + padding);
  userNameLabel.frame = userNameRect;

  if (message.sender.uid == [OMBUser currentUser].uid)
    message.viewed = YES;

  // Viewed; change fonts
  if (message.viewed) {
    dateTimeLabel.textColor = [UIColor grayMedium];
    messageContentLabel.textColor = [UIColor grayMedium];
    messageContentLabel.font = [UIFont fontWithName: @"HelveticaNeue-Light" 
      size: 15];
    userNameLabel.font = [UIFont fontWithName: @"HelveticaNeue-Light" size: 18];
  }
  else {
    dateTimeLabel.textColor = [UIColor blueDark];
    messageContentLabel.font = [UIFont fontWithName: @"HelveticaNeue-Medium" 
      size: 15];
    messageContentLabel.textColor = [UIColor textColor];
    userNameLabel.font = [UIFont fontWithName: @"HelveticaNeue-Medium" 
      size: 18];
  }
}

@end
