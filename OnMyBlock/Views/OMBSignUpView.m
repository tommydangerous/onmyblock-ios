//
//  OMBSignUpView.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 11/8/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBSignUpView.h"

#import "OMBAppDelegate.h"
#import "OMBIntroStillImagesViewController.h"
#import "OMBLoginConnection.h"
#import "OMBLoginViewController.h"
#import "OMBSignUpConnection.h"
#import "OMBViewControllerContainer.h"
#import "TextFieldPadding.h"
#import "UIColor+Extensions.h"
#import "UIImage+Color.h"
#import "UIImage+Resize.h"

@implementation OMBSignUpView

@synthesize emailTextField     = _emailTextField;
@synthesize facebookButton     = _facebookButton;
@synthesize firstNameTextField = _firstNameTextField;
@synthesize lastNameTextField  = _lastNameTextField;
@synthesize loginButton        = _loginButton;
@synthesize passwordTextField  = _passwordTextField;

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

  CGRect screen     = [[UIScreen mainScreen] bounds];
  float screenWidth = screen.size.width;

  self.frame = screen;

  scroll = [[UIScrollView alloc] init];
  scroll.alwaysBounceVertical = YES;
  scroll.frame                = self.frame;
  scroll.showsVerticalScrollIndicator = NO;
  [self addSubview: scroll];

  int padding = 20;

  // Facebook button
  _facebookButton = [[UIButton alloc] init];
  _facebookButton.backgroundColor = [UIColor facebookBlue];
  _facebookButton.clipsToBounds = YES;
  _facebookButton.frame = CGRectMake((padding + screenWidth), (padding * 3), 
    (screen.size.width - (padding * 2)), 
      ((padding / 2.0) + 30 + (padding / 2.0)));
  _facebookButton.layer.cornerRadius = 2.0;
  _facebookButton.titleLabel.font = 
    [UIFont fontWithName: @"HelveticaNeue-Medium" size: 15];
  [_facebookButton addTarget: self action: @selector(showFacebookLogin)
    forControlEvents: UIControlEventTouchUpInside];
  [_facebookButton setTitle: @"Sign up using Facebook" 
    forState: UIControlStateNormal];
  [_facebookButton setBackgroundImage: 
    [UIImage imageWithColor: [UIColor facebookBlueDark]] 
      forState: UIControlStateHighlighted];
  [scroll addSubview: _facebookButton];
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
  [scroll addSubview: orView];
  UILabel *orLabel = [[UILabel alloc] init];
  orLabel.font = [UIFont fontWithName: @"HelveticaNeue-Medium" size: 18];
  orLabel.frame = CGRectMake(0, 0, orView.frame.size.width, 
    orView.frame.size.height);
  orLabel.text = @"OR";
  orLabel.textAlignment = NSTextAlignmentCenter;
  orLabel.textColor = [UIColor textColor];
  [orView addSubview: orLabel];
  CALayer *leftLine         = [CALayer layer];
  CALayer *rightLine        = [CALayer layer]; 
  leftLine.backgroundColor  = orLabel.textColor.CGColor;
  rightLine.backgroundColor = leftLine.backgroundColor;
  leftLine.frame = CGRectMake((padding * 2), (orView.frame.size.height / 2.0), 
    (_facebookButton.frame.size.width * 0.3), 0.5);
  rightLine.frame = CGRectMake(
    (screen.size.width - (leftLine.frame.origin.x + 
      leftLine.frame.size.width)), leftLine.frame.origin.y, 
        leftLine.frame.size.width, leftLine.frame.size.height);
  [orView.layer addSublayer: leftLine];
  [orView.layer addSublayer: rightLine];

  // First name
  _firstNameTextField = [[TextFieldPadding alloc] init];
  _firstNameTextField.autocorrectionType = UITextAutocorrectionTypeNo;
  _firstNameTextField.backgroundColor = [UIColor whiteColor];
  _firstNameTextField.delegate = self;
  _firstNameTextField.font = [UIFont fontWithName: @"HelveticaNeue-Light"
    size: 15];
  _firstNameTextField.frame = CGRectMake(_facebookButton.frame.origin.x, 
    (orView.frame.origin.y + orView.frame.size.height + padding),
      (screen.size.width - (padding * 2)), 
        ((padding / 2.0) + 24 + (padding / 2.0)));
  _firstNameTextField.layer.borderColor = [UIColor grayLight].CGColor;
  _firstNameTextField.layer.borderWidth = 1.0;
  _firstNameTextField.paddingX = padding / 2.0;
  _firstNameTextField.paddingY = padding / 2.0;
  _firstNameTextField.placeholder = @"First name";
  _firstNameTextField.returnKeyType = UIReturnKeyDone;
  [scroll addSubview: _firstNameTextField];

  // Last name
  _lastNameTextField = [[TextFieldPadding alloc] init];
  _lastNameTextField.autocorrectionType = 
    _firstNameTextField.autocorrectionType;
  _lastNameTextField.backgroundColor = _firstNameTextField.backgroundColor;
  _lastNameTextField.delegate = self;
  _lastNameTextField.font = _firstNameTextField.font;
  _lastNameTextField.frame = CGRectMake(_firstNameTextField.frame.origin.x,
    (_firstNameTextField.frame.origin.y + 
    _firstNameTextField.frame.size.height + padding),
      _firstNameTextField.frame.size.width, 
        _firstNameTextField.frame.size.height);
  _lastNameTextField.layer.borderColor = _firstNameTextField.layer.borderColor;
  _lastNameTextField.layer.borderWidth = _firstNameTextField.layer.borderWidth;
  _lastNameTextField.paddingX = _firstNameTextField.paddingX;
  _lastNameTextField.paddingY = _firstNameTextField.paddingY;
  _lastNameTextField.placeholder = @"Last name";
  _lastNameTextField.returnKeyType = _firstNameTextField.returnKeyType;
  [scroll addSubview: _lastNameTextField];

  // Email
  _emailTextField = [[TextFieldPadding alloc] init];
  _emailTextField.autocapitalizationType = 
    _firstNameTextField.autocapitalizationType;
  _emailTextField.autocorrectionType = 
    _firstNameTextField.autocorrectionType;
  _emailTextField.backgroundColor = _firstNameTextField.backgroundColor;
  _emailTextField.delegate = self;
  _emailTextField.font = _firstNameTextField.font;
  _emailTextField.frame = CGRectMake(_lastNameTextField.frame.origin.x,
    (_lastNameTextField.frame.origin.y + _lastNameTextField.frame.size.height + 
      padding), _lastNameTextField.frame.size.width, 
        _lastNameTextField.frame.size.height);
  _emailTextField.keyboardType = UIKeyboardTypeEmailAddress;
  _emailTextField.layer.borderColor = _firstNameTextField.layer.borderColor;
  _emailTextField.layer.borderWidth = _firstNameTextField.layer.borderWidth;
  _emailTextField.paddingX = _firstNameTextField.paddingX;
  _emailTextField.paddingY = _firstNameTextField.paddingY;
  _emailTextField.placeholder = @"Email";
  _emailTextField.returnKeyType = _firstNameTextField.returnKeyType;
  [scroll addSubview: _emailTextField];

  // Password
  _passwordTextField = [[TextFieldPadding alloc] init];
  _passwordTextField.autocapitalizationType = 
    _emailTextField.autocapitalizationType;
  _passwordTextField.autocorrectionType = _emailTextField.autocorrectionType;
  _passwordTextField.backgroundColor = _emailTextField.backgroundColor;
  _passwordTextField.delegate = self;
  _passwordTextField.font = _emailTextField.font;
  _passwordTextField.frame = CGRectMake(_emailTextField.frame.origin.x,
    (_emailTextField.frame.origin.y + _emailTextField.frame.size.height + 
      padding), _emailTextField.frame.size.width, 
        _emailTextField.frame.size.height);
  _passwordTextField.layer.borderColor = _emailTextField.layer.borderColor;
  _passwordTextField.layer.borderWidth = _emailTextField.layer.borderWidth;
  _passwordTextField.paddingX = _emailTextField.paddingX;
  _passwordTextField.paddingY = _emailTextField.paddingY;
  _passwordTextField.placeholder = @"Password";
  _passwordTextField.returnKeyType = _emailTextField.returnKeyType;
  _passwordTextField.secureTextEntry = YES;  
  [scroll addSubview: _passwordTextField];

  _loginButton = [[UIButton alloc] init];
  _loginButton.backgroundColor = [UIColor blue];
  _loginButton.clipsToBounds = YES;
  _loginButton.frame = CGRectMake(_facebookButton.frame.origin.x,
    (_passwordTextField.frame.origin.y + _passwordTextField.frame.size.height +
      padding), _facebookButton.frame.size.width, 
        _facebookButton.frame.size.height);
  _loginButton.titleLabel.font = _facebookButton.titleLabel.font;
  _loginButton.layer.cornerRadius = 2.0;
  [_loginButton addTarget: self action: @selector(loginOrSignUp)
    forControlEvents: UIControlEventTouchUpInside];
  [_loginButton setTitle: @"Sign up" forState: UIControlStateNormal];
  [_loginButton setBackgroundImage: [UIImage imageWithColor: [UIColor blueDark]]
    forState: UIControlStateHighlighted];
  [scroll addSubview: _loginButton];

  UIFont *font = [UIFont fontWithName: @"HelveticaNeue-Light" size: 15];
  // Sign up switch button
  // attributed string
  NSMutableAttributedString *newUserString = 
    [[NSMutableAttributedString alloc] initWithString: @"New user? " 
      attributes: @{ NSForegroundColorAttributeName: [UIColor grayMedium] }];
  NSAttributedString *signUpString = [[NSAttributedString alloc] initWithString:
    @"Sign up" attributes: @{ NSForegroundColorAttributeName: [UIColor blue] }];
  [newUserString appendAttributedString: signUpString];
  // button
  signUpSwitchButton = [[UIButton alloc] init];
  CGRect signUpSwitchButtonRect = [@"New user? Sign up" boundingRectWithSize:
    CGSizeMake(_facebookButton.frame.size.width, 
    _facebookButton.frame.size.height)
      options: NSStringDrawingUsesLineFragmentOrigin
        attributes: @{ NSFontAttributeName: font }
          context: nil];
  signUpSwitchButton.alpha = 0.0;
  signUpSwitchButton.frame = CGRectMake(
    (screenWidth - (signUpSwitchButtonRect.size.width + padding)), 
      (_loginButton.frame.origin.y + _loginButton.frame.size.height + padding), 
        signUpSwitchButtonRect.size.width, signUpSwitchButtonRect.size.height);
  signUpSwitchButton.titleLabel.font = font;
  [signUpSwitchButton addTarget: self action: @selector(showSignUp)
    forControlEvents: UIControlEventTouchUpInside];
  [signUpSwitchButton setAttributedTitle: newUserString 
    forState: UIControlStateNormal];
  [scroll addSubview: signUpSwitchButton];

  // Login switch button
  // attributed string
  NSMutableAttributedString *alreadyString = 
    [[NSMutableAttributedString alloc] initWithString: @"Already a user? "
      attributes: @{ NSForegroundColorAttributeName: [UIColor grayMedium] }];
  NSAttributedString *loginString = [[NSAttributedString alloc] initWithString:
    @"Login" attributes: @{ NSForegroundColorAttributeName: [UIColor blue] }];
  [alreadyString appendAttributedString: loginString];
  // button
  loginSwitchButton = [[UIButton alloc] init];
  CGRect loginButtonRect = [@"Already a user? Login" boundingRectWithSize:
    CGSizeMake(_facebookButton.frame.size.width, 
    _facebookButton.frame.size.height)
      options: NSStringDrawingUsesLineFragmentOrigin
        attributes: @{ NSFontAttributeName: font }
          context: nil];
  loginSwitchButton.alpha = signUpSwitchButton.alpha;
  loginSwitchButton.frame = CGRectMake(
    (screenWidth - (loginButtonRect.size.width + padding)), 
      signUpSwitchButton.frame.origin.y, 
        loginButtonRect.size.width, loginButtonRect.size.height);
  loginSwitchButton.titleLabel.font = signUpSwitchButton.titleLabel.font;
  [loginSwitchButton addTarget: self action: @selector(showLogin)
    forControlEvents: UIControlEventTouchUpInside];
  [loginSwitchButton setAttributedTitle: alreadyString
    forState: UIControlStateNormal];
  [scroll addSubview: loginSwitchButton];

  [self updateScrollContentSize];

  return self;
}

