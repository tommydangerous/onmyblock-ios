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

@implementation OMBRoommateCell

#pragma mark - Initializer

- (id) initWithStyle: (UITableViewCellStyle) style
     reuseIdentifier: (NSString *) reuseIdentifier
{
  if (!(self = [super initWithStyle: style
    reuseIdentifier: reuseIdentifier])) return nil;
  
  CGRect screen     = [[UIScreen mainScreen] bounds];
  float screenWidth = screen.size.width;
  float padding = 20.0f;
  CGFloat imageSize = 44;
  
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
      padding, screenWidth - (imageSize - 2 * padding), 22);
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

- (void) loadData: (OMBRoommate *) object
{
  self.roommate = object;
  [userImageView setImage: [OMBUser placeholderImage]];
  nameLabel.text = [NSString stringWithFormat: @"%@ %@",
    [self.roommate.firstName capitalizedString],
      [self.roommate.lastName capitalizedString]];
  emailLabel.text = self.roommate.email;
}

@end
