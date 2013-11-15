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

  [[NSNotificationCenter defaultCenter] addObserver: self
    selector: @selector(startSpinning) 
      name: OMBActivityIndicatorViewStartAnimatingNotification object: nil];
  [[NSNotificationCenter defaultCenter] addObserver: self
    selector: @selector(stopSpinning) 
      name: OMBActivityIndicatorViewStopAnimatingNotification object: nil];

  self.edgesForExtendedLayout = 
    (UIRectEdgeBottom | UIRectEdgeLeft | UIRectEdgeRight);
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

  int padding = 20;

  // Navigation item
  // Left bar button item
  self.navigationItem.leftBarButtonItem = 
    [[UIBarButtonItem alloc] initWithTitle: @"Close" 
      style: UIBarButtonItemStylePlain target: self action: @selector(close)];
  // Right bar button item
  loginBarButtonItem = [[UIBarButtonItem alloc] initWithTitle: @"Login" 
    style: UIBarButtonItemStylePlain target: self 
      action: @selector(showLogin)];
  signUpBarButtonItem = [[UIBarButtonItem alloc] initWithTitle: @"Sign up" 
    style: UIBarButtonItemStylePlain target: self 
      action: @selector(showSignUp)];
  self.navigationItem.rightBarButtonItem = signUpBarButtonItem;

  scroll = [[UIScrollView alloc] init];
  scroll.alwaysBounceVertical = YES;
  scroll.frame = screen;
  scroll.showsVerticalScrollIndicator = NO;
  [self.view addSubview: scroll];
    
  // Facebook button
  facebookButton = [[UIButton alloc] init];
  facebookButton.backgroundColor = [UIColor facebookBlue];
  facebookButton.clipsToBounds = YES;
  facebookButton.frame = CGRectMake(padding, padding, 
    (screen.size.width - (padding * 2)), 
      ((padding / 2.0) + 30 + (padding / 2.0)));
  facebookButton.layer.cornerRadius = 2.0;
  facebookButton.titleLabel.font = [UIFont fontWithName: @"HelveticaNeue-Medium"
    size: 15];
  [facebookButton addTarget: self action: @selector(showFacebookLogin)
    forControlEvents: UIControlEventTouchUpInside];
  [facebookButton setTitle: @"Login using Facebook" 
    forState: UIControlStateNormal];
  [facebookButton setBackgroundImage: 
    [UIImage imageWithColor: [UIColor facebookBlueDark]] 
      forState: UIControlStateHighlighted];
  [scroll addSubview: facebookButton];
  UIImageView *facebookImageView = [[UIImageView alloc] init];
  facebookImageView.frame = CGRectMake((padding / 2.0), (padding / 2.0), 
    30, 30);
  facebookImageView.image = [UIImage image: 
    [UIImage imageNamed: @"facebook_icon.png"] size: CGSizeMake(30, 30)];
  [facebookButton addSubview: facebookImageView];

  orView = [[UIView alloc] init];  
  orView.frame = CGRectMake(0, (facebookButton.frame.origin.y + 
    facebookButton.frame.size.height + padding), screen.size.width, 
      facebookButton.frame.size.height);
  [scroll addSubview: orView];
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
  leftLine.frame = CGRectMake(facebookButton.frame.origin.x, 
    (orView.frame.size.height / 2.0), 
      (facebookButton.frame.size.width * 0.4), 0.5);
  rightLine.frame = CGRectMake(
    (screen.size.width - (leftLine.frame.origin.x + 
      leftLine.frame.size.width)), leftLine.frame.origin.y, 
        leftLine.frame.size.width, leftLine.frame.size.height);
  [orView.layer addSublayer: leftLine];
  [orView.layer addSublayer: rightLine];

  // Name
  nameTextField = [[TextFieldPadding alloc] init];
  nameTextField.alpha = 0.0;
  nameTextField.autocorrectionType = UITextAutocorrectionTypeNo;
  nameTextField.backgroundColor = [UIColor whiteColor];
  nameTextField.delegate = self;
  nameTextField.font = [UIFont fontWithName: @"HelveticaNeue-Light"
    size: 15];
  nameTextField.frame = CGRectMake(padding, (orView.frame.origin.y +
    orView.frame.size.height + padding),
      (screen.size.width - (padding * 2)), 
        ((padding / 2.0) + 22 + (padding / 2.0)));
  nameTextField.layer.borderColor = [UIColor grayLight].CGColor;
  nameTextField.layer.borderWidth = 1.0;
  nameTextField.paddingX = padding / 2.0;
  nameTextField.paddingY = padding / 2.0;
  nameTextField.placeholder = @"Name";
  nameTextField.returnKeyType = UIReturnKeyDone;
  UIView *nameRightView = [[UIView alloc] init];
  nameRightView.alpha = 0.3;
  nameRightView.frame = CGRectMake(0, 0, (22 + (padding / 2.0)), 22);
  nameTextField.rightView = nameRightView;
  nameTextField.rightViewMode = UITextFieldViewModeAlways;
  UIImageView *nameImageView = [[UIImageView alloc] init];
  nameImageView.frame = CGRectMake(0, 0, 22, 22);
  nameImageView.image = [UIImage image: [UIImage imageNamed: @"user_icon.png"]
    size: nameImageView.frame.size];
  [nameRightView addSubview: nameImageView];
  [scroll addSubview: nameTextField];

  // Email
  emailTextField = [[TextFieldPadding alloc] init];
  emailTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
  emailTextField.autocorrectionType = UITextAutocorrectionTypeNo;
  emailTextField.backgroundColor = [UIColor whiteColor];
  emailTextField.delegate = self;
  emailTextField.font = [UIFont fontWithName: @"HelveticaNeue-Light"
    size: 15];
  emailTextField.frame = nameTextField.frame;
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
  [scroll addSubview: emailTextField];

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
  [scroll addSubview: passwordTextField];

  loginButton = [[UIButton alloc] init];
  loginButton.backgroundColor = [UIColor blue];
  loginButton.clipsToBounds = YES;
  loginButton.frame = CGRectMake(facebookButton.frame.origin.x,
    (passwordTextField.frame.origin.y + passwordTextField.frame.size.height +
      padding), facebookButton.frame.size.width, 
        facebookButton.frame.size.height);
  loginButton.titleLabel.font = facebookButton.titleLabel.font;
  loginButton.layer.cornerRadius = 2.0;
  [loginButton addTarget: self action: @selector(loginOrSignUp)
    forControlEvents: UIControlEventTouchUpInside];
  [loginButton setTitle: @"LOGIN" forState: UIControlStateNormal];
  [loginButton setBackgroundImage: [UIImage imageWithColor: [UIColor blueDark]]
    forState: UIControlStateHighlighted];
  [scroll addSubview: loginButton];

  activityIndicatorView = 
    [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: 
      UIActivityIndicatorViewStyleWhiteLarge];
  activityIndicatorView.color = [UIColor grayDark];
  activityIndicatorView.frame = CGRectMake(((screen.size.width - 60) / 2.0),
    ((screen.size.height - (20 + 40 + 60)) / 2.0), 60, 60);
  [self.view addSubview: activityIndicatorView];

  [self updateScrollContentSize];
}

