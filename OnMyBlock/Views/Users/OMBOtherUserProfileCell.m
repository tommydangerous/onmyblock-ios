//
//  OMBOtherUserProfileCell.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 2/10/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBOtherUserProfileCell.h"

#import "OMBViewController.h"
#import "UIColor+Extensions.h"

@implementation OMBOtherUserProfileCell

#pragma mark - Initialzer

- (id) initWithFrame: (CGRect) rect
{
  if (!(self = [super initWithFrame: rect])) return nil;

  self.backgroundColor = [UIColor whiteColor];

  CGFloat padding = OMBPadding;
  CGFloat imageSize = self.frame.size.height * 0.8f;
  _imageView = [UIImageView new];
  _imageView.alpha = 0.3f;
  _imageView.contentMode = UIViewContentModeScaleAspectFill;
  _imageView.frame = CGRectMake(0.0f, 
    (self.frame.size.height - imageSize) * 0.5f, imageSize, imageSize);
  [self.contentView addSubview: _imageView];

  CGFloat labelOriginX = 
    _imageView.frame.origin.x + _imageView.frame.size.width + padding;
  _label = [UILabel new];
  _label.font = [UIFont smallTextFont];
  _label.frame = CGRectMake(labelOriginX, 0.0f, self.frame.size.width, 
    OMBStandardHeight * 0.5f);
  // _label.textAlignment = NSTextAlignmentCenter;
  _label.textColor = [UIColor textColor];
  [self.contentView addSubview: _label];

  _valueLabel = [UILabel new];
  _valueLabel.font = [UIFont smallTextFontBold];
  _valueLabel.frame = CGRectMake(_label.frame.origin.x,
    _label.frame.origin.y + _label.frame.size.height, _label.frame.size.width,
      _label.frame.size.height);
  _valueLabel.textAlignment = _label.textAlignment;
  _valueLabel.textColor = [UIColor blueDark];
  [self.contentView addSubview: _valueLabel];

  return self;
}

#pragma mark - Methods

#pragma mark - Class Methods

+ (CGFloat) heightForCell
{
  return OMBStandardHeight;
}

+ (NSString *) reuseIdentifier
{
  return @"OMBOtherUserProfileCellReuseIdentifier";
}

@end
