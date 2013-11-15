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
#import "OMBIntroductionView.h"
#import "OMBIntroContactView.h"
#import "OMBIntroFavoritesView.h"
#import "OMBIntroSearchView.h"
#import "OMBLoginViewController.h"
#import "OMBNavigationController.h"
#import "OMBSignUpView.h"
#import "OMBWelcomeView.h"
#import "TextFieldPadding.h"
#import "UIColor+Extensions.h"
#import "UIImage+Color.h"

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

  _pageControl = [[UIPageControl alloc] init];
  _pageControl.frame = CGRectMake(0, 20, screen.size.width, 40);
  _pageControl.currentPageIndicatorTintColor = [UIColor pink];
  _pageControl.numberOfPages = 6;
  _pageControl.pageIndicatorTintColor = [UIColor grayLight];
  [_pageControl addTarget: self action: @selector(scrollToCurrentPage:)
    forControlEvents: UIControlEventValueChanged];
  [self.view addSubview: _pageControl];

  // Welcome view
  _welcomeView = [[OMBWelcomeView alloc] init];
  _welcomeView.frame = CGRectMake(0, 0, screen.size.width, screen.size.height);
  [_scroll addSubview: _welcomeView];

  _introductionView = [[OMBIntroductionView alloc] init];
  _introductionView.frame = CGRectMake((screen.size.width * 1), 0, 
    _welcomeView.frame.size.width, _welcomeView.frame.size.height);
  [_scroll addSubview: _introductionView];

  _introSearchView = [[OMBIntroSearchView alloc] init];
  _introSearchView.frame = CGRectMake((screen.size.width * 2), 0, 
    _welcomeView.frame.size.width, _welcomeView.frame.size.height);
  [_scroll addSubview: _introSearchView];

  _introContactView = [[OMBIntroContactView alloc] init];
  _introContactView.frame = CGRectMake((screen.size.width * 3), 0,
    _welcomeView.frame.size.width, _welcomeView.frame.size.height);
  [_scroll addSubview: _introContactView];

  _introFavoritesView = [[OMBIntroFavoritesView alloc] init];
  _introFavoritesView.frame = CGRectMake((screen.size.width * 4), 0,
    _welcomeView.frame.size.width, _welcomeView.frame.size.height);
  [_scroll addSubview: _introFavoritesView];

  _signUpView = [[OMBSignUpView alloc] init];
  _signUpView.frame = CGRectMake((screen.size.width * 5), 0,
    _welcomeView.frame.size.width, _welcomeView.frame.size.height);
  [_scroll addSubview: _signUpView];

  // Login button  
  _loginButton = [[UIButton alloc] init];
  _loginButton.frame = CGRectMake(0, 
    (screen.size.height - 50), (screen.size.width * 0.5), 50);
  _loginButton.titleLabel.font = [UIFont fontWithName: 
    @"HelveticaNeue-Medium" size: 18];
  [_loginButton addTarget: self action: @selector(showLogin)
    forControlEvents: UIControlEventTouchUpInside];
  [_loginButton setBackgroundImage: 
    [UIImage imageWithColor: [UIColor grayDark]] 
      forState: UIControlStateNormal];
  [_loginButton setBackgroundImage: 
    [UIImage imageWithColor: [UIColor grayMedium]] 
      forState: UIControlStateHighlighted];
  [_loginButton setTitle: @"Login" forState: UIControlStateNormal];
  [_loginButton setTitleColor: [UIColor whiteColor] 
    forState: UIControlStateNormal];
  [self.view addSubview: _loginButton];
  // Sign up button  
  _signUpButton = [[UIButton alloc] init];
  _signUpButton.frame = CGRectMake(
    (_loginButton.frame.origin.x + _loginButton.frame.size.width), 
      _loginButton.frame.origin.y, _loginButton.frame.size.width, 
        _loginButton.frame.size.height);
  _signUpButton.titleLabel.font = _loginButton.titleLabel.font;
  [_signUpButton addTarget: self action: @selector(showSignUpOrSignUp)
    forControlEvents: UIControlEventTouchUpInside];
  [_signUpButton setBackgroundImage: 
    [UIImage imageWithColor: [UIColor blue]] 
      forState: UIControlStateNormal];
  [_signUpButton setBackgroundImage: 
    [UIImage imageWithColor: [UIColor blueDark]] 
      forState: UIControlStateHighlighted];
  [_signUpButton setTitle: @"Sign Up" forState: UIControlStateNormal];
  [_signUpButton setTitleColor: [UIColor whiteColor] 
    forState: UIControlStateNormal];  
  [self.view addSubview: _signUpButton];
}

#pragma mark - Protocol

#pragma mark - Protocol UIScrollViewDelegate

- (void) scrollViewDidEndDragging: (UIScrollView *) scrollView 
willDecelerate: (BOOL)decelerate
{
  [_signUpView resetViewOrigins];
}

- (void) scrollViewDidScroll: (UIScrollView *) scrollView
{
  // Change the pages on the page control
  float currentPage = scrollView.contentOffset.x / scrollView.frame.size.width;
  _pageControl.currentPage = currentPage;
  // Resign first responder for all text fields for sign up view
  [_signUpView endEditing: YES];
}

// Not being used yet
- (void) scrollViewDidScroll1: (UIScrollView *) scrollView
{
  CGRect screen = [[UIScreen mainScreen] bounds];
  float x       = scrollView.contentOffset.x;
  float percent = ((x - 
    (scrollView.frame.size.width * 3)) / scrollView.frame.size.width);
  NSLog(@"%f", percent);
  if (percent > 0 && percent <= 1) {
    _loginButton.frame = CGRectMake(0, _loginButton.frame.origin.y, 
      ((percent * (screen.size.width * 0.5)) + (screen.size.width * 0.5)),
        _loginButton.frame.size.height);
    _signUpButton.frame = CGRectMake(
      (_loginButton.frame.origin.x + _loginButton.frame.size.width), 
        _signUpButton.frame.origin.y, _signUpButton.frame.size.width, 
          _signUpButton.frame.size.height);
  }
  else if (percent > 1 && percent <= 2) {
    percent -= 1;
    _signUpButton.frame = CGRectMake(((1 - percent) * screen.size.width),
      _signUpButton.frame.origin.y,
        ((percent * (screen.size.width * 0.5)) + (screen.size.width * 0.5)),
          _signUpButton.frame.size.height);
    _loginButton.frame = CGRectMake((percent * (-1 * screen.size.width * 0.5)),
      _loginButton.frame.origin.y, 
        (((1 - percent) * (screen.size.width * 0.5)) + 
        (screen.size.width * 0.5)),
          _loginButton.frame.size.height);
    NSString *newTitle;
    if (percent > 0.5)
      newTitle = @"Sign up using Facebook";
    else
      newTitle = @"Login using Facebook";
    [_signUpView.facebookButton setTitle: newTitle
      forState: UIControlStateNormal];

    _signUpView.nameTextField.alpha = percent;
  }
  if (x >= (scrollView.frame.size.width * 4) && 
    x <= scrollView.frame.size.width * 5) {

    _signUpView.frame = CGRectMake(scrollView.contentOffset.x,
      _signUpView.frame.origin.y, _signUpView.frame.size.width,
        _signUpView.frame.size.height);
  }
  else {
    
  }
}

#pragma mark - Methods

#pragma mark - Instance Methods

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
