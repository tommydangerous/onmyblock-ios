//
//  OMBActivityView.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/16/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBActivityView.h"
#import "OMBCurvedLineView.h"

#define DEGREES_TO_RADIANS(x) (M_PI * x / 180.0)

@implementation OMBActivityView

#pragma mark - Initializer

- (id) init
{
  return [self initWithColor: nil];
}

- (id) initWithColor: (UIColor *) color
{
  if (!(self = [super init])) return nil;

  CGRect screen = [[UIScreen mainScreen] bounds];
  CGFloat screenHeight = screen.size.height; 
  CGFloat screenWidth  = screen.size.width;

  if (!color)
    color = [UIColor whiteColor];

  self.alpha = 0.0f;
  self.backgroundColor = [UIColor clearColor];
  self.frame = screen;
  // Allow users to click through
  self.userInteractionEnabled = NO;

  CGFloat spinnerViewSize = screenWidth * 0.3f;
  _spinnerView = [UIView new];
  _spinnerView.frame = CGRectMake((screenWidth - spinnerViewSize) * 0.5f,
    (screenHeight - spinnerViewSize) * 0.5f, spinnerViewSize, spinnerViewSize);
  _spinnerView.backgroundColor = [UIColor colorWithWhite: 0.0f alpha: 0.5f];
  _spinnerView.layer.cornerRadius = 5.0f;
  [self addSubview: _spinnerView];

  _spinner = [UIView new];
  _spinner.frame = self.frame;
  [self addSubview: _spinner];

  CGFloat circleSize = _spinner.frame.size.width * 0.05f;
  circle = [UIView new];
  circle.frame = CGRectMake((_spinner.frame.size.width - circleSize) * 0.5f,
    (_spinner.frame.size.height - circleSize) * 0.5f, circleSize, circleSize);
  circle.layer.borderColor = color.CGColor;
  circle.layer.borderWidth = 1.0f;
  circle.layer.cornerRadius = circle.frame.size.width * 0.5f;
  [_spinner addSubview: circle];

  line = [[OMBCurvedLineView alloc] initWithFrame: _spinner.frame color: color];
  [_spinner addSubview: line];

  return self;
}

- (id) initWithAppleSpinner
{
  if (!(self = [super init])) return nil;

  CGRect screen = [[UIScreen mainScreen] bounds];

  CGFloat activityViewSize = 100.0f;
  self.alpha = 0.0f;
  self.backgroundColor = [UIColor colorWithWhite: 0.0f alpha: 0.5f];
  self.frame = CGRectMake((screen.size.width - activityViewSize) * 0.5,
    (screen.size.height - activityViewSize) * 0.5, 
      activityViewSize, activityViewSize);
  self.layer.cornerRadius = 5.0f;

  activityIndicatorView = 
    [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:
      UIActivityIndicatorViewStyleWhiteLarge];
  activityIndicatorView.color = [UIColor whiteColor];
  activityIndicatorView.frame = CGRectMake(
    (activityViewSize - activityIndicatorView.frame.size.width) * 0.5,
      (activityViewSize - activityIndicatorView.frame.size.height) * 0.5,
        activityIndicatorView.frame.size.width,
          activityIndicatorView.frame.size.height);
  [self addSubview: activityIndicatorView];

  [activityIndicatorView startAnimating];

  return self;
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) startSpinning
{
  _isSpinning = YES;
  [UIView animateWithDuration: 0.1 animations: ^{
    self.alpha = 1.0f;
  } completion: ^(BOOL finished) {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:
      @"transform.rotation"];
    animation.duration  = 0.8f;
    animation.toValue = [NSNumber numberWithFloat: DEGREES_TO_RADIANS(-360.0)];
    animation.repeatCount  = HUGE_VALF;
    [[_spinner layer] addAnimation: animation 
      forKey: @"transformRotationAnimation"];

    CABasicAnimation *scale = [CABasicAnimation animationWithKeyPath:
      @"transform.scale"];
    scale.autoreverses = YES;
    scale.duration = 0.8f;
    scale.fromValue = [NSNumber numberWithFloat: 1.0f];
    scale.toValue = [NSNumber numberWithFloat: 1.1f];
    scale.repeatCount = HUGE_VALF;
    [[circle layer] addAnimation: scale forKey: @"transformScaleAnimation"];
  }];
}

- (void) stopSpinning
{
  _isSpinning = NO;
  [UIView animateWithDuration: 0.1 animations: ^{
    self.alpha = 0.0f;
  } completion: ^(BOOL finished) {
    [[_spinner layer] removeAnimationForKey: @"transformRotationAnimation"];
    [[circle layer] removeAnimationForKey: @"transformScaleAnimation"];
  }];
}

@end
