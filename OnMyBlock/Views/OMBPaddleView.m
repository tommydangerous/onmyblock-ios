//
//  OMBPaddleView.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 11/22/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBPaddleView.h"

#import "UIColor+Extensions.h"

@implementation OMBPaddleView

@synthesize paddleView = _paddleView;

#pragma mark - Initializer

- (id) initWithFrame: (CGRect) rect
{
  if (!(self = [super initWithFrame: rect])) return nil;

  _paddleView = [[UIView alloc] initWithFrame: self.frame];
  [self addSubview: _paddleView];

  UIImageView *imageView = [[UIImageView alloc] init];
  imageView.frame = self.frame;
  imageView.image = [UIImage imageNamed: @"paddle_image.png"];
  [_paddleView addSubview: imageView];

  UIView *handle = [[UIView alloc] init];
  handle.backgroundColor = [UIColor brownColor];
  float handleHeight = self.frame.size.height * 0.3;
  float handleWidth  = self.frame.size.width * 0.05;
  handle.frame = CGRectMake(
    ((self.frame.size.width - handleWidth) / 2.0), 
      (self.frame.size.height - handleHeight),
        handleWidth, handleHeight);
  // [_paddleView addSubview: handle];

  UIView *pad = [[UIView alloc] init];
  pad.backgroundColor = [UIColor whiteColor];
  pad.clipsToBounds = YES;
  float padHeight = self.frame.size.height - handleHeight;
  float padWidth  = padHeight;
  pad.frame = CGRectMake(
    ((self.frame.size.width - padWidth) / 2.0), 1,
      padWidth, padHeight);
  pad.layer.borderColor = [UIColor textColor].CGColor;
  pad.layer.borderWidth = 1.0;
  pad.layer.cornerRadius = 10;
  // [_paddleView addSubview: pad];

  UILabel *dollarSign = [[UILabel alloc] init];
  float dollarSignHeight = pad.frame.size.height * 0.5;
  float dollarSignWidth  = dollarSignHeight;
  dollarSign.font = [UIFont fontWithName: @"HelveticaNeue-Light"
    size: dollarSignHeight];
  dollarSign.frame = CGRectMake(
    ((padWidth - dollarSignWidth) * 0.5), 
      ((padHeight - dollarSignHeight) * 0.5), 
        dollarSignWidth, dollarSignHeight);
  dollarSign.text = @"$";
  dollarSign.textAlignment = NSTextAlignmentCenter;
  dollarSign.textColor = [UIColor colorWithRed: (6/255.0) green: (92/255.0)
    blue: (39/255.0) alpha: 1];
  // [pad addSubview: dollarSign];

  return self;
}

@end
