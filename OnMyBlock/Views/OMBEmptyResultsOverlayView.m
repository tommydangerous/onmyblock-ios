//
//  OMBEmptyResultsOverlayView.m
//  OnMyBlock
//
//  Created by Paul Aguilar on 10/16/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBEmptyResultsOverlayView.h"

// Categories
#import "NSString+Extensions.h"
#import "UIColor+Extensions.h"
#import "UIFont+OnMyBlock.h"

// View Controllers
#import "OMBViewController.h"

@interface OMBEmptyResultsOverlayView()
{
  UILabel *subtitleLabel;
  UILabel *titleLabel;
}

@end

@implementation OMBEmptyResultsOverlayView

- (id)init
{
  if (!(self = [super init])) return nil;

  self.frame = [UIScreen mainScreen].bounds;

  UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:
    UIBlurEffectStyleExtraLight];
  UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:
    blurEffect];
  effectView.frame = self.frame;
  [self addSubview:effectView];
  
  CGFloat padding = OMBPadding * 0.75;
  
  CGFloat imageWidth = CGRectGetWidth(self.frame) * 0.7;
  UIImageView *mapIcon = [UIImageView new];
  mapIcon.frame = CGRectMake(
    (self.frame.size.width - imageWidth) * 0.5,
    (CGRectGetHeight(self.frame) - imageWidth) * 0.3, 
    imageWidth, imageWidth);
  mapIcon.image = [UIImage imageNamed:@"map_no_results"];
  [self addSubview:mapIcon];
  
  titleLabel       = [UILabel new];
  titleLabel.font  = [UIFont mediumLargeTextFontBold];
  titleLabel.frame = CGRectMake(
    padding,
    mapIcon.frame.origin.y + mapIcon.frame.size.height,
    self.frame.size.width - (padding * 2), 
    23.f
  );
  titleLabel.numberOfLines = 0;
  titleLabel.textAlignment = NSTextAlignmentCenter;
  titleLabel.textColor     = UIColor.darkGrayColor;
  [self addSubview:titleLabel];
  
  subtitleLabel       = [UILabel new];
  subtitleLabel.font  = [UIFont mediumLargeTextFontBold];
  subtitleLabel.frame = CGRectMake(
    titleLabel.frame.origin.x,
    titleLabel.frame.origin.y + titleLabel.frame.size.height + padding,
    titleLabel.frame.size.width, 
    30.f
  );
  subtitleLabel.text          = @"But we will be soon!";
  subtitleLabel.textAlignment = NSTextAlignmentCenter;
  subtitleLabel.textColor     = titleLabel.textColor;
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
