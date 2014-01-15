//
//  OMBMyRenterApplicationEmailPhoneCell.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 1/14/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBMyRenterApplicationEmailPhoneCell.h"

@implementation OMBMyRenterApplicationEmailPhoneCell

#pragma mark - Initializer

- (id) initWithStyle: (UITableViewCellStyle) style 
reuseIdentifier: (NSString *)reuseIdentifier
{ 
  if (!(self = [super initWithStyle: style reuseIdentifier: reuseIdentifier])) 
    return nil;

  CGRect screen = [[UIScreen mainScreen] bounds];
  CGFloat screenWidth  = screen.size.width;
  CGFloat padding = 20.0f;
  CGFloat standardHeight = 44.0f;

  CGFloat imageSize = standardHeight;
  UIImageView *emailImageView = [UIImageView new];
  emailImageView.alpha = 0.3f;
  emailImageView.frame = CGRectMake(padding, padding, 
    imageSize, imageSize);
  emailImageView.image = [UIImage imageNamed: @"messages_icon_dark.png"];
  [self.contentView addSubview: emailImageView];

  UIImageView *phoneImageView = [UIImageView new];
  phoneImageView.alpha = emailImageView.alpha;
  phoneImageView.frame = CGRectMake(emailImageView.frame.origin.x,
    emailImageView.frame.origin.y + emailImageView.frame.size.height + padding,
      emailImageView.frame.size.width, emailImageView.frame.size.height);
  phoneImageView.image = [UIImage imageNamed: @"phone_icon.png"];
  [self.contentView addSubview: phoneImageView];

  CGFloat labelWidth = screenWidth - (padding + imageSize + padding + padding);
  _emailLabel = [UILabel new];
  _emailLabel.font = [UIFont fontWithName: @"HelveticaNeue-Light" size: 15];
  _emailLabel.frame = CGRectMake(emailImageView.frame.origin.x + 
    emailImageView.frame.size.width + padding, emailImageView.frame.origin.y,
      labelWidth, standardHeight);
  _emailLabel.textColor = [UIColor textColor];
  [self.contentView addSubview: _emailLabel];

  _phoneLabel = [UILabel new];
  _phoneLabel.font = _emailLabel.font;
  _phoneLabel.frame = CGRectMake(_emailLabel.frame.origin.x,
    phoneImageView.frame.origin.y, _emailLabel.frame.size.width,
      _emailLabel.frame.size.height);
  _phoneLabel.textColor = _emailLabel.textColor;
  [self.contentView addSubview: _phoneLabel];

  return self;
}

#pragma mark - Methods

#pragma mark - Class Methods

+ (CGFloat) heightForCell
{
  CGFloat padding = 20.0f;
  CGFloat standardHeight = 44.0f;
  return padding + standardHeight + padding + standardHeight + padding;
}

@end
