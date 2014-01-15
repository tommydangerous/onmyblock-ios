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
  _backgroundView = [[UIView alloc] initWithFrame: self.frame];
  // [self addSubview: _backgroundView];
  // Background image
  UIImageView *backgroundImageView  = [[UIImageView alloc] init];
  backgroundImageView.clipsToBounds = YES;
  backgroundImageView.contentMode   = UIViewContentModeScaleAspectFill;
  backgroundImageView.frame         = _backgroundView.frame;
  backgroundImageView.image         = image;
  [_backgroundView addSubview: backgroundImageView];
  // Black tint
  UIView *colorView         = [[UIView alloc] init];
  colorView.backgroundColor = [UIColor colorWithWhite: 0.0f alpha: 0.3f];
  colorView.frame           = _backgroundView.frame;
  [_backgroundView addSubview: colorView];
  // Blur
  DRNRealTimeBlurView *blurView = [[DRNRealTimeBlurView alloc] init];
  blurView.blurRadius           = 0.3f;
  blurView.frame                = _backgroundView.frame;
  blurView.renderStatic         = YES;
  [_backgroundView addSubview: blurView];

  float padding = 20.0f;

  CGFloat spacing = screenHeight * 0.05f;

  _detailLabel = [[UILabel alloc] init];
  _detailLabel.font = [UIFont fontWithName: @"HelveticaNeue-Light" size: 18.0f];
  _detailLabel.frame = CGRectMake(0.0f, 
    padding + spacing + ((screenHeight - 54) * 0.5), 
      screenWidth, 27.0f * 2);
  _detailLabel.numberOfLines = 0;
  _detailLabel.textColor = [UIColor whiteColor];;
  [self addSubview: _detailLabel];

  _titleLabel = [[UILabel alloc] init];
  _titleLabel.font = [UIFont fontWithName: @"HelveticaNeue-Light" size: 36.0f];
  _titleLabel.frame = CGRectMake(_detailLabel.frame.origin.x, 
    _detailLabel.frame.origin.y - (54.0f + padding), 
      _detailLabel.frame.size.width, 54.0f);
  _titleLabel.textColor = [UIColor whiteColor];
  _titleLabel.textAlignment = NSTextAlignmentCenter;
  [self addSubview: _titleLabel];

  _secondDetailLabel = [[UILabel alloc] init];
  _secondDetailLabel.font = _detailLabel.font;
  _secondDetailLabel.frame = CGRectMake(_detailLabel.frame.origin.x,
    _detailLabel.frame.origin.y + _detailLabel.frame.size.height + 
    (padding * 0.5f),
      _detailLabel.frame.size.width, 27.0f);
  _secondDetailLabel.textAlignment = _titleLabel.textAlignment;
  _secondDetailLabel.textColor = _detailLabel.textColor;
  [self addSubview: _secondDetailLabel];

  CGFloat imageSize = screenHeight * 0.25;
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
