//
//  OMBLoginViewController.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 10/30/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBViewController.h"

@class OMBActivityView;
@class OMBLoginSignUpView;

@interface OMBLoginViewController : OMBViewController
<UIAlertViewDelegate>
{
  NSArray *imageNames;
  BOOL animate;
}

@property (nonatomic, strong) OMBActivityView *activityView;
@property (nonatomic, strong) OMBLoginSignUpView *loginSignUpView;

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) showLandlordSignUp;
- (void) showLogin;
- (void) showSignUp;

@end
