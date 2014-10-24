//
//  OMBTableParallaxViewController.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 4/15/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBTableParallaxViewController.h"

// Categories
#import "UIColor+Extensions.h"
// Views
#import "OMBBlurView.h"
#import "OMBCenteredImageView.h"

@interface OMBTableParallaxViewController ()
{
  UIView *backgroundView;
  CGFloat backgroundViewOriginY;
  UIView *displayView;
  CGFloat displayViewOriginalHeight;
  UIView *scaleBackgroundView;
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
  CGFloat padding = OMBPadding;
  self.table.backgroundColor = [UIColor clearColor];
  self.table.separatorColor  = [UIColor grayMediumAlpha: 0.5f];
  self.table.separatorInset  = UIEdgeInsetsMake(0.0f, padding, 0.0f, padding);

  // Background view
  backgroundView = [UIView new];
  [self.view insertSubview: backgroundView belowSubview: self.table];
  // Scale background view
  scaleBackgroundView = [UIView new];
  [backgroundView addSubview: scaleBackgroundView];

  tableHeaderView = [UIView new];
  tableHeaderView.backgroundColor = [UIColor clearColor];

  // Background image that is blurred
  backgroundBlurView = [[OMBBlurView alloc] initWithFrame: [self screen]];
  backgroundBlurView.blurRadius    = 20.0f;
  backgroundBlurView.clipsToBounds = YES;
  backgroundBlurView.tintColor     = [UIColor colorWithWhite: 1.0f alpha: 0.8f];
  [self.view insertSubview: backgroundBlurView atIndex: 0];
}

#pragma mark - Protocol

#pragma mark - Protocol UIScrollViewDelegate

- (void) scrollViewDidScroll: (UIScrollView *) scrollView
{
  CGFloat offsetY    = scrollView.contentOffset.y;
  CGFloat adjustment = offsetY / scrollFactor;
  // If the table view is scrolling
  if (scrollView == self.table) {
    // Move the background view up at a different speed
    if (_parallaxEnabled) {
        CGRect backgroundViewRect = backgroundView.frame;
        CGFloat newOffsetY        = backgroundViewOriginY - adjustment;
        if (newOffsetY > backgroundViewOriginY)
          newOffsetY = backgroundViewOriginY;
        backgroundViewRect.origin.y = newOffsetY;
        backgroundView.frame        = backgroundViewRect;
    }
    // Scale the background view when scrolling down
    if (_scalingEnabled) {
      CGFloat scale = 1 + ((offsetY * scaleFactor * -1) /
        scaleBackgroundView.frame.size.height);
      if (scale < 1)
        scale = 1.0f;
      scaleBackgroundView.transform = CGAffineTransformScale(
        CGAffineTransformIdentity, scale, scale);
    }
    // Change the height of the background image view
    if (displayView) {
      CGRect rect  = displayView.frame;
      CGFloat diff = displayViewOriginalHeight - (offsetY - adjustment);
      if (diff > displayViewOriginalHeight) {
        diff = displayViewOriginalHeight;
      }
      else if (diff < 0) {
        diff = 0;
      }
      rect.size.height = diff;

      if ([displayView respondsToSelector: @selector(setFrame:redrawImage:)]) {
        [(OMBCenteredImageView *) displayView setFrame: rect redrawImage: NO];
      }
      else {
        displayView.frame = rect;
      }
    }
  }
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) setupBackgroundWithView: (UIView *) view
startingOffsetY: (NSUInteger) offsetY
{
  // Use this method to setup everything

  displayView               = view;
  displayViewOriginalHeight = CGRectGetHeight(displayView.frame);
  backgroundViewOriginY     = offsetY;

  // Background view
  backgroundView.frame = CGRectMake(0.0f, backgroundViewOriginY,
    CGRectGetWidth(displayView.frame), displayViewOriginalHeight);

  // Scale background view
  scaleBackgroundView.frame = backgroundView.bounds;
  [scaleBackgroundView addSubview: displayView];

  // Table header view
  tableHeaderView.frame = CGRectMake(0.0f, 0.0f,
    CGRectGetWidth(displayView.frame),
      backgroundViewOriginY + CGRectGetHeight(backgroundView.bounds));
  self.table.tableHeaderView = tableHeaderView;
}

@end
