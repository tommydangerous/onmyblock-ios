//
//  OMBSignUpView.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 11/8/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBSignUpView.h"

#import "OMBAppDelegate.h"
#import "OMBIntroViewController.h"
#import "OMBSignUpConnection.h"
#import "TextFieldPadding.h"
#import "UIColor+Extensions.h"
#import "UIImage+Color.h"
#import "UIImage+Resize.h"

@implementation OMBSignUpView

@synthesize facebookButton = _facebookButton;
@synthesize nameTextField  = _nameTextField;

#pragma mark - Initializer

- (id) init
{
  if (!(self = [super init])) return nil;

  [[NSNotificationCenter defaultCenter] addObserver: self
    selector: @selector(startSpinning) 
      name: OMBActivityIndicatorViewStartAnimatingNotification object: nil];
  [[NSNotificationCenter defaultCenter] addObserver: self
    selector: @selector(stopSpinning) 
      name: OMBActivityIndicatorViewStopAnimatingNotification object: nil];

  CGRect screen = [[UIScreen mainScreen] bounds];

  self.alwaysBounceVertical = YES;
  self.frame                = screen;
  self.showsVerticalScrollIndicator = NO;

  int padding = 20;

  // Get started
  UILabel *getStarted = [[UILabel alloc] init];
  getStarted.font = [UIFont fontWithName: @"HelveticaNeue-Medium" size: 27];
  getStarted.frame = CGRectMake(padding, (padding * 3), 
    (screen.size.width - (padding * 2)), 36);
  getStarted.text = @"Get Started!";
  getStarted.textAlignment = NSTextAlignmentCenter;
  getStarted.textColor = [UIColor grayDark];
  [self addSubview: getStarted];

  // Facebook button
  _facebookButton = [[UIButton alloc] init];
  _facebookButton.backgroundColor = [UIColor facebookBlue];
  _facebookButton.clipsToBounds = YES;
  _facebookButton.frame = CGRectMake(padding, 
    (getStarted.frame.origin.y + getStarted.frame.size.height + padding), 
      (screen.size.width - (padding * 2)), 
        ((padding / 2.0) + 30 + (padding / 2.0)));
  _facebookButton.layer.cornerRadius = 2.0;
  _facebookButton.titleLabel.font = 
    [UIFont fontWithName: @"HelveticaNeue-Medium"
    size: 15];
  [_facebookButton addTarget: self action: @selector(showFacebookLogin)
    forControlEvents: UIControlEventTouchUpInside];
  [_facebookButton setTitle: @"Sign up using Facebook" 
    forState: UIControlStateNormal];
  [_facebookButton setBackgroundImage: 
    [UIImage imageWithColor: [UIColor facebookBlueDark]] 
      forState: UIControlStateHighlighted];
  [self addSubview: _facebookButton];
  UIImageView *facebookImageView = [[UIImageView alloc] init];
  facebookImageView.frame = CGRectMake((padding / 2.0), (padding / 2.0), 
    30, 30);
  facebookImageView.image = [UIImage image: 
    [UIImage imageNamed: @"facebook_icon.png"] size: CGSizeMake(30, 30)];
  [_facebookButton addSubview: facebookImageView];

  orView = [[UIView alloc] init];  
  orView.frame = CGRectMake(0, (_facebookButton.frame.origin.y + 
    _facebookButton.frame.size.height + padding), screen.size.width, 
      _facebookButton.frame.size.height);
  [self addSubview: orView];
  UILabel *orLabel = [[UILabel alloc] init];
  orLabel.font = [UIFont fontWithName: @"HelveticaNeue-Light" size: 15];
  orLabel.frame = CGRectMake(0, 0, orView.frame.size.width, 
    orView.frame.size.height);
  orLabel.text = @"or";
  orLabel.textAlignment = NSTextAlignmentCenter;
  orLabel.textColor = [UIColor grayMedium];
  [orView addSubview: orLabel];
  CALayer *leftLine         = [CALayer layer];
  CALayer *rightLine        = [CALayer layer]; 
  leftLine.backgroundColor  = orLabel.textColor.CGColor;
  rightLine.backgroundColor = leftLine.backgroundColor;
  leftLine.frame = CGRectMake(_facebookButton.frame.origin.x, 
    (orView.frame.size.height / 2.0), 
      (_facebookButton.frame.size.width * 0.4), 0.5);
  rightLine.frame = CGRectMake(
    (screen.size.width - (leftLine.frame.origin.x + 
      leftLine.frame.size.width)), leftLine.frame.origin.y, 
        leftLine.frame.size.width, leftLine.frame.size.height);
  [orView.layer addSublayer: leftLine];
  [orView.layer addSublayer: rightLine];

  // Name
  _nameTextField = [[TextFieldPadding alloc] init];
  _nameTextField.autocorrectionType = UITextAutocorrectionTypeNo;
  _nameTextField.backgroundColor = [UIColor whiteColor];
  _nameTextField.delegate = self;
  _nameTextField.font = [UIFont fontWithName: @"HelveticaNeue-Light"
    size: 15];
  _nameTextField.frame = CGRectMake(padding, (orView.frame.origin.y +
    orView.frame.size.height + padding),
      (screen.size.width - (padding * 2)), 
        ((padding / 2.0) + 22 + (padding / 2.0)));
  _nameTextField.layer.borderColor = [UIColor grayLight].CGColor;
  _nameTextField.layer.borderWidth = 1.0;
  _nameTextField.paddingX = padding / 2.0;
  _nameTextField.paddingY = padding / 2.0;
  _nameTextField.placeholder = @"Name";
  _nameTextField.returnKeyType = UIReturnKeyDone;
  UIView *nameRightView = [[UIView alloc] init];
  nameRightView.alpha = 0.3;
  nameRightView.frame = CGRectMake(0, 0, (22 + (padding / 2.0)), 22);
  _nameTextField.rightView = nameRightView;
  _nameTextField.rightViewMode = UITextFieldViewModeAlways;
  UIImageView *nameImageView = [[UIImageView alloc] init];
  nameImageView.frame = CGRectMake(0, 0, 22, 22);
  nameImageView.image = [UIImage image: [UIImage imageNamed: @"user_icon.png"]
    size: nameImageView.frame.size];
  [nameRightView addSubview: nameImageView];
  [self addSubview: _nameTextField];

  // Email
  emailTextField = [[TextFieldPadding alloc] init];
  emailTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
  emailTextField.autocorrectionType = UITextAutocorrectionTypeNo;
  emailTextField.backgroundColor = [UIColor whiteColor];
  emailTextField.delegate = self;
  emailTextField.font = [UIFont fontWithName: @"HelveticaNeue-Light"
    size: 15];
  emailTextField.frame = CGRectMake(_nameTextField.frame.origin.x,
    (_nameTextField.frame.origin.y + _nameTextField.frame.size.height + 
    padding),
      _nameTextField.frame.size.width, _nameTextField.frame.size.height);
  emailTextField.keyboardType = UIKeyboardTypeEmailAddress;
  emailTextField.layer.borderColor = [UIColor grayLight].CGColor;
  emailTextField.layer.borderWidth = 1.0;
  emailTextField.paddingX = padding / 2.0;
  emailTextField.paddingY = padding / 2.0;
  emailTextField.placeholder = @"Email";
  emailTextField.returnKeyType = UIReturnKeyDone;
  UIView *emailRightView = [[UIView alloc] init];
  emailRightView.alpha = 0.3;
  emailRightView.frame = CGRectMake(0, 0, (22 + (padding / 2.0)), 22);
  emailTextField.rightView = emailRightView;
  emailTextField.rightViewMode = UITextFieldViewModeAlways;
  UIImageView *emailImageView = [[UIImageView alloc] init];
  emailImageView.frame = CGRectMake(0, 0, 22, 22);
  emailImageView.image = [UIImage image: [UIImage imageNamed: @"email_icon.png"]
    size: emailImageView.frame.size];
  [emailRightView addSubview: emailImageView];
  [self addSubview: emailTextField];

  // Password
  passwordTextField = [[TextFieldPadding alloc] init];
  passwordTextField.autocapitalizationType = 
    emailTextField.autocapitalizationType;
  passwordTextField.autocorrectionType = emailTextField.autocorrectionType;
  passwordTextField.backgroundColor = emailTextField.backgroundColor;
  passwordTextField.delegate = self;
  passwordTextField.font = emailTextField.font;
  passwordTextField.frame = CGRectMake(emailTextField.frame.origin.x,
    (emailTextField.frame.origin.y + emailTextField.frame.size.height + 
      padding), emailTextField.frame.size.width, 
        emailTextField.frame.size.height);
  passwordTextField.layer.borderColor = emailTextField.layer.borderColor;
  passwordTextField.layer.borderWidth = emailTextField.layer.borderWidth;
  passwordTextField.paddingX = emailTextField.paddingX;
  passwordTextField.paddingY = emailTextField.paddingY;
  passwordTextField.placeholder = @"Password";
  passwordTextField.returnKeyType = emailTextField.returnKeyType;
  passwordTextField.secureTextEntry = YES;
  UIView *passwordRightView = [[UIView alloc] init];
  passwordRightView.alpha = emailRightView.alpha;
  passwordRightView.frame = emailRightView.frame;
  passwordTextField.rightView = passwordRightView;
  passwordTextField.rightViewMode = UITextFieldViewModeAlways;
  UIImageView *passwordImageView = [[UIImageView alloc] init];
  passwordImageView.frame = emailImageView.frame;
  passwordImageView.image = [UIImage image: 
    [UIImage imageNamed: @"password_icon.png"]
      size: emailImageView.frame.size];
  [passwordRightView addSubview: passwordImageView];
  [self addSubview: passwordTextField];

  loginButton = [[UIButton alloc] init];
  loginButton.backgroundColor = [UIColor blue];
  loginButton.clipsToBounds = YES;
  loginButton.frame = CGRectMake(_facebookButton.frame.origin.x,
    (passwordTextField.frame.origin.y + passwordTextField.frame.size.height +
      padding), _facebookButton.frame.size.width, 
        _facebookButton.frame.size.height);
  loginButton.titleLabel.font = _facebookButton.titleLabel.font;
  loginButton.layer.cornerRadius = 2.0;
  [loginButton addTarget: self action: @selector(signUp)
    forControlEvents: UIControlEventTouchUpInside];
  [loginButton setTitle: @"SIGN UP" forState: UIControlStateNormal];
  [loginButton setBackgroundImage: [UIImage imageWithColor: [UIColor blueDark]]
    forState: UIControlStateHighlighted];
  [self addSubview: loginButton];

  self.contentSize = CGSizeMake(screen.size.width, 
    (loginButton.frame.origin.y + loginButton.frame.size.height + 
    padding + 50)); // 50 is the height of the sign up and login buttons

  activityIndicatorView = 
    [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: 
      UIActivityIndicatorViewStyleWhiteLarge];
  activityIndicatorView.color = [UIColor grayDark];
  activityIndicatorView.frame = CGRectMake(((screen.size.width - 60) / 2.0),
    ((screen.size.height - 60) / 2.0), 60, 60);
  [self addSubview: activityIndicatorView];

  return self;
}

