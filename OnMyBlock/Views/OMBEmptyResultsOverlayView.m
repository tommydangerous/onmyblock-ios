//
//  OMBEmptyResultsOverlayView.m
//  OnMyBlock
//
//  Created by Paul Aguilar on 10/16/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBEmptyResultsOverlayView.h"

#import "NSString+Extensions.h"
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
  
  titleLabel = [UILabel new];
  titleLabel.font = [UIFont mediumTextFont];
  titleLabel.frame = CGRectMake(padding,
    mapIcon.frame.origin.y + mapIcon.frame.size.height + 2 * padding,
      self.frame.size.width - 2 * padding, 23.f);
  titleLabel.numberOfLines = 0;
  titleLabel.textAlignment = NSTextAlignmentCenter;
  titleLabel.textColor = UIColor.darkGrayColor;
  [self addSubview:titleLabel];
  
  subtitleLabel = [UILabel new];
  subtitleLabel.font = [UIFont mediumLargeTextFontBold];
  subtitleLabel.frame = CGRectMake(titleLabel.frame.origin.x,
    titleLabel.frame.origin.y + titleLabel.frame.size.height + padding * .75f,
      titleLabel.frame.size.width, 30.f);
  subtitleLabel.text = @"But we will be soon!";
  subtitleLabel.textAlignment = NSTextAlignmentCenter;
  subtitleLabel.textColor = titleLabel.textColor;
  [self addSubview:subtitleLabel];

  return self;
}

#pragma mark - Instance Methods

- (void)setTitle:(NSString *)title
{
  titleLabel.text = title;
  
  CGSize sizeTitle = [title boundingRectWithSize:
    CGSizeMake(titleLabel.frame.size.width, 999)
      font:titleLabel.font].size;
  
  titleLabel.frame = CGRectMake(
    titleLabel.frame.origin.x,
      titleLabel.frame.origin.y,
        titleLabel.frame.size.width, sizeTitle.height);
  
  subtitleLabel.frame = CGRectMake(
    titleLabel.frame.origin.x,
      titleLabel.frame.origin.y +
        titleLabel.frame.size.height + 20.f * .75f,
          subtitleLabel.frame.size.width,
            subtitleLabel.frame.size.height);
}

@end
