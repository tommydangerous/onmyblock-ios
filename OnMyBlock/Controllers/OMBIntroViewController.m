//
//  OMBIntroViewController.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 11/7/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBIntroViewController.h"

#import "AMBlurView.h"
#import "DDPageControl.h"
#import "OMBAppDelegate.h"
#import "OMBGetStartedView.h"
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

@synthesize activityIndicatorView = _activityIndicatorView;
@synthesize getStartedView        = _getStartedView;
@synthesize pageControl           = _pageControl;

#pragma mark - Initializer

- (id) init
{
  if (!(self = [super init])) return nil;

  return self;
}

#pragma mark - Override

#pragma mark - Override UIViewController

- (void) loadView
{
  [super loadView];

  CGRect screen = [[UIScreen mainScreen] bounds];

  self.view = [[UIView alloc] initWithFrame: screen];

  float screenHeight = screen.size.height;
  float screenWidth  = screen.size.width;
  
  // It needs it's own login view controller
  // because it cannot present the container's login view controller
  _loginViewController = [[OMBLoginViewController alloc] init];

  int numberOfPages = 6;

  _scroll               = [[UIScrollView alloc] init];
  _scroll.bounces       = YES;
  _scroll.contentSize   = CGSizeMake((screen.size.width * numberOfPages), 
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

  // 4. Auction
  _introAuctionView = [[OMBIntroAuctionView alloc] init];
  _introAuctionView.frame = CGRectMake((screen.size.width * 3), 0,
    _welcomeView.frame.size.width, _welcomeView.frame.size.height);
  [_scroll addSubview: _introAuctionView];

  // 5. Get started
  _getStartedView = [[OMBGetStartedView alloc] init];
  _getStartedView.frame = CGRectMake((screen.size.width * 4), 0,
    _welcomeView.frame.size.width, _welcomeView.frame.size.height);
  [_scroll addSubview: _getStartedView];

  // 6. Sign up
  _signUpView = [[OMBSignUpView alloc] init];
  _signUpView.frame = CGRectMake((screen.size.width * 5), 0,
    _welcomeView.frame.size.width, _welcomeView.frame.size.height);
  [_scroll addSubview: _signUpView];

  // Page control
  _pageControl = [[DDPageControl alloc] init];
  _pageControl.indicatorDiameter = 10.0f;
  _pageControl.indicatorSpace = 15.0f;
  _pageControl.numberOfPages = numberOfPages - 1;
  _pageControl.offColor = [UIColor blue];
  _pageControl.onColor = [UIColor blue];
  _pageControl.type = DDPageControlTypeOnFullOffEmpty;
  _pageControl.frame = CGRectMake(0.0f, (screenHeight - 60.0f), 
    screenWidth, 60.0f);
  [_pageControl addTarget: self action: @selector(scrollToCurrentPage:)
    forControlEvents: UIControlEventValueChanged];
  [_scroll addSubview: _pageControl];

  // Close view
  closeButtonView = [[UIView alloc] init];
  float closeButtonViewHeight = 25;
  float closeButtonViewWidth  = closeButtonViewHeight * 2;
  CGRect closeRect = [@"Skip" boundingRectWithSize:
    CGSizeMake(closeButtonViewWidth, closeButtonViewHeight)
      options: NSStringDrawingUsesLineFragmentOrigin
        attributes: @{ NSFontAttributeName: 
        [UIFont fontWithName: @"HelveticaNeue-Light" size: 15] } 
          context: nil];
  closeButtonViewHeight = closeRect.size.height + 10;
  closeButtonViewWidth  = closeRect.size.width + 20;
  closeButtonView.frame = CGRectMake(
    (screen.size.width - (closeButtonViewWidth + 10)), (20 + 10), 
      closeButtonViewWidth, closeButtonViewHeight);
  closeButtonView.layer.borderColor = [UIColor grayLight].CGColor;
  closeButtonView.layer.borderWidth = 1.0;
  closeButtonView.layer.cornerRadius = 5.0;
  [_scroll addSubview: closeButtonView];
  UIButton *closeButton = [[UIButton alloc] init];
  closeButton.frame = CGRectMake(0, 0, closeButtonView.frame.size.width,
    closeButtonView.frame.size.height);
  closeButton.titleLabel.font = [UIFont fontWithName: @"HelveticaNeue-Light"
    size: 15];
  [closeButton addTarget: self action: @selector(close)
    forControlEvents: UIControlEventTouchUpInside];
  [closeButton setTitle: @"Skip" forState: UIControlStateNormal];
  [closeButton setTitleColor: [UIColor grayMedium] 
    forState: UIControlStateNormal];
  [closeButton setTitleColor: [UIColor grayLight] 
    forState: UIControlStateHighlighted];
  [closeButtonView addSubview: closeButton];

  // House
  houseGraphicView = [[UIImageView alloc] initWithFrame:
    CGRectMake(0, 0, (screen.size.width * 0.5), (screen.size.width * 0.5))];
  [_scroll addSubview: houseGraphicView];
  houseGraphicView.frame = CGRectMake(
    ((screen.size.width - houseGraphicView.frame.size.width) * 0.5),
      ((screen.size.height - houseGraphicView.frame.size.height) * 0.5), 
        houseGraphicView.frame.size.width, houseGraphicView.frame.size.height);
  houseGraphicView.image = [UIImage imageNamed: @"house_image.png"];

  // Activity indicator spinner
  _activityIndicatorView = 
    [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: 
      UIActivityIndicatorViewStyleWhiteLarge];
  _activityIndicatorView.color = [UIColor grayDark];
  CGRect activityFrame = _activityIndicatorView.frame;
  activityFrame.origin.x = (self.view.frame.size.width - 
    activityFrame.size.width) * 0.5;
  activityFrame.origin.y = (self.view.frame.size.height - 
    activityFrame.size.height) * 0.5;
  _activityIndicatorView.frame = activityFrame;
  [self.view addSubview: _activityIndicatorView];
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
  // 0 - 1 pages
  if (page <= 1) {
    percent = (x - (width * 0)) / width;

    // Turn the hands on the stop watch
    _welcomeView.stopwatchView.minuteHand.transform =
      CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(360 * percent * 12.0));
    _welcomeView.stopwatchView.hourHand.transform = 
      CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(360 * percent));
    // Move the stop watch
    _welcomeView.stopwatchView.frame = CGRectMake((x * 3),
      _welcomeView.stopwatchView.frame.origin.y, 
        _welcomeView.stopwatchView.frame.size.width,
          _welcomeView.stopwatchView.frame.size.height);
    _welcomeView.stopwatchView.alpha = 1 - percent;

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
    _introDiscoverView.map.alpha = percent;
    // Marker 1
    if (percent <= 1) {
      float newPercent = (percent - 0.4) * 2;
      if (newPercent > 1)
        newPercent = 1;
      _introDiscoverView.marker1.frame = CGRectMake(
        _introDiscoverView.marker1.frame.origin.x, 
          ((screenHeight * 0.5) * newPercent),
            _introDiscoverView.marker1.frame.size.width, 
              _introDiscoverView.marker1.frame.size.height);
    }
    // Marker 3
    _introDiscoverView.marker3.frame = CGRectMake(
      _introDiscoverView.marker3.frame.origin.x, 
        ((screenHeight * 0.1) * percent),
          _introDiscoverView.marker3.frame.size.width, 
            _introDiscoverView.marker3.frame.size.height);
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
  }
  // 1 - 2 pages
  if (page <= 2 && page > 1) {
    percent = (x - (width * 1)) / width;

    // Discover view
    _introDiscoverView.map.alpha = 1 - percent;
    // Marker 1
    if (percent <= 1) {
      float newPercent = percent * 2;
      _introDiscoverView.marker1.frame = CGRectMake(
        _introDiscoverView.marker1.frame.origin.x, 
          ((screenHeight * 0.5) * (1 - newPercent)),
            _introDiscoverView.marker1.frame.size.width, 
              _introDiscoverView.marker1.frame.size.height);
    }
    // Marker 3
    _introDiscoverView.marker3.frame = CGRectMake(
      _introDiscoverView.marker3.frame.origin.x, 
        ((screenHeight * 0.1) * (1 - percent)),
          _introDiscoverView.marker3.frame.size.width, 
            _introDiscoverView.marker3.frame.size.height);
    // Marker 2
    if (percent <= 1) {
      float newPercent = percent * 4.5;
      _introDiscoverView.marker2.frame = CGRectMake(
        _introDiscoverView.marker2.frame.origin.x, 
          (screenHeight * 0.5) * (1 - newPercent),
            _introDiscoverView.marker2.frame.size.width, 
              _introDiscoverView.marker2.frame.size.height);
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
  // 2 - 3
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
    // iPhone view
    if (percent <= 1) {
      float newPercent = 2 - ((percent - 0.5) * 2.5);
      if (newPercent < 1)
        newPercent = 1;
      _introAuctionView.iphoneView.frame = CGRectMake(
        _introAuctionView.iphoneView.frame.origin.x,
          (((screenHeight - _introAuctionView.iphoneView.frame.size.height) * 
          0.35) * newPercent),
            _introAuctionView.iphoneView.frame.size.width,
              _introAuctionView.iphoneView.frame.size.height);
    }
    // iPhone screen
    if (percent >= 0.95) {
      _introAuctionView.iphoneScreen.alpha = 1;
    }
    else {
      _introAuctionView.iphoneScreen.alpha = 0;
    }
    // camera flash
    if (percent >= 0.9 && percent < 1)
      _introAuctionView.cameraFlash.alpha = percent * 1.2;
    else
      _introAuctionView.cameraFlash.alpha = 0;
  }
  // 3 - 4
  if (page <= 4 && page > 3) {
    percent = (x - (width * 3)) / width;

    float getStartedViewOriginX = 
      ((screenWidth - _getStartedView.getStartedButton.frame.size.width) * 0.5);
    float getStartedViewNewOriginX = 
      screenWidth - ((screenWidth - getStartedViewOriginX) * percent);
    _getStartedView.getStartedButton.frame = CGRectMake(
      getStartedViewNewOriginX,
        _getStartedView.getStartedButton.frame.origin.y,
          _getStartedView.getStartedButton.frame.size.width,
            _getStartedView.getStartedButton.frame.size.height);
  }
  // Scroll the close button view and the page control
  if (page <= 4) {
    _pageControl.frame = CGRectMake(x, 
      _pageControl.frame.origin.y, 
        _pageControl.frame.size.width, _pageControl.frame.size.height);

    closeButtonView.frame = CGRectMake(
      (screen.size.width - (closeButtonView.frame.size.width + 10)) + x, 
        closeButtonView.frame.origin.y, 
          closeButtonView.frame.size.width, closeButtonView.frame.size.height);
  }
  // 4 - 5
  if (page <= 5 && page > 4) {
    percent = (x - (width * 4)) / width;

    // Get started view
    float getStartedViewOriginX = 
      ((screenWidth - _getStartedView.getStartedButton.frame.size.width) * 0.5);
    float getStartedViewNewOriginX = 
      getStartedViewOriginX - ((screenWidth - getStartedViewOriginX) * percent);
    _getStartedView.getStartedButton.frame = CGRectMake(
      getStartedViewNewOriginX,
        _getStartedView.getStartedButton.frame.origin.y,
          _getStartedView.getStartedButton.frame.size.width,
            _getStartedView.getStartedButton.frame.size.height);

    // Sign up view
    int padding = 20;
    float signUpViewPercent;
    // Facebook button
    if (percent <= 1) {
      signUpViewPercent = percent * (1 + 0.5);
      if (signUpViewPercent > 1)
        signUpViewPercent = 1;
      CGRect rect = _signUpView.facebookButton.frame;
      _signUpView.facebookButton.frame = CGRectMake(
        ((padding + screenWidth) - (screenWidth * signUpViewPercent)),
          rect.origin.y, rect.size.width,
            rect.size.height);
    }
    // First name text field
    if (percent <= 1) {
      signUpViewPercent = percent * (1 + 0.4);
      if (signUpViewPercent > 1)
        signUpViewPercent = 1;
      CGRect rect = _signUpView.firstNameTextField.frame;
      _signUpView.firstNameTextField.frame = CGRectMake(
        ((padding + screenWidth) - (screenWidth * signUpViewPercent)),
          rect.origin.y, rect.size.width,
            rect.size.height);
    }
    // Last name text field
    if (percent <= 1) {
      signUpViewPercent = percent * (1 + 0.3);
      if (signUpViewPercent > 1)
        signUpViewPercent = 1;
      CGRect rect = _signUpView.lastNameTextField.frame;
      _signUpView.lastNameTextField.frame = CGRectMake(
        ((padding + screenWidth) - (screenWidth * signUpViewPercent)),
          rect.origin.y, rect.size.width,
            rect.size.height);
    }
    // Email name text field
    if (percent <= 1) {
      signUpViewPercent = percent * (1 + 0.2);
      if (signUpViewPercent > 1)
        signUpViewPercent = 1;
      CGRect rect = _signUpView.emailTextField.frame;
      _signUpView.emailTextField.frame = CGRectMake(
        ((padding + screenWidth) - (screenWidth * signUpViewPercent)),
          rect.origin.y, rect.size.width,
            rect.size.height);
    }
    // Password name text field
    if (percent <= 1) {
      signUpViewPercent = percent * (1 + 0.1);
      if (signUpViewPercent > 1)
        signUpViewPercent = 1;
      CGRect rect = _signUpView.passwordTextField.frame;
      _signUpView.passwordTextField.frame = CGRectMake(
        ((padding + screenWidth) - (screenWidth * signUpViewPercent)),
          rect.origin.y, rect.size.width,
            rect.size.height);
    }
    // Login button
    if (percent <= 1) {
      signUpViewPercent = percent * (1 + 0.0);
      if (signUpViewPercent > 1)
        signUpViewPercent = 1;
      CGRect rect = _signUpView.loginButton.frame;
      _signUpView.loginButton.frame = CGRectMake(
        ((padding + screenWidth) - (screenWidth * signUpViewPercent)),
          rect.origin.y, rect.size.width,
            rect.size.height);
    }
  }
  // 5 - 6
  if (page <= 6 && page > 5) {
    percent = (x - (width * 5)) / width;
  }
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) close
{
  [self dismissViewControllerAnimated: YES
    completion: nil];
}

