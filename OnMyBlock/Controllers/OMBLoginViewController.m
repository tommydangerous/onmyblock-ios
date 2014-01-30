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
#import "OMBLoginSignUpView.h"
#import "OMBNavigationController.h"
#import "OMBSignUpConnection.h"
#import "OMBUser.h"
#import "OMBViewControllerContainer.h"
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

  _signUpView = [[OMBLoginSignUpView alloc] init];
  [self.view addSubview: _signUpView];

  CGFloat padding = OMBPadding;
  
  // Close view
  CGFloat closeButtonPadding    = padding;
  CGFloat closeButtonViewHeight = padding;
  CGFloat closeButtonViewWidth  = closeButtonViewHeight;
  CGRect closeButtonRect = CGRectMake(screen.size.width - 
    (closeButtonViewWidth + closeButtonPadding - 3.0f), 
      padding + closeButtonPadding, closeButtonViewWidth, 
        closeButtonViewHeight);
  closeButtonView = [[OMBCloseButtonView alloc] initWithFrame: closeButtonRect
    color: [UIColor colorWithWhite: 1.0f alpha: 0.8f]];
  [closeButtonView.closeButton addTarget: self action: @selector(close)
    forControlEvents: UIControlEventTouchUpInside];
  // [self.view addSubview: closeButtonView];

  _activityView = [[OMBActivityView alloc] init];
  [self.view addSubview: _activityView];
}

- (void) viewWillAppear: (BOOL) animated
{
  // [_signUpView resetOriginX];
  // [_signUpView updateScrollContentSizeAnimated: NO];

  // [[self appDelegate].container stopSpinning];
  [_activityView stopSpinning];
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) close
{
  [self dismissViewControllerAnimated: YES completion: nil];
}

- (void) showLandlordSignUp
{
  // [_signUpView showSignUpForLandlord];
}

- (void) showLogin
{
  // [_signUpView showLogin];
}

- (void) showSignUp
{
  // [_signUpView showSignUpForStudent];
}

@end
