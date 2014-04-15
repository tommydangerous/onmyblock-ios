//
//  OMBTableParallaxViewController.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 4/15/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBTableParallaxViewController.h"

@interface OMBTableParallaxViewController ()
{
  UIView *backgroundView;
  CGFloat backgroundViewOriginY;
  CGFloat scaleFactor;
  CGFloat scrollFactor;
  UIView *scaleBackgroundView;
  UIView *tableHeaderView;
}

@end

@implementation OMBTableParallaxViewController

#pragma mark - Initializer

- (id) init
{
  if (!(self = [super init])) return nil;

  _parallaxEnabled = YES;
  _scalingEnabled  = YES;

  scaleFactor  = 3.5f;
  scrollFactor = 3.5f;

  return self;
}

#pragma mark - Override

#pragma mark - Override UIViewController

- (void) loadView
{
  [super loadView];

  // Table view
  [self setupForTable];
  self.table.backgroundColor = [UIColor clearColor];

  // Background view
  backgroundView = [UIView new];
  [self.view insertSubview: backgroundView belowSubview: self.table];
  // Scale background view
  scaleBackgroundView = [UIView new];
  [backgroundView addSubview: scaleBackgroundView];

  tableHeaderView = [UIView new];
  tableHeaderView.backgroundColor = [UIColor clearColor];
}

#pragma mark - Protocol

#pragma mark - Protocol UIScrollViewDelegate

- (void) scrollViewDidScroll: (UIScrollView *) scrollView
{
  CGFloat offsetY    = scrollView.contentOffset.y;
  CGFloat adjustment = offsetY / scrollFactor;
  // If the table view is scrolling
  if (scrollView == self.table) {
    if (_parallaxEnabled) {
      // Move up
      CGRect backgroundViewRect = backgroundView.frame;
      CGFloat newOffsetY        = backgroundViewOriginY - adjustment;
      if (newOffsetY > backgroundViewOriginY)
        newOffsetY = backgroundViewOriginY;
      backgroundViewRect.origin.y = newOffsetY;
      backgroundView.frame        = backgroundViewRect;
    }
    if (_scalingEnabled) {
      // Scale
      CGFloat scale = 1 + ((offsetY * scaleFactor * -1) /
        scaleBackgroundView.frame.size.height);
      if (scale < 1)
        scale = 1.0f;
      scaleBackgroundView.transform = CGAffineTransformScale(
        CGAffineTransformIdentity, scale, scale);
    }
  }
}

#pragma mark - Methods

#pragma mark - Instance Methods

// Use this method to setup everything
- (void) setupBackgroundWithView: (UIView *) view
startingOffsetY: (NSUInteger) offsetY
{
  backgroundViewOriginY = offsetY;
  // Background view
  backgroundView.frame = CGRectMake(0.0f, backgroundViewOriginY,
    view.bounds.size.width, view.bounds.size.height);
  // Scale background view
  scaleBackgroundView.frame = backgroundView.bounds;
  [scaleBackgroundView addSubview: view];
  // Table header view
  tableHeaderView.frame = CGRectMake(0.0f, 0.0f, view.bounds.size.width,
    backgroundViewOriginY + backgroundView.bounds.size.height);
  self.table.tableHeaderView = tableHeaderView;
}

@end
