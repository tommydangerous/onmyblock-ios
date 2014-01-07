//
//  OMBResidenceDetailCell.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/17/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBResidenceDetailCell.h"

@implementation OMBResidenceDetailCell

#pragma mark - Initializer

- (id) initWithStyle: (UITableViewCellStyle) style 
reuseIdentifier: (NSString *)reuseIdentifier
{
  if (!(self = [super initWithStyle: style reuseIdentifier: reuseIdentifier])) 
    return nil;

  CGRect screen = [[UIScreen mainScreen] bounds];

  float screeWidth = screen.size.width;

  float padding = 20.0f;

  self.selectionStyle = UITableViewCellSelectionStyleNone;

  _titleLabel = [[OMBLabel alloc] init];
  _titleLabel.edgeInsets = UIEdgeInsetsMake(0.0f, padding, 0.0f, 0.0f);
  _titleLabel.font = [UIFont fontWithName: @"HelveticaNeue-Medium" size: 15];
  _titleLabel.frame = CGRectMake(0.0f, 0.0f, screeWidth, 44.0f);
  _titleLabel.textColor = [UIColor blue];
  [self.contentView addSubview: _titleLabel];
  // Top border
  CALayer *topBorder = [CALayer layer];
  topBorder.backgroundColor = [UIColor grayLight].CGColor;
  topBorder.frame = CGRectMake(0.0f, 0.0f, _titleLabel.frame.size.width, 0.5f);
  [_titleLabel.layer addSublayer: topBorder];
  // Bottom border
  CALayer *bottomBorder = [CALayer layer];
  bottomBorder.backgroundColor = topBorder.backgroundColor;
  bottomBorder.frame = CGRectMake(padding, 
    _titleLabel.frame.size.height - topBorder.frame.size.height,
      topBorder.frame.size.width - padding, topBorder.frame.size.height);
  [_titleLabel.layer addSublayer: bottomBorder];

  return self;
}

#pragma mark - Methods

#pragma mark - Class Methods

+ (CGFloat) heightForCell
{
  // Subclasses implement this
  return 0.0f;
}

@end
