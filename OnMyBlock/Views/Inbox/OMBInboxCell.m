//
//  OMBInboxCell.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/24/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBInboxCell.h"

#import "NSString+Extensions.h"
#import "OMBCenteredImageView.h"
#import "OMBConversation.h"
#import "OMBMessage.h"
#import "OMBResidence.h"
#import "OMBUser.h"

@interface OMBInboxCell ()
{
  UILabel *dateTimeLabel;
  OMBConversation *conversation;
  UILabel *messageContentLabel;
  OMBCenteredImageView *userImageView;
  UILabel *userNameLabel;
}

@end

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

#pragma mark - Class Methods

+ (CGFloat) heightForCell
{
  CGRect screen = [[UIScreen mainScreen] bounds];
  CGFloat padding = 15.0f;
  return padding + (screen.size.width * 0.2) + padding;
}

#pragma mark - Instance Methods

- (void) loadConversationData: (OMBConversation *) object
{
  CGRect screen       = [[UIScreen mainScreen] bounds];
  CGFloat screenWidth = screen.size.width;
  CGFloat padding     = 15.0f;

  conversation = object;

  OMBUser *user = conversation.otherUser;
  OMBResidence *residence = conversation.residence;
  NSString *sizeKey = [NSString stringWithFormat: @"%f,%f",
    userImageView.frame.size.width, userImageView.frame.size.height];
  // User image
  if (user)
    if (user.image) {
      userImageView.image = [user imageForSizeKey: sizeKey];
    }
    else {
      [user downloadImageFromImageURLWithCompletion: 
        ^(NSError *error) {
          userImageView.image = [user imageForSizeKey: sizeKey];
        }
      ];
    }
  else if (residence) {
    UIImage *image = [residence coverPhotoForSizeKey: sizeKey];
    if (image) {
      userImageView.image = image;
    }
    else {
      __weak typeof(userImageView) weakUserImageView = userImageView;
      [residence downloadCoverPhotoWithCompletion: ^(NSError *error) {
        [weakUserImageView.imageView sd_setImageWithURL: 
          residence.coverPhotoURL 
            placeholderImage: [OMBResidence placeholderImage]
            options: SDWebImageRetryFailed completed:
              ^(UIImage *img, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                if (img) {
                  weakUserImageView.image = img;
                  [residence.coverPhotoSizeDictionary setObject: 
                    weakUserImageView.image forKey: sizeKey];
                }
              }
            ];
      }];
    }
  }

  // Message content
  messageContentLabel.text = conversation.mostRecentMessageContent;

  // Date time
  NSDateFormatter *dateFormatter = [NSDateFormatter new];
  NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
  float secondsInADay = 60 * 60 * 24;
  // Within a day
  NSCalendar *calendar = [NSCalendar currentCalendar];
  NSInteger components = 
    (NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit);
  NSDateComponents *todayComps = [calendar components: components
    fromDate: [NSDate date]];
  NSDateComponents *messageComps = [calendar components: components
    fromDate: [NSDate dateWithTimeIntervalSince1970: 
      conversation.mostRecentMessageDate]];

  BOOL isToday = [todayComps day] == [messageComps day] && 
    [todayComps month] == [messageComps month] && 
      [todayComps year] == [todayComps year];
  if (isToday) {
    // 4:31 pm
    dateFormatter.dateFormat = @"h:mm a";
  }
  // Within the week
  else if (conversation.mostRecentMessageDate > now - (secondsInADay * 7)) {
    // Sun
    dateFormatter.dateFormat = @"EEE";
  }
  else if (conversation.mostRecentMessageDate > now - (secondsInADay * 365)) {
    // Jan 4
    dateFormatter.dateFormat = @"MMM d";
  }
  else {
    // 11/04/13
    dateFormatter.dateFormat = @"M/d/yy";
  }
  dateTimeLabel.text = [dateFormatter stringFromDate: 
    [NSDate dateWithTimeIntervalSince1970: conversation.mostRecentMessageDate]];
  if (isToday)
    dateTimeLabel.text = [dateTimeLabel.text lowercaseString];
  // CGRect dateTimeRect = [dateTimeLabel.text boundingRectWithSize: 
  //   CGSizeMake(screenWidth, 22.0f) font: dateTimeLabel.font];
  dateTimeLabel.frame = CGRectMake(
    screenWidth - (100.0f + padding), 
      userNameLabel.frame.origin.y + 
      ((userNameLabel.frame.size.height - 20.0f) * 0.5), 
        100.0f, 20.0f);

  // User name
  userNameLabel.text = conversation.nameOfConversation;
  CGRect userNameRect = userNameLabel.frame;
  userNameRect.size.width = screenWidth - 
    (padding + userImageView.frame.size.width + padding + padding +
      dateTimeLabel.frame.size.width + padding);
  userNameLabel.frame = userNameRect;

  // Viewed; change fonts
  if ([conversation viewedByUser: [OMBUser currentUser]]) {
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
