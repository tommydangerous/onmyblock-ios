//
//  OMBLoginSignUpView.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 1/30/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBLoginSignUpView.h"

#import "AMBlurView.h"
#import "OMBBlurView.h"
#import "OMBCloseButtonView.h"
#import "OMBViewController.h"
#import "TextFieldPadding.h"
#import "UIColor+Extensions.h"
#import "UIImage+Color.h"

@implementation OMBLoginSignUpView

#pragma mark - Initializer

- (id) init
{
  if (!(self = [super init])) return nil;

  CGRect screen = [[UIScreen mainScreen] bounds];
  CGFloat screenHeight = screen.size.height;
  CGFloat screenWidth  = screen.size.width;
  CGFloat padding      = OMBPadding;
  CGFloat buttonHeight = OMBStandardButtonHeight;
  CGFloat standardHeight = OMBStandardHeight;
  CGFloat width = screenWidth - (padding * 2);

  self.frame = screen;
  // Blur view
  blurView = [[OMBBlurView alloc] initWithFrame: screen];
  blurView.blurRadius = 20.0f;
  blurView.tintColor  = [UIColor colorWithWhite: 0.0f alpha: 0.3f];
  [blurView refreshWithImage: [UIImage imageNamed:
    @"intro_still_image_slide_5_background.jpg"]];
  [self addSubview: blurView];

  // Scroll
  scroll = [[UIScrollView alloc] init];
  scroll.alwaysBounceVertical = YES;
  scroll.backgroundColor = [UIColor clearColor];
  scroll.frame = CGRectMake(0.0f, padding, screenWidth, screenHeight - padding);
  scroll.showsVerticalScrollIndicator = NO;
  [self addSubview: scroll];

  // Close button view
  CGRect closeButtonRect = CGRectMake(screenWidth - (padding + padding),
    padding + padding, padding, padding);
  _closeButtonView = [[OMBCloseButtonView alloc] initWithFrame: closeButtonRect
    color: [UIColor colorWithWhite: 1.0f alpha: 0.8f]];
  [self addSubview: _closeButtonView];

  // Header label
  headerLabel = [UILabel new];
  headerLabel.font = [UIFont mediumTextFontBold];
  headerLabel.frame = CGRectMake(0.0f, padding, screenWidth, padding);
  headerLabel.text = @"Students";
  headerLabel.textColor = [UIColor whiteColor];
  headerLabel.textAlignment = NSTextAlignmentCenter;
  [scroll addSubview: headerLabel];

  // Hold all the text fields
  textFieldView = [[UIView alloc] init];
  textFieldView.backgroundColor = [UIColor colorWithWhite: 1.0f alpha: 0.8f];
  textFieldView.frame = CGRectMake(padding, 
    headerLabel.frame.origin.y + headerLabel.frame.size.height + padding, 
      width, buttonHeight * 4);
  textFieldView.layer.cornerRadius = OMBCornerRadius;
  [scroll addSubview: textFieldView];
  // First name
  _firstNameTextField = [[TextFieldPadding alloc] init];
  _firstNameTextField.autocapitalizationType = 
    UITextAutocapitalizationTypeWords;
  _firstNameTextField.placeholder = @"First name";
  // Last name
  _lastNameTextField = [[TextFieldPadding alloc] init];
  _lastNameTextField.autocapitalizationType = 
    UITextAutocapitalizationTypeWords;
  _lastNameTextField.placeholder = @"Last name";
  // Email
  _emailTextField = [[TextFieldPadding alloc] init];
  _emailTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
  _emailTextField.keyboardType = UIKeyboardTypeEmailAddress;
  _emailTextField.placeholder = @"School email";
  // Password
  _passwordTextField = [[TextFieldPadding alloc] init];
  _passwordTextField.placeholder = @"Password";
  _passwordTextField.secureTextEntry = YES;
  // Images for text field
  NSArray *textFieldImageArray = @[
    @"user_icon.png",
    @"user_icon.png",
    @"messages_icon_dark.png",
    @"password_icon.png"
  ];
  // Set attributes for all text fields
  NSArray *textFieldArray = @[
    _firstNameTextField,
    _lastNameTextField,
    _emailTextField,
    _passwordTextField
  ];
  // Frames for text fields
  textFieldBorderArray = [NSMutableArray array];
  textFieldFrameArray  = [NSMutableArray array];
  for (TextFieldPadding *textField in textFieldArray) {
    NSInteger index = [textFieldArray indexOfObject: textField];
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.delegate = self;
    textField.font = [UIFont normalTextFont];
    textField.frame = CGRectMake(0.0f, index * buttonHeight,
      width, buttonHeight);
    [textFieldFrameArray addObject: [NSValue valueWithCGRect: textField.frame]];
    textField.leftPaddingX = buttonHeight;
    textField.paddingY = 0.0f;
    textField.placeholderColor = [UIColor grayMedium];
    textField.placeholder = textField.placeholder;
    textField.returnKeyType = UIReturnKeyDone;
    textField.rightPaddingX = padding;
    textField.textColor = [UIColor textColor];
    [textFieldView addSubview: textField];
    // Image view
    UIImageView *iv = [UIImageView new];
    iv.alpha = 0.3f;
    iv.frame = CGRectMake(15.0f, 15.0f, 
      textField.frame.size.height - (15.0f * 2),
        textField.frame.size.height - (15.0f * 2));
    iv.image = [UIImage imageNamed: [textFieldImageArray objectAtIndex: index]];
    [textField addSubview: iv];
    // Top border
    if (index > 0) {
      UIView *bor = [UIView new];
      bor.backgroundColor = [UIColor colorWithWhite: 0.0f alpha: 0.3f];
      bor.frame = CGRectMake(0.0f, 0.0f, textField.frame.size.width, 1.0f);
      [textField addSubview: bor];
      [textFieldBorderArray addObject: bor];
    }
  }

  bottomView = [UIView new];
  bottomView.frame = CGRectMake(padding, 
    textFieldView.frame.origin.y + textFieldView.frame.size.height + padding,
      width, buttonHeight + standardHeight);
  [scroll addSubview: bottomView];

  // Action button
  _actionButton = [UIButton new];
  _actionButton.backgroundColor = [UIColor blueAlpha: 0.8f];
  _actionButton.clipsToBounds = YES;
  _actionButton.frame = CGRectMake(0.0f, 0.0f, width, buttonHeight);
  _actionButton.layer.cornerRadius = OMBCornerRadius;
  _actionButton.titleLabel.font = [UIFont mediumTextFontBold];
  [_actionButton setBackgroundImage: [UIImage imageWithColor: 
    [UIColor blueHighlightedAlpha: 0.8f]] forState: UIControlStateHighlighted];
  [_actionButton setTitle: @"Sign Up" forState: UIControlStateNormal];
  [_actionButton setTitleColor: [UIColor whiteColor] 
    forState: UIControlStateNormal];
  [bottomView addSubview: _actionButton];

  // User switch button
  userSwitchButton = [UIButton new];
  userSwitchButton.contentHorizontalAlignment =
    UIControlContentHorizontalAlignmentLeft;
  userSwitchButton.frame = CGRectMake(0.0f, 
    _actionButton.frame.origin.y + _actionButton.frame.size.height,
      bottomView.frame.size.width * 0.5f, standardHeight);
  userSwitchButton.titleLabel.font = [UIFont normalTextFont];
  [userSwitchButton addTarget: self action: @selector(switchUserViews)
    forControlEvents: UIControlEventTouchUpInside];
  [userSwitchButton setTitle: @"Landlord?" forState: UIControlStateNormal];
  [userSwitchButton setTitleColor: [UIColor whiteColor]
    forState: UIControlStateNormal];
  [bottomView addSubview: userSwitchButton];

  // Action switch button
  actionSwitchButton = [UIButton new];
  actionSwitchButton.contentHorizontalAlignment =
    UIControlContentHorizontalAlignmentRight;
  actionSwitchButton.frame = CGRectMake(
    userSwitchButton.frame.origin.x + userSwitchButton.frame.size.width, 
      userSwitchButton.frame.origin.y,
        userSwitchButton.frame.size.width, userSwitchButton.frame.size.height);
  actionSwitchButton.titleLabel.font = userSwitchButton.titleLabel.font;
  [actionSwitchButton addTarget: self action: @selector(switchViews)
    forControlEvents: UIControlEventTouchUpInside];
  [actionSwitchButton setTitle: @"Login" forState: UIControlStateNormal];
  [actionSwitchButton setTitleColor: [UIColor whiteColor] 
    forState: UIControlStateNormal];
  [bottomView addSubview: actionSwitchButton];

  [[NSNotificationCenter defaultCenter] addObserver: self
    selector: @selector(keyboardWillShow:)
      name: UIKeyboardWillShowNotification object: nil];
  [[NSNotificationCenter defaultCenter] addObserver: self
    selector: @selector(keyboardWillHide:)
      name: UIKeyboardWillHideNotification object: nil];

  return self;
}

