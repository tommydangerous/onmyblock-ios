//
//  OMBEmptyResultsOverlayView.m
//  OnMyBlock
//
//  Created by Paul Aguilar on 10/16/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBEmptyResultsOverlayView.h"

#import "UIColor+Extensions.h"
#import "UIFont+OnMyBlock.h"

@implementation OMBEmptyResultsOverlayView

- (id)init
{
  if(!(self = [super init]))
    return nil;
  
  self.backgroundColor = [UIColor colorWithWhite:1.f alpha:0.7f];
  self.frame = [UIScreen mainScreen].bounds;
  
  CGFloat padding = 20.f;
  
  UIImageView *mapIcon = [UIImageView new];
  mapIcon.frame = CGRectMake(
    (self.frame.size.width - 112.5f) * .5f,
      self.frame.size.height * .3f, 112.5f, 112.5f);
  mapIcon.image = [UIImage imageNamed:@"map_marker_blue_icon"];
  [self addSubview:mapIcon];
  
  _titleLabel = [UILabel new];
  _titleLabel.font = [UIFont mediumTextFont];
  _titleLabel.frame = CGRectMake(padding,
    mapIcon.frame.origin.y + mapIcon.frame.size.height + 2 * padding,
      self.frame.size.width - 2 * padding, 23.f);
  _titleLabel.textAlignment = NSTextAlignmentCenter;
  _titleLabel.textColor = UIColor.darkGrayColor;
  [self addSubview:_titleLabel];
  
  UILabel *subtitleLabel = [UILabel new];
  subtitleLabel.font = [UIFont mediumLargeTextFontBold];
  subtitleLabel.frame = CGRectMake(_titleLabel.frame.origin.x,
    _titleLabel.frame.origin.y + _titleLabel.frame.size.height + padding * .75f,
      _titleLabel.frame.size.width, 30.f);
  subtitleLabel.text = @"But we will be soon!";
  subtitleLabel.textAlignment = NSTextAlignmentCenter;
  subtitleLabel.textColor = _titleLabel.textColor;
  [self addSubview:subtitleLabel];

  return self;
}

@end