- (void) scrollToCurrentPage: (UIPageControl *) control
{
  [self scrollToPage: control.currentPage];
}

- (void) scrollToPage: (int) page
{
  CGRect screen = [[UIScreen mainScreen] bounds];
  [_scroll setContentOffset: 
    CGPointMake((page * screen.size.width), 0) animated: YES];
}

- (void) setupForLoggedInUser
{
  _getStartedView.hidden     = YES;
  _signUpView.hidden         = YES;
  _pageControl.numberOfPages = 4;
  _pageControl.frame = CGRectMake(0.0f, (_scroll.frame.size.height - 60.0f), 
    _scroll.frame.size.width, 60.0f);
  _scroll.contentSize = CGSizeMake(
    (_scroll.frame.size.width * _pageControl.numberOfPages), 
      _scroll.frame.size.height);
}

- (void) setupForLoggedOutUser
{
  _getStartedView.hidden     = NO;
  _signUpView.hidden         = NO;
  _pageControl.numberOfPages = 5;
  _pageControl.frame = CGRectMake(0.0f, (_scroll.frame.size.height - 60.0f), 
    _scroll.frame.size.width, 60.0f);
  // Number of pages + 1 for the sign up view at the end of the intro
  _scroll.contentSize = CGSizeMake(
    (_scroll.frame.size.width * (_pageControl.numberOfPages + 1)), 
      _scroll.frame.size.height);
}

- (void) showLogin
{
  [_loginViewController showLogin];
  [self presentViewController: _loginViewController 
    animated: YES completion: nil];
}

@end
