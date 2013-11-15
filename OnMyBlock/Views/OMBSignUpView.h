//
//  OMBSignUpView.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 11/8/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TextFieldPadding;

@interface OMBSignUpView : UIScrollView
<UITextFieldDelegate>
{
  UIActivityIndicatorView *activityIndicatorView;
  TextFieldPadding *emailTextField;  
  UIBarButtonItem *loginBarButtonItem;
  UIButton *loginButton;
  UIView *orView;
  TextFieldPadding *passwordTextField;
  UIBarButtonItem *signUpBarButtonItem;
}

@property (nonatomic, strong) UIButton *facebookButton;
@property (nonatomic, strong) TextFieldPadding *nameTextField;

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) resetViewOrigins;
- (void) signUp;

@end
