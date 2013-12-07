//
//  OMBViewControllerContainer.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 11/26/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBViewController.h"

@class DRNRealTimeBlurView;
@class OMBCenteredImageView;
@class OMBExtendedHitAreaViewContainer;
@class OMBIntroViewController;
@class OMBLoginViewController;
@class OMBNavigationController;
@class OMBRenterApplicationViewController;
@class OMBUserMenu;

@interface OMBViewControllerContainer : OMBViewController
<UIAlertViewDelegate, UIGestureRecognizerDelegate, UIScrollViewDelegate>
{
  // Array to hold buttons
  NSMutableArray *buttonsLoggedIn;
  NSMutableArray *buttonsLoggedOut;
  NSArray *currentMenuButtons;
  
  // Buttons on the left that go in the menu scroll
  // Logged in
  NSMutableArray *userMenuArray;
  OMBUserMenu *userMenu1;
  OMBUserMenu *userMenu2;
  OMBUserMenu *userMenu3;
  OMBUserMenu *userMenu4;
  OMBUserMenu *userMenu5;
  OMBUserMenu *userMenu6;

  UIButton *favoritesButton;
  UIButton *messagesButton;
  UIButton *myAuctionsButton;
  UIButton *myBidsButton;
  UIButton *notificationsButton;
  // Logged out
  UIButton *discoverButton;
  UIButton *howItWorksButton;
  UIButton *createListingButton;
  UIButton *loginButton;
  UIButton *signUpButton;
  // Bottom right button
  // Logged in
  UIButton *accountButton;

  // Values used when hiding and showing the menu
  float buttonSpeedFactor;
  float currentDetailViewOffsetX;
  float defaultDurationOfMenuAnimation;
  float lastPointX;
  float menuIsVisible;
  float menuOffsetXThreshold;
  float menuSpeedThreshold;
  float menuWidth;
  float zoomScale;

  // Gestures
  UIPanGestureRecognizer *panGesture;
  UITapGestureRecognizer *tapGesture;

  // Views
  UIImageView *backgroundImageView;
  UIView *backgroundView;
  DRNRealTimeBlurView *blurView;
  OMBExtendedHitAreaViewContainer *hitArea;
}

@property (nonatomic, strong) UIViewController *currentDetailViewController;
@property (nonatomic, strong) UIView *detailView;
@property (nonatomic, strong) UIView *detailViewOverlay;
@property (nonatomic, strong) UIScrollView *infiniteScroll;
@property (nonatomic, strong) UIScrollView *menuScroll;

// View controllers
@property (nonatomic, strong) 
  OMBNavigationController *accountNavigationController;
@property (nonatomic, strong) OMBCenteredImageView *accountView;
@property (nonatomic, strong) 
  OMBNavigationController *favoritesNavigationController;
@property (nonatomic, strong) OMBIntroViewController *introViewController;
@property (nonatomic, strong) OMBLoginViewController *loginViewController;
@property (nonatomic, strong) OMBNavigationController *mapNavigationController;
@property (nonatomic, strong) 
  OMBRenterApplicationViewController *renterApplicationViewController;

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) hideMenuWithFactor: (float) factor;
- (void) showIntroAnimatedDissolve: (BOOL) animated;
- (void) showIntroAnimatedVertical: (BOOL) animated;
- (void) showLoggedInButtons;
- (void) showLoggedOutButtons;
- (void) showLogin;
- (void) showLogout;
- (void) showRenterApplication;
- (void) showSignUp;
- (void) showMenuWithFactor: (float) factor;

@end
