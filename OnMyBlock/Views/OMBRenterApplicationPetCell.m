//
//  OMBRenterApplicationPetCell.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/6/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBRenterApplicationPetCell.h"

#import "UIColor+Extensions.h"

@implementation OMBRenterApplicationPetCell

- (id) initWithStyle: (UITableViewCellStyle) style 
reuseIdentifier: (NSString *)reuseIdentifier
{
  self = [super initWithStyle: style reuseIdentifier: reuseIdentifier];

  _isSelected = NO;

  int padding = 20.0f;

  // Image
  UIView *iconView = [[UIView alloc] init];
  iconView.backgroundColor = [UIColor clearColor];
  iconView.clipsToBounds = YES;
  iconView.frame = CGRectMake(padding, padding, 40.0f, 40.0f);
  iconView.layer.cornerRadius = iconView.frame.size.width * 0.5;
  [self.contentView addSubview: iconView];
  _iconImageView = [[UIImageView alloc] init];
  _iconImageView.frame = iconView.frame;
  // _iconImageView.frame = CGRectMake(15.0f, 15.0f, 30.0f, 30.0f);
  // [iconView addSubview: _iconImageView];
  [self.contentView addSubview: _iconImageView];

  // Label
  _nameLabel = [[UILabel alloc] init];
  _nameLabel.font = [UIFont fontWithName: @"HelveticaNeue-Light" size: 18];
  _nameLabel.frame = CGRectMake(
    iconView.frame.origin.x + iconView.frame.size.width + padding,
      iconView.frame.origin.y, iconView.frame.size.width * 3,
        iconView.frame.size.height);
  [self.contentView addSubview: _nameLabel];

  float checkmarkBoxSize = 26.0f;
  _checkmarkBox = [[UIView alloc] init];
  _checkmarkBox.frame = CGRectMake(
    self.contentView.frame.size.width - (checkmarkBoxSize + padding), 
      (iconView.frame.size.height + (padding * 2) - checkmarkBoxSize) * 0.5, 
        checkmarkBoxSize, checkmarkBoxSize);
  _checkmarkBox.layer.borderColor = [UIColor grayLight].CGColor;
  _checkmarkBox.layer.borderWidth = 1.0f;
  _checkmarkBox.layer.cornerRadius = checkmarkBoxSize * 0.5;
  [self.contentView addSubview: _checkmarkBox];
  _checkmarkImageView = [[UIImageView alloc] init];
  _checkmarkImageView.frame = CGRectMake(5.0f, 5.0f, 
    checkmarkBoxSize - (5 * 2), checkmarkBoxSize - (5 * 2));
  [_checkmarkBox addSubview: _checkmarkImageView];

  return self;
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) emptyCheckmarkBox
{
  _checkmarkBox.backgroundColor   = [UIColor clearColor];
  _checkmarkBox.layer.borderColor = [UIColor grayLight].CGColor;
  _checkmarkImageView.image = nil;
  _isSelected = NO;
}

- (void) fillInCheckmarkBox
{
  _checkmarkBox.backgroundColor   = [UIColor blue];
  _checkmarkBox.layer.borderColor = [UIColor blue].CGColor;
  _checkmarkImageView.image = [UIImage imageNamed: @"checkmark_outline.png"];
  _isSelected = YES;
}

- (void) toggleCheckmarkBox
{
  if (_isSelected) {
    [self emptyCheckmarkBox];
  }
  else {
    [self fillInCheckmarkBox];
  }
}

@end