#pragma mark - Protocol

#pragma mark - Protocol UITextFieldDelegate

- (void) textFieldDidBeginEditing: (UITextField *) textField
{
  // If it lags, that is because the 1st time the keyboard loads it lags
  int padding = 20;
  // Don't add 50 here because the height of the keyboard (216) covers the 50
  float height = (loginButton.frame.origin.y + 
    loginButton.frame.size.height + padding + 216);
  float y = height - 
    (20 + self.frame.size.height + loginButton.frame.size.height);
  if (y < 0)
    y = 0;
  CGPoint point = CGPointMake(self.contentOffset.x, y);
  [UIView animateWithDuration: 0.25 animations: ^{
    self.contentOffset = point;
  } completion: ^(BOOL finished) {
    self.contentSize = CGSizeMake(self.contentSize.width, height);
  }];
}

- (BOOL) textFieldShouldReturn: (UITextField *) textField
{
  [textField resignFirstResponder];
  [self resetViewOrigins];
  return YES;
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) hideIntro
{
  OMBAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
  [appDelegate.introViewController dismissViewControllerAnimated: YES
    completion: nil];
  emailTextField.text    = @"";
  _nameTextField.text    = @"";
  passwordTextField.text = @"";
}

- (void) resetViewOrigins
{
  int padding = 20;
  float height = (loginButton.frame.origin.y + 
    loginButton.frame.size.height + padding + 50);
  [UIView animateWithDuration: 0.25 animations: ^{
    self.contentSize = CGSizeMake(self.contentSize.width, height);
  }];  
}

