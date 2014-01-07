//
//  OMBPayoutMethodCell.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/11/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBPayoutMethodCell.h"

#import "UIColor+Extensions.h"

@implementation OMBPayoutMethodCell

#pragma mark - Initializer

- (id) initWithStyle: (UITableViewCellStyle) style 
reuseIdentifier: (NSString *) reuseIdentifier
{
  if (!(self = [super initWithStyle: style 
    reuseIdentifier: reuseIdentifier])) return nil;
  
  self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

  CGRect screen = [[UIScreen mainScreen] bounds];
  float screenWidth = screen.size.width;

  float padding = 20.0f;
  float height  = (padding * 0.5) + 27.0f + 22.0f + 22.0f + (padding * 0.5);

  float iconViewSize = height / 1.618;
  _iconView = [[UIView alloc] init];
  _iconView.clipsToBounds = YES;
  _iconView.layer.cornerRadius = 2.0f;
  _iconView.frame = CGRectMake(padding, 
    (padding * 0.5) + ((height - iconViewSize) * 0.5), 
      iconViewSize, iconViewSize);
  [self.contentView addSubview: _iconView];

  float imageSize = iconViewSize / 1.618;
  _iconImageView = [[UIImageView alloc] init];
  _iconImageView.frame = CGRectMake((iconViewSize - imageSize) * 0.5,
    (iconViewSize - imageSize) * 0.5, imageSize, imageSize);
  [_iconView addSubview: _iconImageView];

  _nameLabel = [[UILabel alloc] init];
  _nameLabel.font = [UIFont fontWithName: @"HelveticaNeue-Medium" size: 18];
  _nameLabel.frame = CGRectMake(
    _iconView.frame.origin.x + _iconView.frame.size.width + padding, 
      padding, 
        screenWidth - (_iconView.frame.origin.x + 
        _iconView.frame.size.width + padding + padding), 
          27.0f);
  _nameLabel.textColor = [UIColor textColor];
  [self.contentView addSubview: _nameLabel];

  _detailLabel = [[UILabel alloc] init];
  _detailLabel.font = [UIFont fontWithName: @"HelveticaNeue-Light" size: 15];
  _detailLabel.frame = CGRectMake(_nameLabel.frame.origin.x,
    _nameLabel.frame.origin.y + _nameLabel.frame.size.height,
      _nameLabel.frame.size.width, 22.0f * 2);
  _detailLabel.numberOfLines = 0;
  _detailLabel.textColor = [UIColor grayMedium];
  [self.contentView addSubview: _detailLabel];

  return self;
}

#pragma mark - Override

#pragma mark - Override UITableViewCell

- (void) setSelected: (BOOL) selected animated: (BOOL) animated
{
  [super setSelected: selected animated: animated];
  _iconView.backgroundColor = _iconViewBackgroundColor;
}

@end