#pragma mark - Protocol

#pragma mark - Protocol UITextFieldDelegate

- (void) textFieldDidBeginEditing: (UITextField *) textField
{
  // If it lags, that is because the 1st time the keyboard loads it lags
  int padding = 20;
  // Don't add 50 here because the height of the keyboard (216) covers the 50
  float height = (loginSwitchButton.frame.origin.y + 
    loginSwitchButton.frame.size.height + padding + 216);
  float y = height - 
    (20 + scroll.frame.size.height + 20 + 
      _loginButton.frame.size.height + 20 + 
        loginSwitchButton.frame.size.height);
  if (y < 0)
    y = 0;
  CGPoint point = CGPointMake(scroll.contentOffset.x, y);
  [UIView animateWithDuration: 0.25 animations: ^{
    scroll.contentOffset = point;
  } completion: ^(BOOL finished) {
    scroll.contentSize = CGSizeMake(scroll.contentSize.width, height);
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

- (void) clearTextFieldText
{
  _emailTextField.text     = @"";
  _firstNameTextField.text = @"";
  _lastNameTextField.text  = @"";
  _passwordTextField.text  = @"";
}

- (CGFloat) heightForScrollContentSize
{
  CGFloat height = 0;
  int padding    = 20;
  if (loginSwitchButton.alpha == 1.0 || signUpSwitchButton.alpha == 1.0)
    height = (loginSwitchButton.frame.origin.y + 
      loginSwitchButton.frame.size.height + padding);
  else
    height = (_loginButton.frame.origin.y + 
      _loginButton.frame.size.height + padding);
  return height;
}

- (void) login
{
  if ([_emailTextField.text length] > 0 && 
    [_passwordTextField.text length] > 0) {

    NSDictionary *dictionary = @{
      @"email":    _emailTextField.text,
      @"password": _passwordTextField.text
    };
    OMBLoginConnection *connection = 
      [[OMBLoginConnection alloc] initWithParameters: dictionary];
    connection.completionBlock = ^(NSError *error) {
      // User logged in
      if ([OMBUser currentUser].accessToken)
        [self clearTextFieldText];
      // User failed to login
      else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle: 
          @"Login failed" message: @"Invalid email or password" delegate: nil
            cancelButtonTitle: @"Try again" otherButtonTitles: nil];
        [alertView show];
        _passwordTextField.text = @"";
      }
      [self stopSpinning];
    };
    [self startSpinning];
    [connection start];
  }
  [self endEditing: YES];
  [UIView animateWithDuration: 0.25 animations: ^{
    [self updateScrollContentSize];
  }];
}

- (void) loginOrSignUp
{
  if (_firstNameTextField.alpha < 1)
    [self login];
  else
    [self signUp];
}

- (void) resetOriginX
{
  int padding = 20;

  CGRect rect1          = _facebookButton.frame;
  rect1.origin.x        = padding;
  _facebookButton.frame = rect1;

  CGRect rect2              = _firstNameTextField.frame;
  rect2.origin.x            = padding;
  _firstNameTextField.frame = rect2;

  CGRect rect3             = _lastNameTextField.frame;
  rect3.origin.x           = padding;
  _lastNameTextField.frame = rect3;

  CGRect rect4          = _emailTextField.frame;
  rect4.origin.x        = padding;
  _emailTextField.frame = rect4;

  CGRect rect5             = _passwordTextField.frame;
  rect5.origin.x           = padding;
  _passwordTextField.frame = rect5;

  CGRect rect6       = _loginButton.frame;
  rect6.origin.x     = padding;
  _loginButton.frame = rect6;
}

- (void) resetOriginY
{
  // int padding = 20;
  // height of the close button on the login view controller
  float difference = -1 * 25;
  // float difference = _facebookButton.frame.origin.y - padding;

  CGRect rect1          = _facebookButton.frame;
  rect1.origin.y        -= difference;
  _facebookButton.frame = rect1;

  CGRect rect2              = _firstNameTextField.frame;
  rect2.origin.y            -= difference;
  _firstNameTextField.frame = rect2;

  CGRect rect3             = _lastNameTextField.frame;
  rect3.origin.y           -= difference;
  _lastNameTextField.frame = rect3;

  CGRect rect4          = _emailTextField.frame;
  rect4.origin.y        -= difference;
  _emailTextField.frame = rect4;

  CGRect rect5             = _passwordTextField.frame;
  rect5.origin.y           -= difference;
  _passwordTextField.frame = rect5;

  CGRect rect6       = _loginButton.frame;
  rect6.origin.y     -= difference;
  _loginButton.frame = rect6;

  CGRect rect7   = orView.frame;
  rect7.origin.y -= difference;
  orView.frame   = rect7;

  CGRect rect8            = loginSwitchButton.frame;
  rect8.origin.y          -= difference;
  loginSwitchButton.frame = rect8;

  CGRect rect9             = signUpSwitchButton.frame;
  rect9.origin.y           -= difference;
  signUpSwitchButton.frame = rect9;
}

- (void) resetViewOrigins
{
  [UIView animateWithDuration: 0.25 animations: ^{
    scroll.contentSize = CGSizeMake(scroll.contentSize.width, 
      [self heightForScrollContentSize]);
  }];  
}

- (void) showFacebookLogin
{
  [[NSNotificationCenter defaultCenter] postNotificationName:
    OMBActivityIndicatorViewStartAnimatingNotification object: nil];
  OMBAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
  [appDelegate openSession];
}

- (void) showLogin
{
  [UIView animateWithDuration: 0.25 animations: ^{
    loginSwitchButton.alpha  = 0.0;
    signUpSwitchButton.alpha = 1.0;
    [_facebookButton setTitle: @"Login using Facebook" 
      forState: UIControlStateNormal];
    [_loginButton setTitle: @"Login" forState: UIControlStateNormal];
  }];
  if (_firstNameTextField.alpha == 1) {
    float y = (_firstNameTextField.frame.size.height + 20) * -1;
    // Cover the space for first name and last name field
    y *= 2;
    CGRect emailTextFieldFrame      = _emailTextField.frame;
    emailTextFieldFrame.origin.y    = emailTextFieldFrame.origin.y + y;
    CGRect passwordTextFieldFrame   = _passwordTextField.frame;
    passwordTextFieldFrame.origin.y = passwordTextFieldFrame.origin.y + y;
    CGRect loginButtonFrame         = _loginButton.frame;
    loginButtonFrame.origin.y       = loginButtonFrame.origin.y + y;
    CGRect loginSwitchRect    = loginSwitchButton.frame;
    loginSwitchRect.origin.y  = loginSwitchRect.origin.y + y;
    CGRect signUpSwitchRect   = signUpSwitchButton.frame;
    signUpSwitchRect.origin.y = signUpSwitchRect.origin.y + y;
    [UIView animateWithDuration: 0.25 animations: ^{
      _firstNameTextField.alpha = 0.0;
      _lastNameTextField.alpha  = 0.0;
      _emailTextField.frame    = emailTextFieldFrame;
      _passwordTextField.frame = passwordTextFieldFrame;
      _loginButton.frame       = loginButtonFrame;
      loginSwitchButton.frame  = loginSwitchRect;
      signUpSwitchButton.frame = signUpSwitchRect;
    }];
  }
  [self endEditing: YES];
  [self updateScrollContentSize];
}

- (void) showSignUp
{
  [UIView animateWithDuration: 0.25 animations: ^{
    loginSwitchButton.alpha  = 1.0;
    signUpSwitchButton.alpha = 0.0;
    [_facebookButton setTitle: @"Sign up using Facebook" 
      forState: UIControlStateNormal];
    [_loginButton setTitle: @"Sign up" forState: UIControlStateNormal];
  }];
  if (_firstNameTextField.alpha == 0) {
    float y = (_firstNameTextField.frame.size.height + 20) * 1;
    // Cover the space for first name and last name field
    y *= 2;
    CGRect emailTextFieldFrame      = _emailTextField.frame;
    emailTextFieldFrame.origin.y    = emailTextFieldFrame.origin.y + y;
    CGRect passwordTextFieldFrame   = _passwordTextField.frame;
    passwordTextFieldFrame.origin.y = passwordTextFieldFrame.origin.y + y;
    CGRect loginButtonFrame         = _loginButton.frame;
    loginButtonFrame.origin.y       = loginButtonFrame.origin.y + y;
    CGRect loginSwitchRect    = loginSwitchButton.frame;
    loginSwitchRect.origin.y  = loginSwitchRect.origin.y + y;
    CGRect signUpSwitchRect   = signUpSwitchButton.frame;
    signUpSwitchRect.origin.y = signUpSwitchRect.origin.y + y;
    [UIView animateWithDuration: 0.25 animations: ^{
      _firstNameTextField.alpha = 1.0;
      _lastNameTextField.alpha  = 1.0;
      _emailTextField.frame    = emailTextFieldFrame;
      _passwordTextField.frame = passwordTextFieldFrame;
      _loginButton.frame       = loginButtonFrame;
      loginSwitchButton.frame  = loginSwitchRect;
      signUpSwitchButton.frame = signUpSwitchRect;
    }];
  }
  [self endEditing: YES];
  [self updateScrollContentSize];
}

- (void) signUp
{
  if ([_emailTextField.text length] > 0 && 
      [_firstNameTextField.text length] > 0 && 
      [_lastNameTextField.text length] > 0 &&
      [_passwordTextField.text length] > 0) {

    NSDictionary *dictionary = @{
      @"email":      _emailTextField.text,
      @"first_name": _firstNameTextField.text,
      @"last_name":  _lastNameTextField.text,
      @"password":   _passwordTextField.text
    };
    OMBSignUpConnection *connection = 
      [[OMBSignUpConnection alloc] initWithParameters: dictionary];
    connection.completionBlock = ^(NSError *error) {
      // User signed up
      if ([OMBUser currentUser].accessToken)
        [self clearTextFieldText];      
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
  OMBAppDelegate *appDelegate = (OMBAppDelegate *) 
    [UIApplication sharedApplication].delegate;
  // Container -> login view controller spinner
  [appDelegate.container.loginViewController.activityIndicatorView 
    startAnimating];
  // Container -> intro view controller spinner
  [appDelegate.container.introViewController.activityIndicatorView 
    startAnimating];
  // Container -> intro view controller -> login view controller spinner
  [appDelegate.container.introViewController.loginViewController.activityIndicatorView startAnimating];
  NSLog(@"START SPINNING");
}

- (void) stopSpinning
{
  OMBAppDelegate *appDelegate = (OMBAppDelegate *) 
    [UIApplication sharedApplication].delegate;
  // Container -> login view controller spinner
  [appDelegate.container.loginViewController.activityIndicatorView 
    stopAnimating];
  // Container -> intro view controller spinner
  [appDelegate.container.introViewController.activityIndicatorView 
    stopAnimating];
  // Container -> intro view controller -> login view controller spinner
  [appDelegate.container.introViewController.loginViewController.activityIndicatorView stopAnimating];
  NSLog(@"STOP SPINNING");
}

- (void) updateScrollContentSize
{
  CGRect screen = [[UIScreen mainScreen] bounds];
  scroll.contentSize = CGSizeMake(screen.size.width, 
    [self heightForScrollContentSize]);
}

@end
