//
//  OMBActivityViewFullScreen.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 2/15/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBActivityViewFullScreen.h"

#import "OMBActivityView.h"
#import "OMBViewController.h"

@implementation OMBActivityViewFullScreen

#pragma mark - Initializer

- (id) init
{
  if (!(self = [super init])) return nil;

  CGRect screen = [[UIScreen mainScreen] bounds];

  self.alpha = 0.0f;
  self.backgroundColor = [UIColor colorWithWhite: 0.0f alpha: 0.5f];
  self.frame = screen;

  activityView = [[OMBActivityView alloc] init];
  activityView.spinnerView.backgroundColor = [UIColor clearColor];
  [self addSubview: activityView];

  return self;
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) startSpinning
{
  [activityView startSpinning];
  [UIView animateWithDuration: OMBStandardDuration animations: ^{
    self.alpha = 1.0f;
  }];
}

- (void) stopSpinning
{
  [UIView animateWithDuration: OMBStandardDuration animations: ^{
    self.alpha = 0.0f;
  } completion: ^(BOOL finished) {
    [activityView stopSpinning];
  }];
}

@end
