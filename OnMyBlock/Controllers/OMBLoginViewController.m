//
//  OMBLoginViewController.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 10/30/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBLoginViewController.h"

#import "OMBActivityView.h"
#import "OMBCloseButtonView.h"
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

@implementation OMBLoginViewController

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
  [_signUpView updateScrollContentSizeAnimated: NO];
  [self.view addSubview: _signUpView];

  int padding = 10;
  // Close view
  float closeButtonViewHeight = 20;
  float closeButtonViewWidth  = closeButtonViewHeight;
  CGRect closeButtonRect = CGRectMake(
    (screen.size.width - (closeButtonViewWidth + padding)), (20 + padding), 
      closeButtonViewWidth, closeButtonViewHeight);
  closeButtonView = [[OMBCloseButtonView alloc] initWithFrame: closeButtonRect
    color: [UIColor grayMedium]];
  [self.view addSubview: closeButtonView];
  [closeButtonView.closeButton addTarget: self action: @selector(close)
    forControlEvents: UIControlEventTouchUpInside];

  _activityView = [[OMBActivityView alloc] init];
  [self.view addSubview: _activityView];
}

- (void) viewWillAppear: (BOOL) animated
{
  [_signUpView resetOriginX];
  [_signUpView updateScrollContentSizeAnimated: NO];

  [_activityView stopSpinning];
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