- (void) viewWillAppear: (BOOL) animated
{
  [self updateScrollContentSize];
}

#pragma mark - Protocol

#pragma mark - Protocol UITextFieldDelegate

- (void) textFieldDidBeginEditing: (UITextField *) textField
{
  // Height of the new content size should be where the login button is
  // plus padding plus keyboard height of 216
  float height = (20 + 40 + loginButton.frame.origin.y + 
    loginButton.frame.size.height + 20 + 216);
  // Scroll near to the bottom
  float y = height - 
    (20 + scroll.frame.size.height + loginButton.frame.size.height);
  if (y < 0)
    y = 0;
  CGPoint point = CGPointMake(scroll.contentOffset.x, y);  
  [UIView animateWithDuration: 0.25 animations: ^{
      scroll.contentOffset = point;
    } completion: ^(BOOL finished) {
      scroll.contentSize = CGSizeMake(scroll.contentSize.width, height);
    }
  ];
}

- (BOOL) textFieldShouldReturn: (UITextField *) textField
{
  [textField resignFirstResponder];
  [UIView animateWithDuration: 0.25 animations: ^{
    [self updateScrollContentSize];
  }];
  return YES;
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) close
{
  OMBAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
  [appDelegate.introViewController dismissViewControllerAnimated: YES
    completion: nil];
}

- (void) hideLoginAndIntro
{
  OMBAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
  [self dismissViewControllerAnimated: YES
    completion: ^{
      [appDelegate.introViewController dismissViewControllerAnimated: YES
        completion: nil];
    }
  ];
  emailTextField.text    = @"";
  nameTextField.text     = @"";
  passwordTextField.text = @"";
}

- (void) login
{
  if ([emailTextField.text length] > 0 && [passwordTextField.text length] > 0) {
    NSDictionary *dictionary = @{
      @"email":    emailTextField.text,
      @"password": passwordTextField.text
    };
    OMBLoginConnection *connection = 
      [[OMBLoginConnection alloc] initWithParameters: dictionary];
    connection.completionBlock = ^(NSError *error) {
      // User logged in
      if ([OMBUser currentUser].accessToken)
        [self hideLoginAndIntro];
      // User failed to login
      else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle: 
          @"Login failed" message: @"Invalid email or password" delegate: nil
            cancelButtonTitle: @"Try again" otherButtonTitles: nil];
        [alertView show];
        passwordTextField.text = @"";
      }
      [self stopSpinning];    
    };
    [self startSpinning];
    [connection start];
  }
  [self.view endEditing: YES];
  [UIView animateWithDuration: 0.25 animations: ^{
    [self updateScrollContentSize];
  }];
}

- (void) loginOrSignUp
{
  if (nameTextField.alpha == 0)
    [self login];
  else
    [self signUp];
}

