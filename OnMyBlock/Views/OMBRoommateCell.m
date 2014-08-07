//
//  OMBRoommateCell.m
//  OnMyBlock
//
//  Created by Paul Aguilar on 3/17/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBRoommateCell.h"

#import "OMBCenteredImageView.h"
#import "OMBResidence.h"
#import "OMBRoommate.h"
#import "OMBUser.h"
#import "OMBViewController.h"
#import "UIColor+Extensions.h"
#import "UIFont+OnMyBlock.h"
#import "UIImageView+WebCache.h"

@implementation OMBRoommateCell

#pragma mark - Initializer

- (id) initWithStyle: (UITableViewCellStyle) style
     reuseIdentifier: (NSString *) reuseIdentifier
{
  if (!(self = [super initWithStyle: style
    reuseIdentifier: reuseIdentifier])) return nil;

  CGRect screen     = [[UIScreen mainScreen] bounds];
  float screenWidth = screen.size.width;
  float padding = OMBPadding;
  CGFloat imageSize = OMBStandardHeight;

  self.contentView.frame = CGRectMake(0, 0,
    screenWidth, padding + (22 * 2) + padding);

  // User image
  userImageView = [[OMBCenteredImageView alloc] init];
  userImageView.frame = CGRectMake(padding, padding, imageSize, imageSize);
  userImageView.layer.cornerRadius = userImageView.frame.size.width * 0.5f;
  [self.contentView addSubview: userImageView];

  // Full name
  nameLabel = [[UILabel alloc] init];
  nameLabel.font = [UIFont normalTextFontBold];
  nameLabel.frame = CGRectMake(userImageView.frame.origin.x +
    userImageView.frame.size.width + padding,
      padding, screenWidth - (padding + imageSize + padding + padding), 22);
  nameLabel.textColor = [UIColor textColor];
  [self.contentView addSubview: nameLabel];

  // Email
  emailLabel = [[UILabel alloc] init];
  emailLabel.font = [UIFont normalTextFont];
  emailLabel.frame = CGRectMake(nameLabel.frame.origin.x,
    nameLabel.frame.origin.y + nameLabel.frame.size.height,
      nameLabel.frame.size.width, nameLabel.frame.size.height);
  emailLabel.textColor = [UIColor grayMedium];
  [self.contentView addSubview: emailLabel];

  return self;
}

#pragma mark - Methods

#pragma mark - Class Methods

+ (CGFloat) heightForCell
{
  return OMBPadding + (22.0f * 2.0f) + OMBPadding;
}

#pragma mark - Instance Methods

- (void) loadData: (OMBRoommate *) object user: (OMBUser *) userObject
{
  self.roommate = object;
  OMBUser *user = [self.roommate otherUser: userObject];

  if (user) {
    [self loadDataFromUser:user];
  }
  else {
    NSString *nameString = @"";
    if (self.roommate.firstName && [self.roommate.firstName length])
      nameString = [nameString stringByAppendingString:
        [self.roommate.firstName capitalizedString]];
    if ([nameString length])
      nameString = [nameString stringByAppendingString: @" "];
    if (self.roommate.lastName && [self.roommate.lastName length])
      nameString = [nameString stringByAppendingString:
        [self.roommate.lastName capitalizedString]];
    nameLabel.text = nameString;
    if (self.roommate.providerId) {
      emailLabel.text = @"added from Facebook";
      NSURL *imageURL = [NSURL URLWithString: [NSString stringWithFormat:
        @"http://graph.facebook.com/%i/picture?type=large",
          self.roommate.providerId]];
      __weak typeof(userImageView) weakImageView = userImageView;
      [userImageView.imageView setImageWithURL: imageURL
        placeholderImage: [OMBUser placeholderImage] options:
          (SDWebImageRetryFailed | SDWebImageDownloaderProgressiveDownload)
            completed:
              ^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                if (image)
                  weakImageView.image = image;
                // NSLog(@"%@ %@", imageURL, image);
              }];
    }
    else {
      [userImageView setImage: [OMBUser placeholderImage]];
      emailLabel.text = self.roommate.email;
    }
  }
}

- (void)loadDataFromUser:(OMBUser *)object
{
  nameLabel.text  = [object fullName];
  emailLabel.text = @"OnMyBlock user";
  if (object.image) {
    userImageView.image = [object imageForSize:userImageView.bounds.size];
  }
  else {
    [object downloadImageFromImageURLWithCompletion:^(NSError *error) {
      if (object.image) {
        userImageView.image = [object imageForSize:userImageView.bounds.size];
      }
      else {
        userImageView.image = [OMBUser placeholderImage];
      }
    }];
  }
}

@end
