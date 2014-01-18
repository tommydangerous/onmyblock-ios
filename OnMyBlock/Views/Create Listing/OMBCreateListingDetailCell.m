//
//  OMBCreateListingDetailCell.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/27/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBCreateListingDetailCell.h"

@implementation OMBCreateListingDetailCell

#pragma mark - Initializer

- (id) initWithStyle: (UITableViewCellStyle) style 
reuseIdentifier: (NSString *) reuseIdentifier
{
  if (!(self = [super initWithStyle: style 
    reuseIdentifier: reuseIdentifier])) return nil;

  _detailNameLabel = [UILabel new];
  _detailNameLabel.font = [UIFont fontWithName: @"HelveticaNeue-Light" 
    size: 15];
  _detailNameLabel.textAlignment = NSTextAlignmentCenter;
  _detailNameLabel.textColor = [UIColor grayMedium];
  [self.contentView addSubview: _detailNameLabel];

  _valueLabel = [UILabel new];
  _valueLabel.font = [UIFont fontWithName: @"HelveticaNeue-Medium" size: 18];
  _valueLabel.textAlignment = _detailNameLabel.textAlignment;
  _valueLabel.textColor = [UIColor blueDark];
  [self.contentView addSubview: _valueLabel];

  _minusButton = [UIButton new];
  _minusButton.layer.borderColor = [UIColor grayLight].CGColor;
  _minusButton.layer.borderWidth = 1.0f;
  _minusButton.titleLabel.font = [UIFont fontWithName: @"HelveticaNeue-Light"
    size: 18];
  [_minusButton setTitle: @"-" forState: UIControlStateNormal];
  [_minusButton setTitleColor: _valueLabel.textColor 
    forState: UIControlStateNormal];
  [self.contentView addSubview: _minusButton];

  _plusButton = [UIButton new];
  _plusButton.layer.borderColor = _minusButton.layer.borderColor;
  _plusButton.layer.borderWidth = _minusButton.layer.borderWidth;
  _plusButton.titleLabel.font = _minusButton.titleLabel.font;
  [_plusButton setTitle: @"+" forState: UIControlStateNormal];
  [_plusButton setTitleColor: _valueLabel.textColor 
    forState: UIControlStateNormal];
  [self.contentView addSubview: _plusButton];

  return self;
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) setFramesForSubviewsWithSize: (CGSize) size
{
  CGFloat padding      = 20.0f;
  CGFloat detailHeight = 30.0f;
  CGFloat valueHeight  = size.height - 
    ((padding * 0.5) + detailHeight + padding);
  _detailNameLabel.frame = CGRectMake(0.0f, 0.0f, size.width, detailHeight);

  if (valueHeight > 58.0f)
    valueHeight = 58.0f;

  _valueLabel.frame = CGRectMake(padding + valueHeight, 
    _detailNameLabel.frame.origin.y + 
    _detailNameLabel.frame.size.height + (padding * 0.5),
      size.width - ((padding * 2) + (valueHeight * 2)), valueHeight);
  CALayer *topBorder = [CALayer layer];
  topBorder.backgroundColor = _minusButton.layer.borderColor;
  topBorder.frame = CGRectMake(0.0f, 0.0f, _valueLabel.frame.size.width, 1.0f);
  [_valueLabel.layer addSublayer: topBorder];
  CALayer *bottomBorder = [CALayer layer];
  bottomBorder.backgroundColor = topBorder.backgroundColor;
  bottomBorder.frame = CGRectMake(topBorder.frame.origin.x,
    _valueLabel.frame.size.height - topBorder.frame.size.height,
      topBorder.frame.size.width, topBorder.frame.size.height);
  [_valueLabel.layer addSublayer: bottomBorder];

  _minusButton.frame = CGRectMake(padding, _valueLabel.frame.origin.y,
    valueHeight, valueHeight);
  _plusButton.frame = CGRectMake(size.width - (valueHeight + padding),
    _minusButton.frame.origin.y, _minusButton.frame.size.width,
      _minusButton.frame.size.height);
}

@end
