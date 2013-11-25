//
//  OMBIntroViewController.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 11/7/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBIntroViewController.h"

#import "AMBlurView.h"
#import "OMBAppDelegate.h"
#import "OMBHouseGraphicView.h"
#import "OMBIntroAuctionView.h"
#import "OMBIntroBidView.h"
#import "OMBIntroDiscoverView.h"
#import "OMBIntroFavoritesView.h"
#import "OMBLoginViewController.h"
#import "OMBNavigationController.h"
#import "OMBPaddleView.h"
#import "OMBSignUpView.h"
#import "OMBStopwatchView.h"
#import "OMBWelcomeView.h"
#import "TextFieldPadding.h"
#import "UIColor+Extensions.h"
#import "UIImage+Color.h"

#define DEGREES_TO_RADIANS(x) (M_PI * x / 180.0)

@implementation OMBIntroViewController

#pragma mark - Initializer

- (id) init
{
  if (!(self = [super init])) return nil;

  self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
  _loginViewController =
    [[OMBNavigationController alloc] initWithRootViewController:
      [[OMBLoginViewController alloc] init]];

  return self;
}

#pragma mark - Override

#pragma mark - Override UIViewController

- (void) loadView
{
  [super loadView];

  CGRect screen = [[UIScreen mainScreen] bounds];

  self.view = [[UIView alloc] initWithFrame: screen];

  _scroll               = [[UIScrollView alloc] init];
  _scroll.bounces       = YES;
  _scroll.contentSize   = CGSizeMake((screen.size.width * 6), 
    screen.size.height);
  _scroll.delegate      = self;
  _scroll.frame         = screen;
  _scroll.pagingEnabled = YES;
  _scroll.showsHorizontalScrollIndicator = NO;
  [self.view addSubview: _scroll];

  _welcomeView = [[OMBWelcomeView alloc] init];
  _welcomeView.frame = CGRectMake(0, 0, screen.size.width, screen.size.height);

  // 2. Discover
  _introDiscoverView = [[OMBIntroDiscoverView alloc] init];
  _introDiscoverView.frame = CGRectMake((screen.size.width * 1), 0, 
    _welcomeView.frame.size.width, _welcomeView.frame.size.height);
  [_scroll addSubview: _introDiscoverView];

  // 1. Welcome
  [_scroll addSubview: _welcomeView];

  // 3. Bid
  _introBidView = [[OMBIntroBidView alloc] init];
  _introBidView.frame = CGRectMake((screen.size.width * 2), 0, 
    _welcomeView.frame.size.width, _welcomeView.frame.size.height);
  [_scroll addSubview: _introBidView];

  _introAuctionView = [[OMBIntroAuctionView alloc] init];
  _introAuctionView.frame = CGRectMake((screen.size.width * 3), 0,
    _welcomeView.frame.size.width, _welcomeView.frame.size.height);
  [_scroll addSubview: _introAuctionView];

  _introFavoritesView = [[OMBIntroFavoritesView alloc] init];
  _introFavoritesView.frame = CGRectMake((screen.size.width * 4), 0,
    _welcomeView.frame.size.width, _welcomeView.frame.size.height);
  [_scroll addSubview: _introFavoritesView];

  _signUpView = [[OMBSignUpView alloc] init];
  _signUpView.frame = CGRectMake((screen.size.width * 5), 0,
    _welcomeView.frame.size.width, _welcomeView.frame.size.height);
  [_scroll addSubview: _signUpView];

  _pageControl = [[UIPageControl alloc] init];
  _pageControl.frame = CGRectMake(0, 
    (screen.size.height - (20 + 40)), 
      screen.size.width, 40);
  _pageControl.currentPageIndicatorTintColor = [UIColor blue];
  _pageControl.numberOfPages = 6;
  _pageControl.pageIndicatorTintColor = [UIColor grayLight];
  [_pageControl addTarget: self action: @selector(scrollToCurrentPage:)
    forControlEvents: UIControlEventValueChanged];
  [self.view addSubview: _pageControl];

  // Close view
  closeButtonView = [[UIView alloc] init];
  float closeButtonViewHeight = 25;
  float closeButtonViewWidth  = closeButtonViewHeight;
  closeButtonView.frame = CGRectMake(
    (screen.size.width - (closeButtonViewWidth + 5)), (20 + 5), 
      closeButtonViewWidth, closeButtonViewHeight);
  [self.view addSubview: closeButtonView];
  UIView *forwardSlash = [[UIView alloc] init];
  forwardSlash.backgroundColor = [UIColor grayMedium];
  forwardSlash.frame = CGRectMake(
    ((closeButtonView.frame.size.width - 1) * 0.5), 0, 
      1, closeButtonView.frame.size.height);
  [closeButtonView addSubview: forwardSlash];
  UIView *backSlash = [[UIView alloc] init];
  backSlash.backgroundColor = forwardSlash.backgroundColor;
  backSlash.frame = forwardSlash.frame;
  [closeButtonView addSubview: backSlash];
  forwardSlash.transform = 
    CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(-45));
  backSlash.transform = 
    CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(45));
  UIButton *closeButton = [[UIButton alloc] init];
  closeButton.backgroundColor = [UIColor clearColor];
  closeButton.frame = CGRectMake(0, 0, closeButtonView.frame.size.width,
    closeButtonView.frame.size.height);
  [closeButton addTarget: self action: @selector(close)
    forControlEvents: UIControlEventTouchUpInside];
  [closeButtonView addSubview: closeButton];

  // Buttons
  float buttonHeight = 40;
  float buttonWidth  = screen.size.width * 0.5;
  // Login button
  loginButton = [[UIButton alloc] init];
  loginButton.frame = CGRectMake(0, (screen.size.height - buttonHeight),
    buttonWidth, buttonHeight);
  loginButton.titleLabel.font = [UIFont fontWithName: @"HelveticaNeue-Light" 
    size: 18];
  [loginButton setTitle: @"Login" forState: UIControlStateNormal];
  [loginButton setTitleColor: [UIColor blue] forState: UIControlStateNormal];
  [loginButton setTitleColor: [UIColor blueDark] 
    forState: UIControlStateHighlighted];
  // [self.view addSubview: loginButton];

  // House
  houseGraphicView = [[UIImageView alloc] initWithFrame:
    CGRectMake(0, 0, (screen.size.width * 0.5), (screen.size.width * 0.5))];
  [_scroll addSubview: houseGraphicView];
  houseGraphicView.frame = CGRectMake(
    ((screen.size.width - houseGraphicView.frame.size.width) * 0.5),
      ((screen.size.height - houseGraphicView.frame.size.height) * 0.5), 
        houseGraphicView.frame.size.width, houseGraphicView.frame.size.height);
  houseGraphicView.image = [UIImage imageNamed: @"house_image.png"];
}

