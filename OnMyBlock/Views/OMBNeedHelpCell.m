//
//  OMBNeedHelpCell.m
//  OnMyBlock
//
//  Created by Paul Aguilar on 8/18/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBNeedHelpCell.h"

#import "OMBMapViewController.h"
#import "UIFont+OnMyBlock.h"

@implementation OMBNeedHelpCell

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
{
  if(!(self = [super initWithStyle:style
      reuseIdentifier:reuseIdentifier]))
    return nil;
  
  self.backgroundColor = UIColor.blackColor;
  self.clipsToBounds = YES;
  self.selectionStyle = UITableViewCellSelectionStyleNone;
  
  CGRect screen = [UIScreen mainScreen].bounds;
  float height = screen.size.height * PropertyInfoViewImageHeightPercentage;
  
  float padding = 20.f;
  float originY = (height - (40.f + 35.f)) * .5f;
  
  _titleLabel = [UILabel new];
  _titleLabel.font = [UIFont largeTextFontBold];
  _titleLabel.frame = CGRectMake(padding, originY,
    screen.size.width - 2 * padding, 40.f);
  _titleLabel.textAlignment = NSTextAlignmentCenter;
  _titleLabel.textColor = UIColor.whiteColor;
  [self.contentView addSubview:_titleLabel];
  
  _secondLabel = [UILabel new];
  _secondLabel.font = [UIFont normalTextFont];
  _secondLabel.frame = CGRectMake(
    (screen.size.width - 130.f) * .5f,
      _titleLabel.frame.origin.y +
        _titleLabel.frame.size.height,
          130.f, 35.f);
  _secondLabel.textAlignment = NSTextAlignmentCenter;
  _secondLabel.textColor = [UIColor blue];
  [self.contentView addSubview:_secondLabel];
  
  UIView *borderView = [UIView new];
  borderView.frame = CGRectMake(0.0f,
    height - 2.f, screen.size.width, 2.f);
  borderView.backgroundColor = [UIColor grayDarkAlpha:0.4];
  [self.contentView addSubview:borderView];
  
  return self;
}

@end
