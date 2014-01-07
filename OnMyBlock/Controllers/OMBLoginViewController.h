//
//  OMBLoginViewController.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 10/30/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBViewController.h"

@class OMBSignUpView;
@class TextFieldPadding;

@interface OMBLoginViewController : OMBViewController
{
  UIView *closeButtonView;
}

@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic, strong) OMBSignUpView *signUpView;

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) showLogin;
- (void) showSignUp;

@end