- (void) moveViewsToPoint: (CGPoint) point
{
  float y = point.y;
  CGRect facebookButtonFrame      = facebookButton.frame;
  facebookButtonFrame.origin.y    = facebookButtonFrame.origin.y + y;
  CGRect orViewFrame              = orView.frame;
  orViewFrame.origin.y            = orViewFrame.origin.y + y;
  CGRect nameTextFieldFrame       = nameTextField.frame;
  nameTextFieldFrame.origin.y     = nameTextFieldFrame.origin.y + y;
  CGRect emailTextFieldFrame      = emailTextField.frame;
  emailTextFieldFrame.origin.y    = emailTextFieldFrame.origin.y + y;
  CGRect passwordTextFieldFrame   = passwordTextField.frame;
  passwordTextFieldFrame.origin.y = passwordTextFieldFrame.origin.y + y;
  CGRect loginButtonFrame         = loginButton.frame;
  loginButtonFrame.origin.y       = loginButtonFrame.origin.y + y;
  [UIView animateWithDuration: 0.25 delay: 0 
    options: UIViewAnimationOptionCurveEaseInOut animations: ^{
      facebookButton.frame    = facebookButtonFrame;
      orView.frame            = orViewFrame;
      nameTextField.frame     = nameTextFieldFrame;
      emailTextField.frame    = emailTextFieldFrame;
      passwordTextField.frame = passwordTextFieldFrame;
      loginButton.frame       = loginButtonFrame;
    } completion: nil
  ];
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
  self.title = @"Login";
  [UIView animateWithDuration: 0.25 animations: ^{
    [facebookButton setTitle: @"Login using Facebook" 
      forState: UIControlStateNormal];
    [loginButton setTitle: @"LOGIN" forState: UIControlStateNormal];
  }];
  if (nameTextField.alpha == 1) {
    float y = (nameTextField.frame.size.height + 20) * -1;
    CGRect emailTextFieldFrame      = emailTextField.frame;
    emailTextFieldFrame.origin.y    = emailTextFieldFrame.origin.y + y;
    CGRect passwordTextFieldFrame   = passwordTextField.frame;
    passwordTextFieldFrame.origin.y = passwordTextFieldFrame.origin.y + y;
    CGRect loginButtonFrame         = loginButton.frame;
    loginButtonFrame.origin.y       = loginButtonFrame.origin.y + y;
    [UIView animateWithDuration: 0.25 animations: ^{
      nameTextField.alpha = 0.0;
      emailTextField.frame    = emailTextFieldFrame;
      passwordTextField.frame = passwordTextFieldFrame;
      loginButton.frame       = loginButtonFrame;
    }];
  }
  [self.navigationItem setRightBarButtonItem: signUpBarButtonItem 
    animated: YES];
  [self.view endEditing: YES];
  [self updateScrollContentSize];
}

- (void) showSignUp
{
  self.title = @"Sign up";
  [UIView animateWithDuration: 0.25 animations: ^{
    [facebookButton setTitle: @"Sign up using Facebook" 
      forState: UIControlStateNormal];
    [loginButton setTitle: @"SIGN UP" forState: UIControlStateNormal];
  }];
  if (nameTextField.alpha == 0) {
    float y = nameTextField.frame.size.height + 20;
    CGRect emailTextFieldFrame      = emailTextField.frame;
    emailTextFieldFrame.origin.y    = emailTextFieldFrame.origin.y + y;
    CGRect passwordTextFieldFrame   = passwordTextField.frame;
    passwordTextFieldFrame.origin.y = passwordTextFieldFrame.origin.y + y;
    CGRect loginButtonFrame         = loginButton.frame;
    loginButtonFrame.origin.y       = loginButtonFrame.origin.y + y;
    [UIView animateWithDuration: 0.25 animations: ^{
      nameTextField.alpha = 1.0;
      emailTextField.frame    = emailTextFieldFrame;
      passwordTextField.frame = passwordTextFieldFrame;
      loginButton.frame       = loginButtonFrame;
    }];
  }  
  [self.navigationItem setRightBarButtonItem: loginBarButtonItem animated: YES];
  [self.view endEditing: YES];
  [self updateScrollContentSize];
}

- (void) signUp
{
  if ([nameTextField.text length] > 0 && [emailTextField.text length] > 0 && 
    [passwordTextField.text length] > 0) {

    NSDictionary *dictionary = @{
      @"name":     nameTextField.text,
      @"email":    emailTextField.text,
      @"password": passwordTextField.text
    };
    OMBSignUpConnection *connection = 
      [[OMBSignUpConnection alloc] initWithParameters: dictionary];
    connection.completionBlock = ^(NSError *error) {
      // User signed up
      if ([OMBUser currentUser].accessToken)
        [self hideLoginAndIntro];
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
  [self.view endEditing: YES];
  [UIView animateWithDuration: 0.25 animations: ^{
    [self updateScrollContentSize];
  }];
}

- (void) startSpinning
{
  [activityIndicatorView startAnimating];
}

- (void) stopSpinning
{
  [activityIndicatorView stopAnimating];
}

- (void) updateScrollContentSize
{
  scroll.contentSize = CGSizeMake(scroll.frame.size.width,
    (loginButton.frame.origin.y + loginButton.frame.size.height + 
      20));
}

@end
