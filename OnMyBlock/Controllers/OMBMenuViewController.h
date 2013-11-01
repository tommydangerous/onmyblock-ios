//
//  OMBMenuViewController.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 10/25/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBViewController.h"

@class OMBTabBarController;

@interface OMBMenuViewController : OMBViewController
<UIAlertViewDelegate>
{
  NSMutableArray *buttons;
  UIButton *favoritesButton;
  UIButton *loginButton;
  UIButton *logoutButton;
  UIButton *searchButton;
  UIButton *signUpButton;
  OMBTabBarController *tabBarController;
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) showLoggedInButtons;
- (void) showLoggedOutButtons;

@end
