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
  
  _needPlaceLabel = [UILabel new];
  _needPlaceLabel.font = [UIFont largeTextFontBold];
  _needPlaceLabel.frame = CGRectMake(padding, originY,
    screen.size.width - 2 * padding, 40.f);
  _needPlaceLabel.textAlignment = NSTextAlignmentCenter;
  _needPlaceLabel.textColor = UIColor.whiteColor;
  [self.contentView addSubview:_needPlaceLabel];
  
  _contactButton = [UIButton new];
  _contactButton.frame = CGRectMake(
    (screen.size.width - 130.f) * .5f,
      _needPlaceLabel.frame.origin.y +
        _needPlaceLabel.frame.size.height,
          130.f, 35.f);
  _contactButton.titleLabel.font = [UIFont normalTextFont];
  [_contactButton setTitle:@"Contact Us" forState:UIControlStateNormal];
  [_contactButton setTitleColor:[UIColor blue]
    forState:UIControlStateNormal];
  [self.contentView addSubview:_contactButton];
  
  UIView *borderView = [UIView new];
  borderView.frame = CGRectMake(0.0f,
    height - 2.f, screen.size.width, 2.f);
  borderView.backgroundColor = [UIColor grayDarkAlpha:0.4];
  [self.contentView addSubview:borderView];
  
  return self;
}

@end
