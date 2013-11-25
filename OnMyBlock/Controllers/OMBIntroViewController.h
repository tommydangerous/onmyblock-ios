//
//  OMBIntroViewController.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 11/7/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBViewController.h"

@class OMBHouseGraphicView;
@class OMBIntroAuctionView;
@class OMBIntroBidView;
@class OMBIntroDiscoverView;
@class OMBIntroFavoritesView;
@class OMBNavigationController;
@class OMBSignUpView;
@class OMBWelcomeView;

@interface OMBIntroViewController : OMBViewController
<UIScrollViewDelegate>
{
  UIView *closeButtonView;
  // OMBHouseGraphicView *houseGraphicView;
  UIImageView *houseGraphicView;
  UIButton *loginButton;
  UIButton *signUpButton;
}

// Views that go inside the scroll view
@property (nonatomic, strong) OMBWelcomeView *welcomeView;
@property (nonatomic, strong) OMBIntroDiscoverView *introDiscoverView;
@property (nonatomic, strong) OMBIntroBidView *introBidView;
@property (nonatomic, strong) OMBIntroAuctionView *introAuctionView;

@property (nonatomic, strong) OMBIntroFavoritesView *introFavoritesView;
@property (nonatomic, strong) OMBSignUpView *signUpView;

// Views that do not scroll
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) UIScrollView *scroll;

// Controllers
@property (nonatomic, strong) OMBNavigationController *loginViewController;

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) showLogin;

@end
