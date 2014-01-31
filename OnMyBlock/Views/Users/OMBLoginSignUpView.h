//
//  OMBLoginSignUpView.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 1/30/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBView.h"

@class AMBlurView;
@class OMBBlurView;
@class OMBCloseButtonView;
@class OMBFacebookButton;
@class OMBOrView;
@class TextFieldPadding;

typedef NS_ENUM(NSInteger, OMBLoginSignUpViewTextField) {
  OMBLoginSignUpViewTextFieldFirstName,
  OMBLoginSignUpViewTextFieldLastName,
  OMBLoginSignUpViewTextFieldEmail,
  OMBLoginSignUpViewTextFieldPassword
};

@interface OMBLoginSignUpView : OMBView <UITextFieldDelegate>
{
  UIButton *actionSwitchButton;
  UIView *bottomView;
  UILabel *headerLabel;
  BOOL isEditing;
  BOOL isLandlord;
  BOOL isLogin;
  OMBOrView *orView;
  UIScrollView *scroll;
  NSMutableArray *textFieldBorderArray;
  NSMutableArray *textFieldFrameArray;
  UIView *textFieldView;
  UIButton *userSwitchButton;
}

@property (nonatomic, strong) UIButton *actionButton;
@property (nonatomic, strong) OMBBlurView *blurView;
@property (nonatomic, strong) OMBCloseButtonView *closeButtonView;
@property (nonatomic, strong) TextFieldPadding *emailTextField;
@property (nonatomic, strong) OMBFacebookButton *facebookButton;
@property (nonatomic, strong) TextFieldPadding *firstNameTextField;
@property (nonatomic, strong) TextFieldPadding *lastNameTextField;
@property (nonatomic, strong) TextFieldPadding *passwordTextField;

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) clearTextFields;
- (BOOL) isLogin;
- (void) scrollToTop;
- (void) switchToLandlord;
- (void) switchToLogin;
- (void) switchToSignUp;
- (void) switchToStudent;

@end
