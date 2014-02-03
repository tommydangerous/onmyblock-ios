//
//  OMBLoginViewController.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 10/30/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBLoginViewController.h"

#import "OMBActivityView.h"
#import "OMBBlurView.h"
#import "OMBCloseButtonView.h"
#import "OMBFacebookButton.h"
#import "OMBLoginConnection.h"
#import "OMBLoginSignUpView.h"
#import "OMBSignUpConnection.h"
#import "OMBUser.h"
#import "TextFieldPadding.h"
#import "UIColor+Extensions.h"
#import "UIImage+Color.h"

@implementation OMBLoginViewController

#pragma mark - Initializer

- (id) init
{
  if (!(self = [super init])) return nil;

  imageNames = @[
    @"intro_still_image_slide_5_background.jpg",
    @"intro_still_image_slide_6_background.jpg",
    @"intro_still_image_slide_7_background.jpg",
    @"intro_still_image_slide_8_background.jpg"
  ];

  self.screenName = @"Login View Controller";
  self.title      = @"Login";

  return self;
}

#pragma mark - Override

#pragma mark - Override UIViewController

- (void) loadView
{
  [super loadView];

  CGRect screen = [[UIScreen mainScreen] bounds];

  self.view = [[UIView alloc] initWithFrame: screen];

  // Login and sign up view
  _loginSignUpView = [[OMBLoginSignUpView alloc] init];
  // Close button
  [_loginSignUpView.closeButtonView.closeButton addTarget: self
    action: @selector(close) forControlEvents: UIControlEventTouchUpInside];
  // Facebook
  [_loginSignUpView.facebookButton addTarget: self
    action: @selector(showFacebook) 
      forControlEvents: UIControlEventTouchUpInside];
  // Login or Sign Up
  [_loginSignUpView.actionButton addTarget: self 
    action: @selector(loginOrSignUp) 
      forControlEvents: UIControlEventTouchUpInside];
  [self.view addSubview: _loginSignUpView];

  // Activity spinner
  _activityView = [[OMBActivityView alloc] init];
  [self.view addSubview: _activityView];
}

- (void) viewDidDisappear: (BOOL) animated
{
  [super viewDidDisappear: animated];

  [_loginSignUpView scrollToTop];
}

- (void) viewWillAppear: (BOOL) animated
{
  [super viewWillAppear: animated];

  int index = arc4random_uniform([imageNames count] - 1);
  UIImage *image = [UIImage imageNamed: [imageNames objectAtIndex: index]];
  [_loginSignUpView.blurView refreshWithImage: image];

  [_activityView stopSpinning];
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) close
{
  [self dismissViewControllerAnimated: YES completion: nil];
}

- (void) login
{
  NSString *emailString = _loginSignUpView.emailTextField.text;
  NSString *passwordString = _loginSignUpView.passwordTextField.text;
  if ([emailString length] && [passwordString length]) {
    NSDictionary *params = @{
      @"email":    emailString,
      @"password": passwordString
    };
    OMBLoginConnection *conn =
      [[OMBLoginConnection alloc] initWithParameters: params];
    conn.completionBlock = ^(NSError *error) {
      if ([[OMBUser currentUser] loggedIn]) {
        [_loginSignUpView clearTextFields];
      }
      else {
        _loginSignUpView.passwordTextField.text = @"";
        [self showAlertViewWithError: error];
      }
      [_activityView stopSpinning];
    };
    [conn start];
    [_activityView startSpinning];
    [self.view endEditing: YES];
  }
}

- (void) loginOrSignUp
{
  if ([_loginSignUpView isLogin])
    [self login];
  else
    [self signUp];
}

- (void) showFacebook
{
  if ([_loginSignUpView isLandlord]) {
    [OMBUser currentUser].userType = OMBUserTypeLandlord;
  }
  else {
    [OMBUser currentUser].userType = @"";
  }
  [[self appDelegate] openSession];
  [_activityView startSpinning];
}

- (void) showLandlordSignUp
{
  [_loginSignUpView switchToLandlord];
  [_loginSignUpView switchToSignUp];
}

- (void) showLogin
{
  [_loginSignUpView switchToStudent];
  [_loginSignUpView switchToLogin];
}

- (void) showSignUp
{
  [_loginSignUpView switchToStudent];
  [_loginSignUpView switchToSignUp];
}

- (void) signUp
{
  NSString *emailString = _loginSignUpView.emailTextField.text;
  NSString *firstNameString = _loginSignUpView.firstNameTextField.text;
  NSString *lastNameString = _loginSignUpView.lastNameTextField.text;
  NSString *passwordString = _loginSignUpView.passwordTextField.text;
  if ([emailString length] && [firstNameString length] &&
    [lastNameString length] && [passwordString length]) {

    NSMutableDictionary *params = 
      [NSMutableDictionary dictionaryWithDictionary: @{
        @"email":      emailString,
        @"first_name": firstNameString,
        @"last_name":  lastNameString,
        @"password":   passwordString
      }];
    NSString *userTypeKey = @"user_type";
    if ([_loginSignUpView isLandlord]) {
      [params setObject: OMBUserTypeLandlord forKey: userTypeKey];
    }
    else {
      [params removeObjectForKey: userTypeKey];
    }
    OMBSignUpConnection *conn = 
      [[OMBSignUpConnection alloc] initWithParameters: params];
    conn.completionBlock = ^(NSError *error) {
      if ([[OMBUser currentUser] loggedIn]) {
        [_loginSignUpView clearTextFields];
      }
      else {
        [self showAlertViewWithError: error];
      }
      [_activityView stopSpinning];
    };
    [conn start];
    [_activityView startSpinning];
    [self.view endEditing: YES];
  } 
}

@end