#pragma mark - Protocol

#pragma mark - Protocol UIScrollViewDelegate

- (void) scrollViewDidEndDecelerating: (UIScrollView *) scrollView
{
  // Change the pages on the page control
  float currentPage = scrollView.contentOffset.x / scrollView.frame.size.width;
  _pageControl.currentPage = currentPage;
}

- (void) scrollViewDidEndDragging: (UIScrollView *) scrollView 
willDecelerate: (BOOL)decelerate
{
  [_signUpView resetViewOrigins];
}

- (void) scrollViewDidScroll: (UIScrollView *) scrollView
{
  // Resign first responder for all text fields for sign up view
  [_signUpView endEditing: YES];

  CGRect screen = [[UIScreen mainScreen] bounds];
  float screenHeight = screen.size.height;
  float screenWidth  = screen.size.width;
  
  float percent = 0.0;
  float width   = scrollView.frame.size.width;
  float x       = scrollView.contentOffset.x;
  float page    = x / width;
  // 1 - 2 pages
  if (page <= 1) {
    percent = (x - (width * 0)) / width;

    // Turn the hands on the stop watch
    _welcomeView.stopwatchView.minuteHand.transform =
      CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(360 * percent * 12.0));
    _welcomeView.stopwatchView.hourHand.transform = 
      CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(360 * percent));

    // Animate the paddle view
    float paddleHeight = _welcomeView.paddleView.frame.size.height;
    float paddleWidth  = _welcomeView.paddleView.frame.size.width;
    _welcomeView.paddleView.frame = CGRectMake(
      (screenWidth - paddleWidth) - (percent * paddleWidth), 
        ((screenHeight - paddleHeight) * 0.25) + (percent * paddleHeight),
          paddleWidth, paddleHeight);

    // Move and resize house
    float houseWidth = (screen.size.width * 0.5) - 
      (((screen.size.width * 0.5) * 0.4) * percent);
    float houseOriginX = 
      (((screen.size.width - houseWidth) * 0.5) + x);
    float houseOriginY = ((screen.size.height - houseWidth) * 0.5);
    houseGraphicView.frame = CGRectMake(houseOriginX, houseOriginY, 
      houseWidth, houseWidth);

    // Discover view
    // Marker 1
    _introDiscoverView.marker1.frame = CGRectMake(
      _introDiscoverView.marker1.frame.origin.x, 
        ((screenHeight * 0.5) * percent),
          _introDiscoverView.marker1.frame.size.width, 
            _introDiscoverView.marker1.frame.size.height);
    // Marker 2
    if (percent <= 1) {
      float newPercent = (percent - 0.75) * 4.5;
      if (newPercent > 1)
        newPercent = 1;
      _introDiscoverView.marker2.frame = CGRectMake(
        _introDiscoverView.marker2.frame.origin.x, 
          (screenHeight * 0.5) * newPercent,
            _introDiscoverView.marker2.frame.size.width, 
              _introDiscoverView.marker2.frame.size.height);
    }
    // Marker 3
    if (percent <= 1) {
      float newPercent = (percent - 0.4) * 2;
      if (newPercent > 1)
        newPercent = 1;
      _introDiscoverView.marker3.frame = CGRectMake(
        _introDiscoverView.marker3.frame.origin.x, 
          ((screenHeight * 0.1) * newPercent),
            _introDiscoverView.marker3.frame.size.width, 
              _introDiscoverView.marker3.frame.size.height);
    }
  }
  // 2 - 3 pages
  if (page <= 2 && page > 1) {
    percent = (x - (width * 1)) / width;

    // Discover view
    // Marker 1
    _introDiscoverView.marker1.frame = CGRectMake(
      _introDiscoverView.marker1.frame.origin.x, 
        ((screenHeight * 0.5) * (1 - percent)),
          _introDiscoverView.marker1.frame.size.width, 
            _introDiscoverView.marker1.frame.size.height);
    // Marker 2
    if (percent <= 1) {
      float newPercent = percent * 4.5;
      _introDiscoverView.marker2.frame = CGRectMake(
        _introDiscoverView.marker2.frame.origin.x, 
          (screenHeight * 0.5) * (1 - newPercent),
            _introDiscoverView.marker2.frame.size.width, 
              _introDiscoverView.marker2.frame.size.height);
    }
    // Marker 3
    if (percent <= 1) {
      float newPercent = percent * 2;
      _introDiscoverView.marker3.frame = CGRectMake(
        _introDiscoverView.marker3.frame.origin.x, 
          ((screenHeight * 0.1) * (1 - newPercent)),
            _introDiscoverView.marker3.frame.size.width, 
              _introDiscoverView.marker3.frame.size.height);
    }

    // Bid view
    float bottomLine = _introBidView.bottomView.frame.origin.y;
    // Paddle 1
    _introBidView.paddleView1.frame = CGRectMake(
      _introBidView.paddleView1.frame.origin.x, 
        (bottomLine - 
        ((_introBidView.paddleView1.frame.size.height - 0) * percent)), 
          _introBidView.paddleView1.frame.size.width,
            _introBidView.paddleView1.frame.size.height);
    // Paddle 2
    if (percent <= 1) {
      float newPercent = (percent - 0.4) * 2;
      if (newPercent > 1)
        newPercent = 1;
      _introBidView.paddleView2.frame = CGRectMake(
        _introBidView.paddleView2.frame.origin.x, 
          (bottomLine - 
          ((_introBidView.paddleView2.frame.size.height + 
          (screenHeight * 0.05)) * newPercent)), 
            _introBidView.paddleView2.frame.size.width,
              _introBidView.paddleView2.frame.size.height);
    }
    // Paddle 3
    if (percent <= 1) {
      float newPercent = (percent - 0.7) * 4;
      if (newPercent > 1)
        newPercent = 1;
      _introBidView.paddleView3.frame = CGRectMake(
        _introBidView.paddleView3.frame.origin.x, 
          (bottomLine - 
          ((_introBidView.paddleView3.frame.size.height - 0) * newPercent)), 
            _introBidView.paddleView3.frame.size.width,
              _introBidView.paddleView3.frame.size.height);
    }
  }
  // 3 - 4
  if (page <= 3 && page > 2) {
    percent = (x - (width * 2)) / width;

    // Bid view
    float bottomLine = _introBidView.bottomView.frame.origin.y;
    // Paddle 1
    _introBidView.paddleView1.frame = CGRectMake(
      _introBidView.paddleView1.frame.origin.x, 
        (bottomLine - 
        ((_introBidView.paddleView1.frame.size.height - 0) * (1 - percent))), 
          _introBidView.paddleView1.frame.size.width,
            _introBidView.paddleView1.frame.size.height);
    // Paddle 2
    if (percent <= 1) {
      float newPercent = percent * 2;
      _introBidView.paddleView2.frame = CGRectMake(
        _introBidView.paddleView2.frame.origin.x, 
          (bottomLine - 
          ((_introBidView.paddleView2.frame.size.height + 
          (screenHeight * 0.05)) * (1 - newPercent))), 
            _introBidView.paddleView2.frame.size.width,
              _introBidView.paddleView2.frame.size.height);
    }
    // Paddle 3
    if (percent <= 1) {
      float newPercent = percent * 4;
      _introBidView.paddleView3.frame = CGRectMake(
        _introBidView.paddleView3.frame.origin.x, 
          (bottomLine - 
          ((_introBidView.paddleView3.frame.size.height - 0) * 
          (1 - newPercent))), 
            _introBidView.paddleView3.frame.size.width,
              _introBidView.paddleView3.frame.size.height);
    }

    // Auction view
    if (percent > 0.9) {
      _introAuctionView.iphoneScreen.alpha = 1;
    }
    else {
      _introAuctionView.iphoneScreen.alpha = 0;
    }
  }
  NSLog(@"Page: %f, Percent: %f, X: %f", page, percent, x);
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) close
{
  NSLog(@"CLOSE!");
}

- (void) scrollToCurrentPage: (UIPageControl *) control
{
  CGRect screen = [[UIScreen mainScreen] bounds];
  [_scroll setContentOffset: 
    CGPointMake((control.currentPage * screen.size.width), 0) animated: YES];
}

- (void) showLogin
{
  [(OMBLoginViewController *) _loginViewController.topViewController showLogin];
  [self showLoginViewController];
}

- (void) showLoginViewController
{
  [self presentViewController: _loginViewController 
    animated: YES completion: nil];
}

- (void) showSignUpOrSignUp
{
  float x = _scroll.contentOffset.x;
  if (x < _signUpView.frame.origin.x) {
    [_scroll setContentOffset: CGPointMake(_signUpView.frame.origin.x,
      _scroll.contentOffset.y) animated: YES];
  }
  else
    [_signUpView signUp];
}

@end
