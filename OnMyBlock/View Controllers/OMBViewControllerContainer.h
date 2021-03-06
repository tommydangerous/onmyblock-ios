//
//  OMBViewControllerContainer.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 11/26/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBViewController.h"

@class DRNRealTimeBlurView;
@class OMBActivityView;
@class OMBBlurView;
@class OMBCenteredImageView;
@class OMBExtendedHitAreaViewContainer;
@class OMBIntroStillImagesViewController;
@class OMBLoginViewController;
@class OMBMapFilterViewController;
@class OMBMyRenterProfileViewController;
@class OMBNavigationController;
@class OMBOffer;
@class OMBOfferAcceptedView;
@class OMBPayoutMethodsViewController;
@class OMBRenterApplicationViewController;
@class OMBRenterProfileViewController;
@class OMBTopDetailView;
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

  // Logged out
  UIButton *searchButton;
  UIButton *discoverButton;
  UIButton *howItWorksButton;
  UIButton *loginButton;
  UIButton *signUpButton;
  // Bottom right button
  // Logged in
  //UIButton *accountButton;
  UIButton *topDetailButton;

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
  OMBActivityView *activityView;
  UIView *arrowView;
  UIImageView *backgroundImageView;
  UIView *backgroundView;
  DRNRealTimeBlurView *blurView;
  UIButton *createListingButton;
  OMBExtendedHitAreaViewContainer *hitArea;
  OMBOfferAcceptedView *offerAcceptedView;
  UIButton *signUpButtonBottom;
  UIView *viewForScrollingInfiniteScroll;

  // BOOL slideEnabled;
}

@property (nonatomic, strong) OMBCenteredImageView *accountView;
@property (nonatomic, strong) OMBTopDetailView *topDetailView;
//@property (nonatomic, strong) OMBBlurView *backgroundBlurView;
@property (nonatomic, strong) UIViewController *currentDetailViewController;
@property (nonatomic, strong) UIView *detailView;
@property (nonatomic, strong) UIView *detailViewOverlay;
@property (nonatomic, strong) UIScrollView *infiniteScroll;
@property (nonatomic, strong) UIScrollView *menuScroll;

@property  BOOL slideEnabled;

// View controllers

// Both
// Account
@property (nonatomic, strong)
  OMBNavigationController *accountNavigationController;
// Intro (How it Works)
@property (nonatomic, strong)
  OMBIntroStillImagesViewController *introViewController;
// Login, Sign Up
@property (nonatomic, strong) OMBLoginViewController *loginViewController;
// Payout Methods navigation
@property (nonatomic, strong)
  OMBNavigationController *payoutMethodsNavigationController;
// Payout Methods
@property (nonatomic, strong)
  OMBPayoutMethodsViewController *payoutMethodsViewController;
// Renter Application
@property (nonatomic, strong)
  OMBRenterApplicationViewController *renterApplicationViewController;

// Renter
// Search (Map Filter) navigation
@property (nonatomic, strong)
  OMBNavigationController *mapFilterNavigationController;
// Search (Map Filter)
@property (nonatomic, strong)
  OMBMapFilterViewController *mapFilterViewController;
// Discover (Map)
@property (nonatomic, strong) OMBNavigationController *mapNavigationController;
// My Renter App
@property (nonatomic, strong)
  OMBNavigationController *myRenterAppNavigationController;
// Favorites
@property (nonatomic, strong)
  OMBNavigationController *favoritesNavigationController;
// Homebase
@property (nonatomic, strong)
  OMBNavigationController *homebaseRenterNavigationController;
// Inbox
@property (nonatomic, strong)
  OMBNavigationController *inboxNavigationController;
// Renter Profile
@property (nonatomic, strong)
  OMBRenterProfileViewController *renterProfileViewController;
// Renter Profile navigation
@property (nonatomic, strong)
  OMBNavigationController *renterProfileNavigationController;
// My Renter Profile
@property (nonatomic, strong)
  OMBMyRenterProfileViewController *myRenterProfileViewController;
// My Renter Profile navigation
@property (nonatomic, strong)
  OMBNavigationController *myRenterProfileNavigationController;

// Seller
// Create Listing
// Homebase Landlord
@property (nonatomic, strong)
  OMBNavigationController *homebaseLandlordNavigationController;
// Manage Listings
@property (nonatomic, strong)
  OMBNavigationController *manageListingsNavigationController;

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) hideMenuWithFactor: (float) factor;
- (void) hideOfferAcceptedView;
- (BOOL) isMenuVisible;
- (void) logout;
- (void) setTitleColorWhite;
- (void) showAccount;
- (void) showCreateListing;
- (void) showDiscover;
- (void) showFavorites;
- (void) showFinishListing;
- (void) showHomebaseLandlord;
- (void) showHomebaseRenter;
- (void) showInbox;
- (void) showIntroAnimatedDissolve: (BOOL) animated;
- (void) showIntroAnimatedVertical: (BOOL) animated;
- (void) showLoggedInButtons;
- (void) showLoggedOutButtons;
- (void) showLogin;
- (void) showLogout;
- (void) showManageListings;
- (void) showMyRenterApp;
- (void) showMyRenterProfile;
- (void) showOfferAccepted: (OMBOffer *) offer;
- (void) showOtherUserProfile;
- (void) showPayoutMethods;
- (void) showRenterApplication;
- (void) showRenterProfile;
- (void) showSearchAndSwitchToList: (BOOL) switchToList;
- (void) showSignUp;
- (void) showMenuWithFactor: (float) factor;
- (void) startSpinning;
- (void) startSpinningFullScreen;
- (void) stopSpinning;
- (void) stopSpinningFullScreen;
// #warning Remove this
// - (void) showTest;

@end
