//
//  OMBActivityView.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/16/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBActivityView.h"

@implementation OMBActivityView

#pragma mark - Initializer

- (id) init
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
  [UIView animateWithDuration: 0.1 animations: ^{
    self.alpha = 1.0f;
  }];
}

- (void) stopSpinning
{
  [UIView animateWithDuration: 0.1 animations: ^{
    self.alpha = 0.0f;
  }];
}

@end
