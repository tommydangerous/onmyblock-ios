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

  CGFloat imageSize = self.frame.size.width * 0.3f;
  _imageView = [UIImageView new];
  _imageView.alpha = 0.2f;
  _imageView.frame = CGRectMake((self.frame.size.width - imageSize) * 0.5f, 
    (self.frame.size.height * 0.5f) - imageSize, imageSize, imageSize);
  [self addSubview: _imageView];
  
  CGFloat labelOriginY = self.frame.size.height * 0.5f + OMBPadding;
  CGFloat labelWidth = self.frame.size.width - (OMBPadding * 2);
  _label = [UILabel new];
  _label.frame =
    CGRectMake((self.frame.size.width - labelWidth) * 0.5f, labelOriginY,
      labelWidth, self.frame.size.height - (labelOriginY));
  _label.numberOfLines = 0;
  _label.textColor = [UIColor grayMedium];
  [self addSubview: _label];

  _startButton = [UIButton new];
  _startButton.backgroundColor = [UIColor clearColor];
  _startButton.titleLabel.font = [UIFont fontWithName: @"HelveticaNeue" size: 16];
  _startButton.titleLabel.textColor = UIColor.blue;
  [_startButton setTitleColor:
   [UIColor colorWithRed:0.2f green:0.7f blue:1.0f alpha:1.0f]
     forState:UIControlStateNormal];
  [_startButton setTitleColor:
    [UIColor colorWithRed:0.1f green:0.4f blue:0.8f alpha:1.0f]
       forState:UIControlStateHighlighted];
  
  return self;
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) setButtonText:(NSString *)string
{
  [_startButton removeFromSuperview];
  
  CGRect startRect = [string boundingRectWithSize:
    CGSizeMake(self.frame.size.width, 40.0f)
      options: NSStringDrawingUsesLineFragmentOrigin
        attributes: @{ NSFontAttributeName:
          [UIFont fontWithName: @"HelveticaNeue" size: 16] }
            context: nil];
  
  CGFloat startWidth = startRect.size.width + 20;
  CGFloat startHeight = startRect.size.height + 10;
  
  _startButton.frame = CGRectMake((self.frame.size.width - startWidth) * 0.5f,
    _label.frame.origin.y +
      _label.frame.size.height + OMBPadding,
        startWidth, startHeight);
  [_startButton setTitle:string forState:UIControlStateNormal];
  
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
