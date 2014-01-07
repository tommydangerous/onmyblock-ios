//
//  OMBIntroBidView.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 11/25/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBIntroBidView.h"

#import "OMBPaddleView.h"
#import "UIColor+Extensions.h"

#define DEGREES_TO_RADIANS(x) (M_PI * x / 180.0)

@implementation OMBIntroBidView

@synthesize bottomView = _bottomView;
@synthesize paddleView1 = _paddleView1;
@synthesize paddleView2 = _paddleView2;
@synthesize paddleView3 = _paddleView3;

- (id) init
{
  if (!(self = [super init])) return nil;

  CGRect screen = [[UIScreen mainScreen] bounds];
  float screenHeight = screen.size.height;
  float screenWidth  = screen.size.width;
  float bottomLine   = screenHeight - (screenHeight * 0.35);

  self.clipsToBounds = YES;
  self.frame = screen;

  float d1 = screenWidth * 0.5;
  float d2 = screenWidth * 0.7;

  _paddleView2 = [[OMBPaddleView alloc] initWithFrame: 
    CGRectMake(0, 0, d2, d2)];
  _paddleView2.frame = CGRectMake(((screenWidth - d2) * 0.5), bottomLine, 
    d2, d2);
  [self addSubview: _paddleView2];

  _paddleView1 = [[OMBPaddleView alloc] initWithFrame: 
    CGRectMake(0, 0, d1, d1)];
  _paddleView1.frame = CGRectMake(10, bottomLine, d1, d1);
  _paddleView1.paddleView.transform = 
    CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(-15));
  [self addSubview: _paddleView1];

  _paddleView3 = [[OMBPaddleView alloc] initWithFrame: 
    CGRectMake(0, 0, d1, d1)];
  _paddleView3.frame = CGRectMake((screenWidth - (d1 + 10)), 
    _paddleView1.frame.origin.y, d1, d1);
  _paddleView3.paddleView.transform = 
    CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(15));
  [self addSubview: _paddleView3];

  _bottomView = [[UIView alloc] init];
  _bottomView.backgroundColor = [UIColor backgroundColor];
  _bottomView.frame = CGRectMake(0, bottomLine, screenWidth, 
    (screenHeight * 0.35));
  [self addSubview: _bottomView];

  UILabel *label1 = [[UILabel alloc] init];
  label1.font = [UIFont fontWithName: @"HelveticaNeue-Medium" size: 22];
  label1.frame = CGRectMake(0, (screenHeight - (33 * 4)),
    screenWidth, 33);
  label1.text = @"Bid on your";
  label1.textAlignment = NSTextAlignmentCenter;
  label1.textColor = [UIColor textColor];
  [self addSubview: label1];

  UILabel *label2 = [[UILabel alloc] init];
  label2.font = label1.font;
  label2.frame = CGRectMake(label1.frame.origin.x,
    (label1.frame.origin.y + label1.frame.size.height),
      label1.frame.size.width, label1.frame.size.height);
  label2.text = @"favorite places";
  label2.textAlignment = label1.textAlignment;
  label2.textColor = label1.textColor;
  [self addSubview: label2];

  return self;
}

@end
