//
//  OMBHeaderTitleCell.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/31/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBHeaderTitleCell.h"

@implementation OMBHeaderTitleCell

#pragma mark - Initialize

- (id) initWithStyle: (UITableViewCellStyle) style 
reuseIdentifier: (NSString *)reuseIdentifier
{ 
  if (!(self = [super initWithStyle: style reuseIdentifier: reuseIdentifier])) 
    return nil;

  self.backgroundColor = [UIColor grayUltraLight];
  self.selectionStyle = UITableViewCellSelectionStyleNone;

  CGRect screen = [[UIScreen mainScreen] bounds];
  CGFloat padding = 20.0f;

  _titleLabel = [UILabel new];
  _titleLabel.font = [UIFont fontWithName: @"HelveticaNeue-Medium" size: 15];
  _titleLabel.frame = CGRectMake(padding, 0.0f, 
    screen.size.width - (padding * 2), 44.0f);
  _titleLabel.textColor = [UIColor grayMedium];
  [self.contentView addSubview: _titleLabel];

  UIView *bottomBorder = [UIView new];
  bottomBorder.backgroundColor = [UIColor grayLight];
  bottomBorder.frame = CGRectMake(0.0f, 44.0f - 0.5f, screen.size.width, 0.5f);
  [self.contentView addSubview: bottomBorder];

  return self;
}

@end
