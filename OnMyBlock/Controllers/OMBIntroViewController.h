//
//  OMBIntroViewController.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 11/7/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBViewController.h"

@class OMBIntroductionView;
@class OMBIntroContactView;
@class OMBIntroFavoritesView;
@class OMBIntroSearchView;
@class OMBNavigationController;
@class OMBSignUpView;
@class OMBWelcomeView;

@interface OMBIntroViewController : OMBViewController
<UIScrollViewDelegate>

// Views that go inside the scroll view
@property (nonatomic, strong) OMBWelcomeView *welcomeView;
@property (nonatomic, strong) OMBIntroductionView *introductionView;
@property (nonatomic, strong) OMBIntroSearchView *introSearchView;
@property (nonatomic, strong) OMBIntroContactView *introContactView;
@property (nonatomic, strong) OMBIntroFavoritesView *introFavoritesView;
@property (nonatomic, strong) OMBSignUpView *signUpView;

// Views that do not scroll
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) UIScrollView *scroll;

// Buttons
@property (nonatomic, strong) UIButton *loginButton;
@property (nonatomic, strong) UIButton *signUpButton;

// Controllers
@property (nonatomic, strong) OMBNavigationController *loginViewController;

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) showLogin;

@end
