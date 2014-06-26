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

// View controllers
#import "OMBViewControllerContainer.h"

@implementation OMBLoginViewController

#pragma mark - Initializer

- (id) init
{
  if (!(self = [super init])) return nil;

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

  [[NSNotificationCenter defaultCenter]addObserver:self
                                          selector:@selector(becomeActive)
                                              name:UIApplicationDidBecomeActiveNotification
                                            object:nil];

  animate = NO;

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

  imageNames = @[
    @"intro_still_image_slide_5_background.jpg",
    // @"intro_still_image_slide_6_background.jpg",
    // @"intro_still_image_slide_7_background.jpg",
    // @"intro_still_image_slide_8_background.jpg"
  ];

  int index = arc4random_uniform([imageNames count] - 1);
  UIImage *image = [UIImage imageNamed: [imageNames objectAtIndex: index]];
  [_loginSignUpView.blurView refreshWithImage: image];
}

- (void) viewDidAppear: (BOOL) animated
{
  [super viewDidAppear: animated];

  [self animateStatusBarLight];
}

- (void) viewDidDisappear: (BOOL) animated
{
  [super viewDidDisappear: animated];
  animate = NO;
  [_loginSignUpView scrollToTop];
}

- (void) viewWillAppear: (BOOL) animated
{
  [super viewWillAppear: animated];

  // int index = arc4random_uniform([imageNames count] - 1);
  // UIImage *image = [UIImage imageNamed: [imageNames objectAtIndex: index]];
  // [_loginSignUpView.blurView refreshWithImage: image];

  [_activityView stopSpinning];
}

- (void) viewWillDisappear: (BOOL) animated
{
  [super viewWillDisappear: animated];

  if (![[self appDelegate].container isMenuVisible]) {
    [self animateStatusBarDefault];
  }
}

#pragma mark - Protocol

#pragma mark - Protocol UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
  // login
  if(alertView.tag == 1){
    // Sign up
    if(buttonIndex == 1)
       [self showSignUp];
    // Reset password
    else if(buttonIndex == 2) {
      _loginSignUpView.passwordTextField.text = @"";
      #warning SEND AN EMAIL TO RESET PASSWORD
      NSString *message = [NSString stringWithFormat:
        @"An email with password reset instructions has "
        @"been sent to \"%@\"", _loginSignUpView.emailTextField.text];
      UIAlertView *alertView = [[UIAlertView alloc] initWithTitle: nil
        message: message delegate: nil cancelButtonTitle: @"Okay"
          otherButtonTitles: nil];
      [alertView show];
    }
  }
  // sign up
  else if(alertView.tag == 2){
    if(buttonIndex == 1)
      [self showLogin];
  }
}

#pragma mark - Methods

#pragma mark - Instance Methods

-(void) becomeActive
{
  if (animate)
    [_activityView startSpinning];
}

- (void) close
{
  [self dismissViewControllerAnimated: YES completion: nil];
}

- (void) login
{
  NSString *emailString    = _loginSignUpView.emailTextField.text;
  NSString *passwordString = _loginSignUpView.passwordTextField.text;

  NSString *message;
  if ([emailString length] == 0) {
    message = @"Please enter your email.";
  }
  else if ([passwordString length] == 0) {
    message = @"Please enter your password.";
  }
  if ([emailString length] == 0 || [passwordString length] == 0) {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle: @"Login failed"
      message: message delegate: nil cancelButtonTitle: @"Okay"
        otherButtonTitles: nil];
    [alertView show];
    return;
  }
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
      [self showAlertViewLogin];
    }
    [_activityView stopSpinning];
  };
  [conn start];
  [_activityView startSpinning];
  [self.view endEditing: YES];
}

- (void) loginOrSignUp
{
  if ([_loginSignUpView isLogin])
    [self login];
  else
    [self signUp];
}

- (void) showAlertViewLogin
{
  NSString *message = @"Incorrect email or password, please try again.";

  UIAlertView *alertView = [[UIAlertView alloc] initWithTitle: nil
    message: message delegate: self cancelButtonTitle: @"Ok"
      otherButtonTitles: @"Sign Up", @"Reset Password", nil];
  alertView.tag = 1;
  [alertView show];
}

- (void) showAlertViewSignUp
{
  NSString *message = @"Email has already been taken.";

  UIAlertView *alertView = [[UIAlertView alloc] initWithTitle: nil
    message: message delegate: self cancelButtonTitle: @"Ok"
      otherButtonTitles: @"Login", nil];
  alertView.tag = 2;
  [alertView show];
}

- (void) showFacebook
{
  if ([_loginSignUpView isLandlord]) {
    [OMBUser currentUser].userType = OMBUserTypeLandlord;
  }
  else {
    [OMBUser currentUser].userType = @"";
  }
  animate = YES;
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
  NSString *emailString     = _loginSignUpView.emailTextField.text;
  NSString *firstNameString = _loginSignUpView.firstNameTextField.text;
  NSString *lastNameString  = _loginSignUpView.lastNameTextField.text;
  NSString *passwordString  = _loginSignUpView.passwordTextField.text;

  NSString *message;
  if ([firstNameString length] == 0) {
    message = @"Please enter your first name.";
  }
  else if ([lastNameString length] == 0) {
    message = @"Please enter your last name.";
  }
  else if ([emailString length] == 0) {
    message = @"Please enter your email.";
  }
  else if ([passwordString length] == 0) {
    message = @"Please enter a password.";
  }
  if ([message length]) {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:
      @"Sign up failed" message: message delegate: nil
        cancelButtonTitle: @"Okay" otherButtonTitles: nil];
    [alertView show];
    return;
  }

  NSMutableDictionary *params =
    [NSMutableDictionary dictionaryWithDictionary: @{
      @"created_source": @"ios",
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
      NSString *alertMessage = error.localizedFailureReason != (id)[NSNull null] ? error.localizedFailureReason : @"Unsuccessful";

      if([alertMessage isEqualToString:@"Email has already been taken"])
        [self showAlertViewSignUp];
      else
        [self showAlertViewWithError:error];
    }
    [_activityView stopSpinning];
  };
  [conn start];
  [_activityView startSpinning];
  [self.view endEditing: YES];
}

@end
