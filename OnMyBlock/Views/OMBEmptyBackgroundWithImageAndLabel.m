//
//  OMBEmptyBackgroundWithImageAndLabel.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 1/31/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBEmptyBackgroundWithImageAndLabel.h"

#import "NSString+Extensions.h"
#import "OMBViewController.h"
#import "UIColor+Extensions.h"
#import "UIFont+OnMyBlock.h"
#import "UIImage+Color.h"

@implementation OMBEmptyBackgroundWithImageAndLabel

#pragma mark - Initializer

- (id) initWithFrame: (CGRect) rect
{
  if (!(self = [super initWithFrame: rect])) return nil;

  CGFloat imageSize = self.frame.size.width * 0.3f;
  _imageView = [UIImageView new];
  _imageView.alpha = 0.2f;
  _imageView.frame = CGRectMake((self.frame.size.width - imageSize) * 0.5f, 
    (self.frame.size.height * 0.5f) - imageSize, imageSize, imageSize);
  [self addSubview: _imageView];
  
  CGFloat labelOriginY = self.frame.size.height * 0.5f + OMBPadding;
  CGFloat labelWidth = self.frame.size.width - (OMBPadding * 2);
  _label = [UILabel new];
  _label.font = [UIFont mediumTextFont];
  _label.frame = CGRectMake((self.frame.size.width - labelWidth) * 0.5f, labelOriginY,
      labelWidth, self.frame.size.height - (labelOriginY));
  _label.numberOfLines = 0;
  _label.textColor = [UIColor grayMedium];
  [self addSubview: _label];

  _startButton = [UIButton new];
  _startButton.backgroundColor = [UIColor blue];
  _startButton.clipsToBounds = YES;
  _startButton.layer.cornerRadius = OMBCornerRadius;
  _startButton.titleLabel.font = [UIFont mediumTextFontBold];
  _startButton.titleLabel.textColor = UIColor.blue;
  [_startButton setBackgroundImage:
    [UIImage imageWithColor: [UIColor blueHighlighted]]
      forState: UIControlStateHighlighted];
  [_startButton setTitleColor: [UIColor whiteColor]
    forState: UIControlStateNormal];
  
  return self;
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) setButtonText:(NSString *)string
{
  [_startButton removeFromSuperview];
  
  CGFloat originY = 20.f + OMBStandardHeight;
  _imageView.frame = CGRectMake(_imageView.frame.origin.x, originY + OMBPadding,
    _imageView.frame.size.width, _imageView.frame.size.height);
  
  _label.frame = CGRectMake(_label.frame.origin.x,
    _imageView.frame.origin.y + _imageView.frame.size.height + OMBPadding,
      _label.frame.size.width, _label.frame.size.height);
  
  _startButton.frame = CGRectMake(OMBPadding,
    _label.frame.origin.y +  _label.frame.size.height + 2 * OMBPadding,
      self.frame.size.width - 2 * OMBPadding, OMBStandardButtonHeight);
  [_startButton setTitle:string forState: UIControlStateNormal];
  
  [self addSubview: _startButton];
}

- (void) setLabelText: (NSString *) string
{
  _label.attributedText = [string attributedStringWithFont: 
    [UIFont fontWithSize: 16 bold: YES] lineHeight: 26.0f];
  _label.textAlignment = NSTextAlignmentCenter;
  [_label sizeToFit];
}

@end
