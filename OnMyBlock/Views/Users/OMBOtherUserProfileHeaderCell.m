//
//  OMBOtherUserProfileHeaderCell.m
//  OnMyBlock
//
//  Created by Paul Aguilar on 3/24/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBOtherUserProfileHeaderCell.h"

#import "OMBViewController.h"

@implementation OMBOtherUserProfileHeaderCell

#pragma mark - Initializer

- (id) initWithStyle: (UITableViewCellStyle) style
     reuseIdentifier: (NSString *) reuseIdentifier
{
  if (!(self = [super initWithStyle: style
    reuseIdentifier: reuseIdentifier])) return nil;
  
  CGFloat labelHeight = 44.0f;
  CGFloat padding = OMBPadding;
  CGFloat width   = self.frame.size.width;
  
  // Image
  CGFloat imageSize = labelHeight * 0.5f;
  
  _iconView = [UIImageView new];
  _iconView.alpha = 0.3f;
  _iconView.frame = CGRectMake(padding,
    padding + ((labelHeight - imageSize) * 0.5f), imageSize, imageSize);
  [self.contentView addSubview: _iconView];
  
  // Label
  CGFloat originX = _iconView.frame.origin.x +
  _iconView.frame.size.width + (padding * 0.5f);
  _headLabel = [UILabel new];
  _headLabel.font = [UIFont mediumTextFont];
  _headLabel.frame = CGRectMake(originX, padding,
    width - (originX + (padding * 0.5f)), labelHeight);
  _headLabel.textColor = [UIColor grayMedium];
  [self.contentView addSubview: _headLabel];
  
  self.backgroundColor = [UIColor grayUltraLight];
  self.selectionStyle = UITableViewCellSelectionStyleNone;
  self.separatorInset = UIEdgeInsetsMake(0.0f,
    width, 0.0f, 0.0f);
  
  return self;
}

#pragma mark - Methods

#pragma mark - Class Methods

+ (CGFloat) heightForCell{
  return OMBPadding + OMBStandardHeight + OMBPadding;
}

@end
