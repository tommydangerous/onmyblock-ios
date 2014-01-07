//
//  OMBLoginViewController.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 10/30/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBLoginViewController.h"

#import "OMBLoginConnection.h"
#import "OMBIntroViewController.h"
#import "OMBNavigationController.h"
#import "OMBSignUpConnection.h"
#import "OMBSignUpView.h"
#import "OMBUser.h"
#import "TextFieldPadding.h"
#import "UIColor+Extensions.h"
#import "UIImage+Color.h"
#import "UIImage+Resize.h"

#define DEGREES_TO_RADIANS(x) (M_PI * x / 180.0)

@implementation OMBLoginViewController

@synthesize activityIndicatorView = _activityIndicatorView;
@synthesize signUpView            = _signUpView;;

#pragma mark - Initializer

- (id) init
{
  if (!(self = [super init])) return nil;

  // self.edgesForExtendedLayout = 
  //   (UIRectEdgeBottom | UIRectEdgeLeft | UIRectEdgeRight);
  self.screenName = @"Login View Controller";
  self.title = @"Login";

  return self;
}

#pragma mark - Override

#pragma mark - Override UIViewController

- (void) loadView
{
  [super loadView];

  CGRect screen = [[UIScreen mainScreen] bounds];
  self.view = [[UIView alloc] initWithFrame: screen];

  _signUpView = [[OMBSignUpView alloc] init];
  [_signUpView resetOriginX];
  [_signUpView resetOriginY];
  [_signUpView updateScrollContentSize];
  [self.view addSubview: _signUpView];

  int padding = 10;
  // Close view
  closeButtonView = [[UIView alloc] init];
  float closeButtonViewHeight = 20;
  float closeButtonViewWidth  = closeButtonViewHeight;
  closeButtonView.frame = CGRectMake(
    (screen.size.width - (closeButtonViewWidth + padding)), (20 + padding), 
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
  closeButton.frame = CGRectMake(0, 0, closeButtonView.frame.size.width,
    closeButtonView.frame.size.height);
  [closeButton addTarget: self action: @selector(close)
    forControlEvents: UIControlEventTouchUpInside];
  [closeButtonView addSubview: closeButton];

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

- (void) viewWillAppear: (BOOL) animated
{
  [_signUpView resetOriginX];
  [_signUpView updateScrollContentSize];
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) close
{
  [self dismissViewControllerAnimated: YES completion: nil];
}

- (void) showLogin
{
  [_signUpView showLogin];
}

- (void) showSignUp
{
  [_signUpView showSignUp];
}

@end
