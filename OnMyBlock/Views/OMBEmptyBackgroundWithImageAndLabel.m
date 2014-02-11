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

@implementation OMBEmptyBackgroundWithImageAndLabel

#pragma mark - Initializer

- (id) initWithFrame: (CGRect) rect
{
  if (!(self = [super initWithFrame: rect])) return nil;

  CGFloat imageSize = self.frame.size.width * 0.8f;
  _imageView = [UIImageView new];
  _imageView.alpha = 0.1f;
  _imageView.frame = CGRectMake((self.frame.size.width - imageSize) * 0.5f, 
    (self.frame.size.height - imageSize) * 0.5f, imageSize, imageSize);
  [self addSubview: _imageView];

  _label = [UILabel new];
  _label.frame = CGRectMake(OMBPadding, 0.0f, 
    self.frame.size.width - (OMBPadding * 2), self.frame.size.height);
  _label.numberOfLines = 0;
  _label.textColor = [UIColor grayMedium];
  [self addSubview: _label];

  return self;
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) setLabelText: (NSString *) string
{
  _label.attributedText = [string attributedStringWithFont: 
    [UIFont mediumTextFontBold] lineHeight: 27.0f];
  _label.textAlignment = NSTextAlignmentCenter;
}

@end
