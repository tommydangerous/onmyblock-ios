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
@class OMBNavigationController;
@class OMBOfferAcceptedView;
@class OMBPayoutMethodsViewController;
@class OMBRenterApplicationViewController;
@class OMBRenterProfileViewController;
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
  OMBActivityView *activityView;
  UIImageView *backgroundImageView;
  UIView *backgroundView;
  DRNRealTimeBlurView *blurView;
  UIButton *createListingButton;
  OMBExtendedHitAreaViewContainer *hitArea;
  OMBOfferAcceptedView *offerAcceptedView;
  UIView *viewForScrollingInfiniteScroll;
}

@property (nonatomic, strong) OMBCenteredImageView *accountView;
@property (nonatomic, strong) OMBBlurView *backgroundBlurView;
@property (nonatomic, strong) UIViewController *currentDetailViewController;
@property (nonatomic, strong) UIView *detailView;
@property (nonatomic, strong) UIView *detailViewOverlay;
@property (nonatomic, strong) UIScrollView *infiniteScroll;
@property (nonatomic, strong) UIScrollView *menuScroll;

// View controllers

// Both
@property (nonatomic, strong) 
  OMBNavigationController *accountNavigationController;
@property (nonatomic, strong) 
  OMBIntroStillImagesViewController *introViewController;
@property (nonatomic, strong) OMBLoginViewController *loginViewController;
@property (nonatomic, strong)
  OMBNavigationController *payoutMethodsNavigationController;
@property (nonatomic, strong)
  OMBPayoutMethodsViewController *payoutMethodsViewController;
@property (nonatomic, strong) 
  OMBRenterApplicationViewController *renterApplicationViewController;

// Renter

// Search
@property (nonatomic, strong) 
  OMBNavigationController *mapFilterNavigationController;
@property (nonatomic, strong)
  OMBMapFilterViewController *mapFilterViewController;
// Discover
@property (nonatomic, strong) OMBNavigationController *mapNavigationController;
// My Renter App
@property (nonatomic, strong) 
  OMBNavigationController *myRenterAppNavigationController;
// Favorites
@property (nonatomic, strong) 
  OMBNavigationController *favoritesNavigationController;
// Homebase
  @property (nonatomic, strong) OMBNavigationController
  *homebaseRenterNavigationController;
// Inbox
@property (nonatomic, strong) OMBNavigationController 
  *inboxNavigationController;
// Renter Profile
@property (nonatomic, strong) OMBRenterProfileViewController
  *renterProfileViewController;
@property (nonatomic, strong) OMBNavigationController
  *renterProfileNavigationController;

// Seller

// Create Listing
// Homebase
@property (nonatomic, strong) OMBNavigationController
  *homebaseLandlordNavigationController;
// Manage Listings
@property (nonatomic, strong) OMBNavigationController 
  *manageListingsNavigationController;

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) hideMenuWithFactor: (float) factor;
- (void) hideOfferAcceptedView;
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
- (void) showOfferAccepted;
- (void) showOtherUserProfile;
- (void) showPayoutMethods;
- (void) showRenterApplication;
- (void) showRenterProfile;
- (void) showSearchAndSwitchToList: (BOOL) switchToList;
- (void) showSignUp;
- (void) showMenuWithFactor: (float) factor;
- (void) startSpinning;
- (void) stopSpinning;
// #warning Remove this
// - (void) showTest;

@end
