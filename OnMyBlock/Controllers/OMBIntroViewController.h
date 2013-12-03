//
//  OMBIntroViewController.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 11/7/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBViewController.h"

@class DDPageControl;
@class OMBGetStartedView;
@class OMBHouseGraphicView;
@class OMBIntroAuctionView;
@class OMBIntroBidView;
@class OMBIntroDiscoverView;
@class OMBIntroFavoritesView;
@class OMBIntroWelcomeView;
@class OMBLoginViewController;
@class OMBSignUpView;
@class OMBWelcomeView;

@interface OMBIntroViewController : OMBViewController
<UIScrollViewDelegate>
{
  UIView *closeButtonView;
  UIImageView *houseGraphicView;
  UIButton *loginButton;
  UIButton *signUpButton;
}

// Views that go inside the scroll view
@property (nonatomic, strong) OMBIntroWelcomeView *introWelcomeView;
@property (nonatomic, strong) OMBWelcomeView *welcomeView;
@property (nonatomic, strong) OMBIntroDiscoverView *introDiscoverView;
@property (nonatomic, strong) OMBIntroBidView *introBidView;
@property (nonatomic, strong) OMBIntroAuctionView *introAuctionView;
@property (nonatomic, strong) OMBGetStartedView *getStartedView;
@property (nonatomic, strong) OMBSignUpView *signUpView;

// Views that do not scroll
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic, strong) DDPageControl *pageControl;
@property (nonatomic, strong) UIScrollView *scroll;

// Controllers
@property (nonatomic, strong) OMBLoginViewController *loginViewController;

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) scrollToPage: (int) page;
- (void) setupForLoggedInUser;
- (void) setupForLoggedOutUser;
- (void) showLogin;

@end
