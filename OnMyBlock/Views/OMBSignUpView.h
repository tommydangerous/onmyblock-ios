//
//  OMBSignUpView.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 11/8/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TextFieldPadding;

@interface OMBSignUpView : UIView <UITextFieldDelegate>
{
  UIButton *loginSwitchButton;
  UIView *orView;
  UIScrollView *scroll;
  UIButton *signUpSwitchButton;
}

@property (nonatomic, strong) TextFieldPadding *emailTextField;
@property (nonatomic, strong) UIButton *facebookButton;
@property (nonatomic, strong) TextFieldPadding *firstNameTextField;
@property (nonatomic, strong) TextFieldPadding *lastNameTextField;
@property (nonatomic, strong) UIButton *loginButton;
@property (nonatomic, strong) TextFieldPadding *passwordTextField;

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) login;
- (void) resetOriginX;
- (void) resetOriginY;
- (void) resetViewOrigins;
- (void) showLogin;
- (void) showSignUp;
- (void) signUp;
- (void) updateScrollContentSize;

@end
