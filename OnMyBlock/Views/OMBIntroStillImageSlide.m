//
//  OMBIntroStillImageSlide.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/12/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBIntroStillImageSlide.h"

#import "DRNRealTimeBlurView.h"

@implementation OMBIntroStillImageSlide

#pragma mark - Initializer

- (id) initWithBackgroundImage: (UIImage *) image
{
  if (!(self = [super init])) return nil;

  CGRect screen =[[UIScreen mainScreen] bounds];
  float screenHeight = screen.size.height;
  float screenWidth  = screen.size.width;

  self.frame = screen;

  // Background view
  UIView *backgroundView = [[UIView alloc] initWithFrame: self.frame];
  [self addSubview: backgroundView];
  // Background image
  UIImageView *backgroundImageView  = [[UIImageView alloc] init];
  backgroundImageView.clipsToBounds = YES;
  backgroundImageView.contentMode   = UIViewContentModeScaleAspectFill;
  backgroundImageView.frame         = backgroundView.frame;
  backgroundImageView.image         = image;
  [backgroundView addSubview: backgroundImageView];
  // Black tint
  UIView *colorView         = [[UIView alloc] init];
  colorView.backgroundColor = [UIColor colorWithWhite: 0.0f alpha: 0.3f];
  colorView.frame           = backgroundView.frame;
  [backgroundView addSubview: colorView];
  // Blur
  DRNRealTimeBlurView* blurView = [[DRNRealTimeBlurView alloc] init];
  blurView.blurRadius           = 0.3f;
  blurView.frame                = backgroundView.frame;
  blurView.renderStatic         = YES;
  // [backgroundView addSubview: blurView];

  float padding = 20.0f;

  _titleLabel = [[UILabel alloc] init];
  _titleLabel.font = [UIFont fontWithName: @"HelveticaNeue-Light" size: 36.0f];
  _titleLabel.frame = CGRectMake(0.0f, padding + ((screenHeight - 54) * 0.5),
    screenWidth, 54.0f);
  _titleLabel.textColor = [UIColor whiteColor];
  _titleLabel.textAlignment = NSTextAlignmentCenter;
  [self addSubview: _titleLabel];

  _detailLabel = [[UILabel alloc] init];
  _detailLabel.font = [UIFont fontWithName: @"HelveticaNeue-Light" size: 18.0f];
  _detailLabel.frame = CGRectMake(_titleLabel.frame.origin.x,
    _titleLabel.frame.origin.y + _titleLabel.frame.size.height + padding,
      _titleLabel.frame.size.width, 27.0f * 2);
  _detailLabel.numberOfLines = 0;
  _detailLabel.textColor = _titleLabel.textColor;
  [self addSubview: _detailLabel];

  float imageSize = screenHeight * 0.3;
  _imageView = [[UIImageView alloc] init];
  _imageView.frame = CGRectMake((screenWidth - imageSize) * 0.5,
    _titleLabel.frame.origin.y - (imageSize + padding), imageSize, imageSize);
    [self addSubview: _imageView];

  return self;
}

- (void) setDetailLabelText: (NSString *) string
{
  NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
  style.maximumLineHeight = 27.0f;
  style.minimumLineHeight = 27.0f;
  NSMutableAttributedString *aString = 
    [[NSMutableAttributedString alloc] initWithString: string attributes: @{
      NSParagraphStyleAttributeName: style
    }
  ];
  _detailLabel.attributedText = aString;
  _detailLabel.textAlignment = _titleLabel.textAlignment;
}

@end