- (void) showFacebookLogin
{
  [[NSNotificationCenter defaultCenter] postNotificationName:
    OMBActivityIndicatorViewStartAnimatingNotification object: nil];
  OMBAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
  [appDelegate openSession];
}

- (void) signUp
{
  if ([_nameTextField.text length] > 0 && [emailTextField.text length] > 0 && 
    [passwordTextField.text length] > 0) {

    NSDictionary *dictionary = @{
      @"name":     _nameTextField.text,
      @"email":    emailTextField.text,
      @"password": passwordTextField.text
    };
    OMBSignUpConnection *connection = 
      [[OMBSignUpConnection alloc] initWithParameters: dictionary];
    connection.completionBlock = ^(NSError *error) {
      // User signed up
      if ([OMBUser currentUser].accessToken)
        [self hideIntro];
      // User failed to sign up
      else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle: 
          @"Sign up failed" message: @"Please try again" delegate: nil
            cancelButtonTitle: @"Try again" otherButtonTitles: nil];
        [alertView show];
      }
      [self stopSpinning];
    };
    [self startSpinning];
    [connection start];
  }
  [self endEditing: YES];
  [self resetViewOrigins];
}

- (void) startSpinning
{
  [activityIndicatorView startAnimating];
}

- (void) stopSpinning
{
  [activityIndicatorView stopAnimating];
}


@end