#pragma mark - Protocol

#pragma mark - Protocol UITextFieldDelegate

- (BOOL) textFieldShouldReturn: (UITextField *) textField
{
  [textField resignFirstResponder];
  return YES;
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (CGFloat) heightForScrollContentSize
{
  CGFloat height  = 0.0f;
  CGFloat padding = OMBPadding;
  height = actionSwitchButton.frame.origin.y + 
    actionSwitchButton.frame.size.height + padding;
  return height;
}

- (void) keyboardWillHide: (NSNotification *) notification
{
  isEditing = NO;
  [self refreshContentSize];
}

- (void) keyboardWillShow: (NSNotification *) notification
{
  isEditing = YES;
  [self refreshContentSize];
}

- (void) refreshContentSize
{
  CGFloat height = bottomView.frame.origin.y + 
    bottomView.frame.size.height + OMBPadding;
  if (isEditing)
    height += OMBKeyboardHeight;
  [UIView animateWithDuration: OMBStandardDuration animations: ^{
    scroll.contentSize = CGSizeMake(scroll.contentSize.width, height);
  }];
}

- (void) switchLogin
{
  isLogin = YES;
  [self updateViews];
}

- (void) switchUserViews
{
  isLandlord = !isLandlord;
  [self updateUserViews];
}

- (void) switchViews
{
  isLogin = !isLogin;
  [self updateViews];
}

- (void) updateUserViews
{
  NSString *actionButtonString;
  // Landlord
  if (isLandlord) {
    headerLabel.text = @"Landlords";
    _emailTextField.placeholder = @"Landlord email";
    if (isLogin)
      actionButtonString = @"Landlord Login";
    else
      actionButtonString = @"Landlord Sign Up";
    [_actionButton setTitle: actionButtonString
      forState: UIControlStateNormal];
    [userSwitchButton setTitle: @"Student?" forState: UIControlStateNormal];
  }
  // Student
  else {
    headerLabel.text = @"Students";
    _emailTextField.placeholder = @"School email";
    if (isLogin)
      actionButtonString = @"Login";
    else
      actionButtonString = @"Sign Up";
    [_actionButton setTitle: actionButtonString
      forState: UIControlStateNormal];
    [userSwitchButton setTitle: @"Landlord?" forState: UIControlStateNormal];
  }
}

- (void) updateViews
{
  // Login
  if (isLogin) {
    [UIView animateWithDuration: OMBStandardDuration animations: ^{
      _firstNameTextField.alpha = 0.0f;
      _lastNameTextField.alpha  = 0.0f;
      // Email
      CGRect rect1 = [[textFieldFrameArray objectAtIndex: 
        OMBLoginSignUpViewTextFieldFirstName] CGRectValue];
      _emailTextField.frame = rect1;
      // Password
      CGRect rect2 = [[textFieldFrameArray objectAtIndex:
        OMBLoginSignUpViewTextFieldLastName] CGRectValue];
      _passwordTextField.frame = rect2;
      // Resize the text field view
      textFieldView.frame = CGRectMake(textFieldView.frame.origin.x, 
        textFieldView.frame.origin.y, textFieldView.bounds.size.width, 
          _emailTextField.frame.size.height * 2);
      // Hide the top borders
      for (NSInteger i = OMBLoginSignUpViewTextFieldLastName;
        i < OMBLoginSignUpViewTextFieldEmail; i++) {
        UIView *v = [textFieldBorderArray objectAtIndex: i];
        v.hidden = YES;
      }
      // Bottom view
      bottomView.frame = CGRectMake(bottomView.frame.origin.x,
        textFieldView.frame.origin.y + textFieldView.frame.size.height + 
        OMBPadding, bottomView.frame.size.width, 
          bottomView.frame.size.height);
    } completion: ^(BOOL finished) {
      if (finished) {
        _firstNameTextField.hidden = YES;
        _lastNameTextField.hidden  = YES;
        // Action button
        if (isLandlord) {
          [_actionButton setTitle: @"Landlord Login" 
            forState: UIControlStateNormal];
        }
        else {
          [_actionButton setTitle: @"Login" 
            forState: UIControlStateNormal];
        }
        // Action switch button
        [actionSwitchButton setTitle: @"Sign up" 
          forState: UIControlStateNormal];
      }
    }];
  }
  // Sign up
  else {
    _firstNameTextField.hidden = NO;
    _lastNameTextField.hidden  = NO;
    [UIView animateWithDuration: OMBStandardDuration animations: ^{
      _firstNameTextField.alpha = 1.0f;
      _lastNameTextField.alpha  = 1.0f;
      // Email
      CGRect rect1 = [[textFieldFrameArray objectAtIndex: 
        OMBLoginSignUpViewTextFieldEmail] CGRectValue];
      _emailTextField.frame = rect1;
      // Password
      CGRect rect2 = [[textFieldFrameArray objectAtIndex:
        OMBLoginSignUpViewTextFieldPassword] CGRectValue];
      _passwordTextField.frame = rect2;
      // Resize the text field view
      textFieldView.frame = CGRectMake(textFieldView.frame.origin.x, 
        textFieldView.frame.origin.y, textFieldView.bounds.size.width, 
          _emailTextField.frame.size.height * 4);
      // Hide the top borders
      for (NSInteger i = OMBLoginSignUpViewTextFieldLastName;
        i < OMBLoginSignUpViewTextFieldEmail; i++) {
        UIView *v = [textFieldBorderArray objectAtIndex: i];
        v.hidden = NO;
      }
      // Bottom view
      bottomView.frame = CGRectMake(bottomView.frame.origin.x,
        textFieldView.frame.origin.y + textFieldView.frame.size.height + 
        OMBPadding, bottomView.frame.size.width, 
          bottomView.frame.size.height);
    } completion: ^(BOOL finished) {
      if (finished) {
        // Action button
        if (isLandlord) {
          [_actionButton setTitle: @"Landlord Sign Up" 
            forState: UIControlStateNormal];
        }
        else {
          [_actionButton setTitle: @"Sign Up" 
            forState: UIControlStateNormal];
        }
        // Action switch button
        [actionSwitchButton setTitle: @"Login" 
          forState: UIControlStateNormal];
      }
    }];
  }
  [self refreshContentSize];
}

@end
