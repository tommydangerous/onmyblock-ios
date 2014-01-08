//
//  OMBHomebaseRenterAddRemoveRoommatesOptionCell.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 1/7/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBHomebaseRenterAddRemoveRoommatesOptionCell.h"

#import "UIImage+Color.h"
#import "UIImage+NegativeImage.h"

@implementation OMBHomebaseRenterAddRemoveRoommatesOptionCell

#pragma mark - Initializer

- (id) initWithStyle: (UITableViewCellStyle) style 
reuseIdentifier: (NSString *) reuseIdentifier
{
  if (!(self = [super initWithStyle: style reuseIdentifier: reuseIdentifier])) 
    return nil;

  self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

  imageBackgroundView = [UIView new];
  imageBackgroundView.frame = objectImageView.frame;
  [self.contentView addSubview: imageBackgroundView];

  backgroundImageView = [UIImageView new];
  backgroundImageView.clipsToBounds = YES;
  backgroundImageView.frame = CGRectMake(0.0f, 0.0f, 
    imageBackgroundView.frame.size.width, 
      imageBackgroundView.frame.size.height);
  backgroundImageView.layer.cornerRadius = 5.0f;
  [imageBackgroundView addSubview: backgroundImageView];

  [objectImageView removeFromSuperview];
  CGRect rect = objectImageView.frame;
  rect.origin.x = 3.0f;
  rect.origin.y = 3.0f;
  rect.size.height = rect.size.height - (3.0f * 2);
  rect.size.width = rect.size.width - (3.0f * 2);

  objectImageView.frame = rect;
  objectImageView.layer.cornerRadius = 0.0f;
  [imageBackgroundView addSubview: objectImageView];

  return self;
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) setupForContacts
{
  backgroundImageView.image = [UIImage imageWithColor: [UIColor blueLight]];
  objectImageView.image = 
    [[UIImage imageNamed: @"user_icon.png"] negativeImage];
  topLabel.text = @"From Contacts";
}

- (void) setupForEmail
{
  backgroundImageView.image = [UIImage imageWithColor: [UIColor grayMedium]];
  objectImageView.image = [UIImage imageNamed: @"messages_icon_white.png"];
  topLabel.text = @"From Email";
}

- (void) setupForFacebook
{
  backgroundImageView.image = [UIImage imageWithColor: [UIColor facebookBlue]];
  objectImageView.image = [UIImage imageNamed: @"facebook_icon.png"];
  topLabel.text = @"From Facebook";
}

- (void) setupForOnMyBlock
{
  backgroundImageView.image = [UIImage imageWithColor: [UIColor blue]];
  objectImageView.image = [UIImage imageNamed: @"logo_white.png"];
  topLabel.text = @"From OnMyBlock";
}

@end
