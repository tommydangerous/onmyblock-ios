//
//  OMBWelcomeView.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 11/7/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBWelcomeView.h"

#import "OMBPaddleView.h"
#import "OMBStopwatchView.h"
#import "UIColor+Extensions.h"

#define DEGREES_TO_RADIANS(x) (M_PI * x / 180.0)

@implementation OMBWelcomeView

@synthesize stopwatchView = _stopwatchView;

#pragma mark - Initializer

- (id) init
{
  if (!(self = [super init])) return nil;

  CGRect screen = [[UIScreen mainScreen] bounds];

  self.frame = screen;

  float d1 = screen.size.width * 0.6;
  float d2 = screen.size.width * 0.5;

  _stopwatchView = [[OMBStopwatchView alloc] initWithFrame:
    CGRectMake(0, 0, d1, d1)];
  _stopwatchView.frame = CGRectMake(0, 
    ((screen.size.height - _stopwatchView.frame.size.height) * 0.25),
      _stopwatchView.frame.size.width, _stopwatchView.frame.size.height);

  _paddleView = [[OMBPaddleView alloc] initWithFrame: 
    CGRectMake(0, 0, d2, d2)];
  _paddleView.frame = CGRectMake(
    (screen.size.width - (_paddleView.frame.size.width + 
    (screen.size.width * 0.00))),
      ((screen.size.height - _paddleView.frame.size.height) * 0.25),
        _paddleView.frame.size.width, _paddleView.frame.size.height);
  _paddleView.paddleView.transform = 
    CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(35));
  [self addSubview: _paddleView];

  [self addSubview: _stopwatchView];

  UILabel *label1 = [[UILabel alloc] init];
  label1.font = [UIFont fontWithName: @"HelveticaNeue-Medium" size: 22];
  label1.frame = CGRectMake(0, (screen.size.height - (33 * 4)),
    screen.size.width, 33);
  label1.text = @"The auction marketplace";
  label1.textAlignment = NSTextAlignmentCenter;
  label1.textColor = [UIColor textColor];
  [self addSubview: label1];

  UILabel *label2 = [[UILabel alloc] init];
  label2.font = label1.font;
  label2.frame = CGRectMake(label1.frame.origin.x,
    (label1.frame.origin.y + label1.frame.size.height),
      label1.frame.size.width, label1.frame.size.height);
  label2.text = @"for student housing";
  label2.textAlignment = label1.textAlignment;
  label2.textColor = label1.textColor;
  [self addSubview: label2];

  return self;
}

@end
