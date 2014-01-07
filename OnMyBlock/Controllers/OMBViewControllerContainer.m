//
//  OMBViewControllerContainer.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 11/26/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBViewControllerContainer.h"

#import "DDPageControl.h"
#import "DRNRealTimeBlurView.h"
#import "OMBAccountViewController.h"
#import "OMBCenteredImageView.h"
#import "OMBCreateListingViewController.h"
#import "OMBExtendedHitAreaViewContainer.h"
#import "OMBFavoritesListViewController.h"
#import "OMBFinishListingViewController.h"
#import "OMBGetStartedView.h"
#import "OMBHomebaseLandlordViewController.h"
#import "OMBHomebaseRenterViewController.h"
#import "OMBInboxViewController.h"
#import "OMBIntroStillImagesViewController.h"
#import "OMBLoginViewController.h"
#import "OMBManageListingsViewController.h"
#import "OMBMapFilterViewController.h"
#import "OMBMapViewController.h"
#import "OMBNavigationController.h"
#import "OMBRenterApplicationViewController.h"
#import "OMBUserMenu.h"
#import "OMBUser.h"
#import "UIColor+Extensions.h"
#import "UIImage+Color.h"
#import "UIImage+NegativeImage.h"
#import "UIImage+Resize.h"

@implementation OMBViewControllerContainer

- (id) init
{
  if (!(self = [super init])) return nil;

  // These 3 post this notification
  // Login connection
  // Sign up connection
  // User authenticate with server
  [[NSNotificationCenter defaultCenter] addObserver: self
    selector: @selector(setupForLoggedInUser)
      name: OMBUserLoggedInNotification object: nil];

  return self;
}

- (void) loadView
{
  [super loadView];

  buttonsLoggedIn  = [NSMutableArray array];
  buttonsLoggedOut = [NSMutableArray array];

  CGRect screen      = [[UIScreen mainScreen] bounds];
  float screenHeight = screen.size.height;
  float screenWidth  = screen.size.width;

  // How small does the detail view get when menu is visible
  zoomScale = 0.5;
  // How fast the buttons slide
  buttonSpeedFactor = 0.75;
  // When showing and hiding the menu, this is the default duration
  defaultDurationOfMenuAnimation = 0.3;
  // What is the furthest the detail view needs to be in order to
  // show or hide the menu
  menuOffsetXThreshold = screenWidth * 0.5;
  // How fast does the user need to swipe to show or hide the menu
  menuSpeedThreshold = 800;
  menuWidth = screenWidth * 0.8;

  self.view.frame = screen;

  // Gesture for sliding the menu
  panGesture = [[UIPanGestureRecognizer alloc] initWithTarget: self 
    action: @selector(drag:)];
  panGesture.cancelsTouchesInView   = YES;
  panGesture.delegate               = self;
  panGesture.maximumNumberOfTouches = 1;
  [self.view addGestureRecognizer: panGesture];

  // View Controllers

  // Both
  // Account
  _accountNavigationController = 
    [[OMBNavigationController alloc] initWithRootViewController:
      [[OMBAccountViewController alloc] init]];
  // Intro  
  _introViewController = [[OMBIntroStillImagesViewController alloc] init];
  // Login
  _loginViewController = [[OMBLoginViewController alloc] init];
  // Renter Application
  _renterApplicationViewController = 
    [[OMBRenterApplicationViewController alloc] init];

  // Renter
  OMBMapViewController *mapViewController = [[OMBMapViewController alloc] init];
  OMBMapFilterViewController *mapFilterViewController =
    [[OMBMapFilterViewController alloc] init];
  // mapFilterViewController.mapViewController = mapViewController;
  // Search
  _mapFilterNavigationController =
    [[OMBNavigationController alloc] initWithRootViewController:
      mapFilterViewController];
  // Discover
  _mapNavigationController = 
    [[OMBNavigationController alloc] initWithRootViewController: 
      mapViewController];
  // Favorites
  _favoritesNavigationController = 
    [[OMBNavigationController alloc] initWithRootViewController:
      [[OMBFavoritesListViewController alloc] init]];
  // Homebase
  _homebaseRenterNavigationController = 
    [[OMBNavigationController alloc] initWithRootViewController:
      [[OMBHomebaseRenterViewController alloc] init]];
  // Inbox
  _inboxNavigationController =
    [[OMBNavigationController alloc] initWithRootViewController:
      [[OMBInboxViewController alloc] init]];

  // Seller
  // Create Listing
  // Homebase
  _homebaseLandlordNavigationController =
    [[OMBNavigationController alloc] initWithRootViewController:
      [[OMBHomebaseLandlordViewController alloc] init]];
  // Manage Listings
  _manageListingsNavigationController =
    [[OMBNavigationController alloc] initWithRootViewController:
      [[OMBManageListingsViewController alloc] init]];

  // Background view
  backgroundView = [[UIView alloc] initWithFrame: self.view.frame];
  [self.view addSubview: backgroundView];
  // Background image
  backgroundImageView = [[UIImageView alloc] init];
  backgroundImageView.contentMode  = UIViewContentModeScaleAspectFill;
  backgroundImageView.frame        = backgroundView.frame;
  backgroundImageView.image = 
    [UIImage imageNamed: @"menu_background.jpg"];
  [backgroundView addSubview: backgroundImageView];
  // Black tint
  UIView *colorView = [[UIView alloc] init];
  colorView.backgroundColor = [UIColor colorWithRed: 0 green: 0 blue: 0
    alpha: 0.5];
  colorView.frame = backgroundView.frame;
  [backgroundView addSubview: colorView];
  // Blur
  blurView = [[DRNRealTimeBlurView alloc] init];
  blurView.frame = backgroundView.frame;
  blurView.renderStatic = YES;
  [backgroundView addSubview: blurView];
  // Scale the background larger so when they slide the menu, it "zooms"
  backgroundImageView.transform = CGAffineTransformMakeScale(2, 2);
  blurView.transform = CGAffineTransformMakeScale(2, 2);

  // Menu
  // Logged out
  _menuScroll = [[UIScrollView alloc] init];
  _menuScroll.alwaysBounceVertical = YES;
  _menuScroll.frame = CGRectMake(0, 0, menuWidth, screenHeight);
  _menuScroll.showsVerticalScrollIndicator = NO;
  [self.view addSubview: _menuScroll];
  // Logged in
  // Hit Area
  hitArea = [[OMBExtendedHitAreaViewContainer alloc] init];
  hitArea.clipsToBounds = YES;
  hitArea.frame = _menuScroll.frame;
  hitArea.hidden = YES;
  [self.view addSubview: hitArea];
  // Infinite scroll
  _infiniteScroll = [[UIScrollView alloc] init];
  _infiniteScroll.clipsToBounds = NO;
  _infiniteScroll.delegate = self;
  // 100 is the renter menu header label size
  _infiniteScroll.frame = CGRectMake(0, 0, _menuScroll.frame.size.width,
    _menuScroll.frame.size.height - 100);
  _infiniteScroll.pagingEnabled = YES;
  _infiniteScroll.panGestureRecognizer.maximumNumberOfTouches = 1;
  _infiniteScroll.showsVerticalScrollIndicator = NO;
  hitArea.scrollView = _infiniteScroll;
  [hitArea addSubview: _infiniteScroll];

  // Buttons
  CGFloat imageSize = 22.0f;
  CGFloat leftPad   = 25.0f;
  // Logged out
  // Search
  searchButton = [UIButton new];
  searchButton.frame = CGRectMake(-1 * menuWidth, 0.0f, 
    menuWidth, 10.0f + 40.0f + 10.0f);
  [searchButton addTarget: self action: @selector(showSearch)
    forControlEvents: UIControlEventTouchUpInside];
  [searchButton setTitle: @"Search" forState: UIControlStateNormal];
  [buttonsLoggedOut addObject: searchButton];
  // Image view
  UIImageView *searchImageView = [[UIImageView alloc] init];
  searchImageView.frame = CGRectMake(leftPad, 
    ((searchButton.frame.size.height - imageSize) * 0.5), 
      imageSize, imageSize);
  searchImageView.image = [UIImage image: 
    [UIImage imageNamed: @"search_icon.png"] 
      size: searchImageView.frame.size];
  [searchButton addSubview: searchImageView];

  // Discover
  discoverButton = [[UIButton alloc] init];
  [discoverButton addTarget: self action: @selector(showDiscover)
    forControlEvents: UIControlEventTouchUpInside];
  [discoverButton setTitle: @"Discover" forState: UIControlStateNormal];
  [buttonsLoggedOut addObject: discoverButton];
  // Image view
  UIImageView *discoverImageView = [[UIImageView alloc] init];
  discoverImageView.frame = searchImageView.frame;
  discoverImageView.image = [UIImage image: 
    [UIImage imageNamed: @"discover_icon.png"] 
      size: discoverImageView.frame.size];
  [discoverButton addSubview: discoverImageView];

  // Create Listing
  createListingButton = [[UIButton alloc] init];
  [createListingButton addTarget: self action: @selector(showLogin)
    forControlEvents: UIControlEventTouchUpInside];
  [createListingButton setTitle: @"Create Listing" 
    forState: UIControlStateNormal];
  // [buttonsLoggedOut addObject: createListingButton];
  // Image view
  UIImageView *createListingImageView = [[UIImageView alloc] init];
  createListingImageView.frame = discoverImageView.frame;
  UIImage *createListingImage = [UIImage imageNamed: 
    @"create_listing_icon.png"];
  createListingImageView.image = [UIImage image: createListingImage
    size: createListingImageView.frame.size];
  [createListingButton addSubview: createListingImageView];

  // How it Works
  howItWorksButton = [[UIButton alloc] init];
  [howItWorksButton addTarget: self action: @selector(showIntroVertical)
    forControlEvents: UIControlEventTouchUpInside];
  [howItWorksButton setTitle: @"How it Works" forState: UIControlStateNormal];
  [buttonsLoggedOut addObject: howItWorksButton];
  // Image view
  UIImageView *howItWorksImageView = [[UIImageView alloc] init];
  howItWorksImageView.frame = discoverImageView.frame;
  UIImage *howItWorksImage = [UIImage imageNamed: @"how_it_works_icon.png"];
  howItWorksImageView.image = [UIImage image: howItWorksImage
    size: howItWorksImageView.frame.size];
  [howItWorksButton addSubview: howItWorksImageView];

  // Login
  loginButton = [[UIButton alloc] init];
  [loginButton addTarget: self action: @selector(showLogin)
    forControlEvents: UIControlEventTouchUpInside];
  [loginButton setTitle: @"Login" forState: UIControlStateNormal];
  [buttonsLoggedOut addObject: loginButton];
  // Image view
  UIImageView *loginImageView = [[UIImageView alloc] init];
  loginImageView.frame = discoverImageView.frame;
  UIImage *loginImage = [UIImage imageNamed: @"login_icon.png"];
  loginImageView.image = [UIImage image: loginImage
    size: loginImageView.frame.size];
  [loginButton addSubview: loginImageView];

  // Sign up
  signUpButton = [[UIButton alloc] init];
  [signUpButton addTarget: self action: @selector(showSignUp)
    forControlEvents: UIControlEventTouchUpInside];
  [signUpButton setTitle: @"Sign up" forState: UIControlStateNormal];
  [buttonsLoggedOut addObject: signUpButton];
  // Image view
  UIImageView *signUpImageView = [[UIImageView alloc] init];
  signUpImageView.frame = loginImageView.frame;
  UIImage *signUpImage = [UIImage imageNamed: @"sign_up_icon.png"];
  signUpImageView.image = [UIImage image: signUpImage
    size: signUpImageView.frame.size];
  [signUpButton addSubview: signUpImageView];

  // Logged in
  // User menu
  userMenu1 = [[OMBUserMenu alloc] initWithFrame: _infiniteScroll.frame];
  userMenu2 = [[OMBUserMenu alloc] initWithFrame: _infiniteScroll.frame];
  userMenu3 = [[OMBUserMenu alloc] initWithFrame: _infiniteScroll.frame];
  userMenu4 = [[OMBUserMenu alloc] initWithFrame: _infiniteScroll.frame];
  userMenu5 = [[OMBUserMenu alloc] initWithFrame: _infiniteScroll.frame];
  userMenu6 = [[OMBUserMenu alloc] initWithFrame: _infiniteScroll.frame];
  userMenuArray = [NSMutableArray arrayWithArray: 
    @[userMenu1, userMenu2, userMenu3, userMenu4, userMenu5, userMenu6]
  ];
  _infiniteScroll.contentSize = CGSizeMake(_infiniteScroll.frame.size.width,
    _infiniteScroll.frame.size.height * [userMenuArray count]);
  // Set frames and setup each user menu
  for (OMBUserMenu *m in userMenuArray) {
    int index = [userMenuArray indexOfObject: m];
    if (index > 0) {
      OMBUserMenu *previous = [userMenuArray objectAtIndex: index - 1];
      CGRect rect = CGRectMake(previous.frame.origin.x, 
        previous.frame.origin.y + previous.frame.size.height,
          previous.frame.size.width, previous.frame.size.height);
      m.frame = rect;
    }
    if (index % 2 == 0)
      [m setupForRenter];
    else
      [m setupForSeller];
    [m setHeaderInactive];
    [_infiniteScroll addSubview: m];
  }
  // Scroll to renter menu
  [_infiniteScroll setContentOffset: 
    CGPointMake(0, userMenu1.frame.size.height * 2) animated: NO];

  // Detail view
  _detailView = [[UIView alloc] initWithFrame: screen];
  [self.view addSubview: _detailView];
  _detailViewOverlay = [[UIView alloc] initWithFrame: screen];
  // Tap gesture
  tapGesture = [[UITapGestureRecognizer alloc] initWithTarget: self
    action: @selector(tappedDetailView:)];
  tapGesture.cancelsTouchesInView = NO;
  [_detailViewOverlay addGestureRecognizer: tapGesture];

  // Bottom right
  float accountImageSize = screenHeight * 0.13;  
  // The distance between the bottom of the detail view scaled
  // and the bottom of the screen
  float _accountViewPadding = (screenHeight * (1 - zoomScale)) * 0.5;
  // Half the difference of the image and the bottom part of the screen
  _accountViewPadding = (_accountViewPadding - accountImageSize) * 0.5;
  CGRect _accountViewRect = CGRectMake(
    (screenWidth - (accountImageSize + _accountViewPadding)),
      (screenHeight - (accountImageSize + _accountViewPadding)), 
        accountImageSize, accountImageSize);
  _accountView = [[OMBCenteredImageView alloc] initWithFrame: _accountViewRect];
  _accountView.alpha = 0.0;  
  _accountView.layer.borderColor = [UIColor whiteColor].CGColor;
  _accountView.layer.borderWidth = 1.0;  
  _accountView.layer.cornerRadius = accountImageSize * 0.5f;
  // Button
  accountButton = [[UIButton alloc] init];
  accountButton.frame = CGRectMake(0, 0, _accountView.frame.size.width,
    _accountView.frame.size.height);
  [accountButton addTarget: self action: @selector(showAccount)
    forControlEvents: UIControlEventTouchUpInside];
  [_accountView addSubview: accountButton];
  _accountView.transform = CGAffineTransformMakeScale(0, 0);

  [self presentDetailViewController: _mapNavigationController];
  // [self presentDetailViewController: _accountNavigationController];

  // Set the frame for the buttons
  // [self setFramesForButtons: buttonsLoggedIn];
  [self setupAttributesForButtons: buttonsLoggedOut];
  [self setFramesForButtons: buttonsLoggedOut];

  currentMenuButtons = [NSArray arrayWithArray: buttonsLoggedOut];

  [self adjustMenuScrollContent];
  [self addCurrentMenuButtonsToMenuScroll];

  NSLog(@"CONTAINER SETUP FOR LOGGED IN USER");
  // [self setupForLoggedInUser];
}

#pragma mark - Protocol

#pragma mark - UIAlertViewDelegate Protocol

- (void) alertView: (UIAlertView *) alertView 
clickedButtonAtIndex: (NSInteger) buttonIndex
{
  if (buttonIndex == 1)
    [self logout];
}

#pragma mark - UIGestureRecognizerProtocol

- (BOOL) gestureRecognizer: (UIGestureRecognizer *) gestureRecognizer 
shouldRecognizeSimultaneouslyWithGestureRecognizer: 
(UIGestureRecognizer *) otherGestureRecognizer
{
  if (gestureRecognizer == panGesture)
    return NO;
  return YES;
}

#pragma mark - Protocol UIScrollViewDelegate

- (void) scrollViewDidEndDecelerating: (UIScrollView *) scrollView
{
  if (scrollView == _infiniteScroll) {
    float y   = scrollView.contentOffset.y;
    int index = y / scrollView.frame.size.height;
    int n     = index % 2;
    float multiplier;
    // If user landed on a renter menu
    if (n == 0) {
      multiplier = 2;
    }
    // If user landed on a seller menu
    else {
      multiplier = 3;
    }
    [scrollView setContentOffset: 
      CGPointMake(0, scrollView.frame.size.height * multiplier) animated: NO];
    [self setCurrentUserMenuHeaderTextColor];
  }
}

- (void) scrollViewDidEndDragging: (UIScrollView *) scrollView 
willDecelerate: (BOOL) decelerate
{
  if (scrollView == _infiniteScroll) {
    NSLog(@"END DRAGGING");
  }
}

- (void) scrollViewDidScroll: (UIScrollView *) scrollView
{
  if (scrollView == _infiniteScroll) {
    // float y = scrollView.contentOffset.y;
  }
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) addCurrentMenuButtonsToMenuScroll
{
  for (UIButton *button in currentMenuButtons) {
    [_menuScroll addSubview: button];
  }
}

- (void) adjustMenuScrollContent
{
  CGRect screen = [[UIScreen mainScreen] bounds];
  float height = discoverButton.frame.size.height * [currentMenuButtons count];
  _menuScroll.contentInset = UIEdgeInsetsMake(
    ((screen.size.height - height) * 0.5), 0, 0, 0);
  _menuScroll.contentSize = CGSizeMake(menuWidth, height);
}

- (void) drag: (UIPanGestureRecognizer *) gesture
{
  // CGRect screen      = [[UIScreen mainScreen] bounds];
  // float screenHeight = screen.size.height;
  // float screenWidth  = screen.size.width;

  float scaledWidthDifference = 
    (self.view.frame.size.width - (self.view.frame.size.width * zoomScale)) 
      * 0.5;
  float maxTranslationX = menuWidth - scaledWidthDifference;

  CGPoint point    = [gesture locationInView: self.view];
  CGPoint velocity = [gesture velocityInView: self.view];
  // Began
  if (gesture.state == UIGestureRecognizerStateBegan) {
    lastPointX = point.x;
    if (menuIsVisible) {
      currentDetailViewOffsetX = menuWidth;
    }
    else {
      currentDetailViewOffsetX = 0;
    }
  }
  // Changed
  if (gesture.state == UIGestureRecognizerStateChanged) {

    float currentPointX = point.x;

    float horizontalDifference = currentPointX - lastPointX;
    float percentComplete = 1 - 
      ((menuWidth - currentDetailViewOffsetX) / menuWidth);

    // Scale the detail view
    float newScale = 1 - ((1 - zoomScale) * percentComplete);
    if (newScale > 1)
      newScale = 1;
    else if (newScale < zoomScale)
      newScale = zoomScale;
    CGAffineTransform transformScale = CGAffineTransformScale(
      self.view.transform, newScale, newScale);

    // Translating the detail view's X position
    float translationPercent = 0;
    float translationX = 0;
    if (horizontalDifference > 0) {
      translationPercent = percentComplete;
      translationX = maxTranslationX * translationPercent;
    }
    else if (horizontalDifference < 0) {
      translationPercent = 1 - percentComplete;
      translationX = maxTranslationX - (maxTranslationX * translationPercent);
    }
    if (translationX > maxTranslationX)
      translationX = maxTranslationX;
    else if (translationX < 0)
      translationX = 0;
    CGAffineTransform transformTranslation = 
      CGAffineTransformMakeTranslation(translationX, 0);

    // Zoom into the background image view
    float newBlurViewScale = 2 - (1 * percentComplete);
    if (newBlurViewScale > 2)
      newBlurViewScale = 2;
    else if (newBlurViewScale < 1)
      newBlurViewScale = 1;
    
    // If there is horizontal movement
    if (horizontalDifference != 0) {
      _detailView.transform = CGAffineTransformConcat(
        transformScale, transformTranslation);
      blurView.transform = CGAffineTransformMakeScale(newBlurViewScale, 
        newBlurViewScale);

      // Animate current set of menu buttons
      // Top buttons slide in first
      for (OMBUserMenu *m in userMenuArray) {
        for (UIButton *button in m.currentButtons) {
          float index = 1 + [m.currentButtons indexOfObject: button];
          float speed = 1 + 
            (buttonSpeedFactor * (index / [m.currentButtons count]));
          CGRect rect = button.frame;
          rect.origin.x = (-1 * menuWidth) * (1 - (percentComplete * speed));
          if (rect.origin.x >= 0)
            rect.origin.x = 0;
          button.frame = rect;
        }
      }
      // Buttons when logged out
      for (UIButton *button in buttonsLoggedOut) {
        float index = 1 + [buttonsLoggedOut indexOfObject: button];
        float speed = 1 + 
          (buttonSpeedFactor * (index / [buttonsLoggedOut count]));
        CGRect rect = button.frame;
        rect.origin.x = (-1 * menuWidth) * (1 - (percentComplete * speed));
        if (rect.origin.x >= 0)
          rect.origin.x = 0;
        button.frame = rect;
      }
      
      // Animate the account view
      _accountView.alpha     = percentComplete;
      _accountView.transform = CGAffineTransformMakeScale(percentComplete,
        percentComplete);
    }

    lastPointX = currentPointX;
    currentDetailViewOffsetX += horizontalDifference;
    if (currentDetailViewOffsetX > menuWidth)
      currentDetailViewOffsetX = menuWidth;
    if (currentDetailViewOffsetX < 0)
      currentDetailViewOffsetX = 0;
  }
  // Ended
  if (gesture.state == UIGestureRecognizerStateEnded) {

    // Panning right, showing menu
    if (velocity.x > menuSpeedThreshold) {
      [self showMenuWithFactor: abs(velocity.x) / menuSpeedThreshold];
    }
    // Panning left, hiding menu
    else if (velocity.x < -1 * menuSpeedThreshold) {
      [self hideMenuWithFactor: abs(velocity.x) / menuSpeedThreshold];
    }
    else
      [self hideOrShowMenu];
  }
}

- (void) hideMenuWithFactor: (float) factor
{
  float duration = defaultDurationOfMenuAnimation;
  if (factor && factor > 0)
    duration /= factor;

  // Animate the detail view
  [UIView animateWithDuration: duration animations: ^{

    CGAffineTransform transformScale = CGAffineTransformMakeScale(1, 1);
    CGAffineTransform transformTranslation = 
      CGAffineTransformMakeTranslation(0, 0);
    _detailView.transform = CGAffineTransformConcat(
      transformScale, transformTranslation);

    // Zoom into the background image view
    blurView.transform = CGAffineTransformMakeScale(2, 2);

    // Hide the account image view
    _accountView.alpha     = 0.0;
    _accountView.transform = CGAffineTransformMakeScale(0, 0);
  } completion: ^(BOOL finished) {
    // Remove detail view overlay from the detail view
    [_detailViewOverlay removeFromSuperview];
    [[UIApplication sharedApplication] setStatusBarStyle:
      UIStatusBarStyleDefault];
  }];

  // Animate the buttons
  // Top buttons slide out first
  for (OMBUserMenu *m in userMenuArray) {
    for (UIButton *button in m.currentButtons) {
      float index = 1 + [m.currentButtons indexOfObject: button];
      float speed = 1 + 
        (buttonSpeedFactor * (([m.currentButtons count] - index) /
          [m.currentButtons count]));
      [UIView animateWithDuration: duration / speed animations: ^{
        CGRect rect   = button.frame;
        rect.origin.x = -1 * menuWidth;
        button.frame  = rect;
      }];
    }
  }
  // Buttons when logged out
  for (UIButton *button in buttonsLoggedOut) {
    float index = 1 + [buttonsLoggedOut indexOfObject: button];
    float speed = 1 + 
      (buttonSpeedFactor * (([buttonsLoggedOut count] - index) /
        [buttonsLoggedOut count]));
    [UIView animateWithDuration: duration / speed animations: ^{
      CGRect rect   = button.frame;
      rect.origin.x = -1 * menuWidth;
      button.frame  = rect;
    }];
  }

  menuIsVisible = NO;
}

- (void) hideOrShowMenu
{
  if (_detailView.frame.origin.x > menuOffsetXThreshold)
    [self showMenuWithFactor: 1];
  else
    [self hideMenuWithFactor: 1];
}

- (CGRect) frameForDetailViewController
{
  return _detailView.bounds;
}

- (void) logout
{
  // This is received by OMBUser and 
  // then OMBUser posts OMBUserLoggedOutNotification
  [[NSNotificationCenter defaultCenter] postNotificationName:
    OMBCurrentUserLogoutNotification object: nil];
  // Remove the account view
  [_accountView removeFromSuperview];
  // Adjust the intro view
  [_introViewController setupForLoggedOutUser];
  [self showIntroAnimatedDissolve: NO];

  // [self showLoggedOutButtons];
  // [self adjustMenuScrollContent];
  hitArea.hidden     = YES;
  _menuScroll.hidden = NO;

  [self presentDetailViewController: _mapNavigationController];
}

- (void) presentDetailViewController: (UIViewController *) viewController
{
  if (_currentDetailViewController)
    [self removeCurrentDetailViewController];

  [self addChildViewController: viewController];

  viewController.view.frame = [self frameForDetailViewController];

  [_detailView addSubview: viewController.view];
  _currentDetailViewController = viewController;

  [viewController didMoveToParentViewController: self];
}

- (void) presentLoginViewController
{
  [self presentViewController: _loginViewController 
    animated: YES completion: nil];
}

- (void) removeCurrentButtonsFromMenuScroll
{
  for (UIButton *button in currentMenuButtons) {
    [button removeFromSuperview];
  }
}

- (void) removeCurrentDetailViewController
{
  // Call the willMoveToParentViewController with nil
  // This is the last method where your detailViewController 
  // can perform some operations before neing removed
  [_currentDetailViewController willMoveToParentViewController: nil];

  // Remove the DetailViewController's view from the Container
  [_currentDetailViewController.view removeFromSuperview];

  // Update the hierarchy
  // Automatically the method didMoveToParentViewController: 
  // will be called on the detailViewController)
  [_currentDetailViewController removeFromParentViewController];
}

- (void) setCurrentUserMenuHeaderTextColor
{
  for (OMBUserMenu *m in userMenuArray) {
    [m setHeaderInactive];
  }
  int index = _infiniteScroll.contentOffset.y / 
    _infiniteScroll.frame.size.height;
  OMBUserMenu *userMenu = [userMenuArray objectAtIndex: index];
  [userMenu setHeaderActive];
}

- (void) setFramesForButtons: (NSArray *) array
{
  for (UIButton *button in array) {
    int index = [array indexOfObject: button];
    if (index > 0) {
      UIButton *previousButton = (UIButton *) [array objectAtIndex: index - 1];
      CGRect rect = previousButton.frame;
      button.frame = CGRectMake(rect.origin.x, 
        (rect.origin.y + rect.size.height),
          rect.size.width, rect.size.height);
    }
  }
}

- (void) setupAttributesForButtons: (NSArray *) array
{
  CGFloat imageSize = 22.0f;
  CGFloat leftPad   = 25.0f;
  for (UIButton *button in array) {
    button.contentEdgeInsets = UIEdgeInsetsMake(0.0f, 
      leftPad + imageSize + leftPad, 0.0f, 20.0f);
    button.contentHorizontalAlignment = 
      UIControlContentHorizontalAlignmentLeft;
    button.titleLabel.font = [UIFont fontWithName: @"HelveticaNeue-Light"
      size: 15];
    [button setTitleColor: [UIColor whiteColor] 
      forState: UIControlStateNormal];
    [button setTitleColor: [UIColor grayMedium] 
      forState: UIControlStateHighlighted];
  }
}

- (void) setupForLoggedInUser
{
  // Add the account view
  [self.view addSubview: _accountView];

  // Show the buttons for users who are logged in
  // [self showLoggedInButtons];
  // Adjust the menu scroll content inset and content size
  // [self adjustMenuScrollContent];
  hitArea.hidden     = NO;
  _menuScroll.hidden = YES;
  [self setCurrentUserMenuHeaderTextColor];

  // Hide the menu
  [self hideMenuWithFactor: 1.0f];
  // Hide the intro view controller -> login view controller
  void (^completion)(void) = ^(void) {
    [_introViewController setupForLoggedInUser];
  };
  // Hide the login view controller
  [_loginViewController dismissViewControllerAnimated: YES 
    completion: completion];
  [_introViewController.loginViewController dismissViewControllerAnimated: YES
    completion: ^{
      // Then hide the intro view controller
      [_introViewController dismissViewControllerAnimated: YES 
        completion: completion];
    }
  ];
  // Hide the intro view controller
  [_introViewController dismissViewControllerAnimated: YES 
    completion: completion];

  // Download the user's profile image and set it to the account image view
  [[OMBUser currentUser] downloadImageFromImageURLWithCompletion: 
    ^(NSError *error) {
      UIImage *image;
      if ([OMBUser currentUser].image) {
        image = [OMBUser currentUser].image;
      }
      else {
        image = [UIImage imageNamed: 
          @"default_user_image.png"];
      }
      [_accountView setImage: image];
    }
  ];
}

- (void) showAccount
{
  [self hideMenuWithFactor: 1.0f];
  [self presentDetailViewController: _accountNavigationController];
}

- (void) showCreateListing
{
  [self presentViewController: 
    [[OMBNavigationController alloc] initWithRootViewController:
      [[OMBCreateListingViewController alloc] init]] animated: YES 
        completion: ^{
          [self hideMenuWithFactor: 1.0f];
          [self presentDetailViewController: 
            _manageListingsNavigationController];
        }
      ];         
}

- (void) showDiscover
{
  [self hideMenuWithFactor: 1.0f];
  [self presentDetailViewController: _mapNavigationController];
}

- (void) showFavorites
{
  [self hideMenuWithFactor: 1.0f];
  [self presentDetailViewController: _favoritesNavigationController];
}

- (void) showFinishListing
{
  [self hideMenuWithFactor: 1.0f];
  [self presentDetailViewController: _manageListingsNavigationController];
  [_manageListingsNavigationController pushViewController:
    [[OMBFinishListingViewController alloc] initWithResidence: nil] 
      animated: YES];
}

- (void) showHomebaseLandlord
{
  [self hideMenuWithFactor: 1.0f];
  [self presentDetailViewController: _homebaseLandlordNavigationController];
}

- (void) showHomebaseRenter
{
  [self hideMenuWithFactor: 1.0f];
  [self presentDetailViewController: _homebaseRenterNavigationController];
}

- (void) showInbox
{
  [self hideMenuWithFactor: 1.0f];
  [self presentDetailViewController: _inboxNavigationController];
}

- (void) showIntroVertical
{
  // This is only used when user clicks How it Works when logged out
  [self showIntroAnimatedVertical: YES];
}

- (void) showIntroAnimated: (BOOL) animated
{
  // CGRect screen = [[UIScreen mainScreen] bounds];

  // CGRect getStartedButtonRect = 
  //   _introViewController.getStartedView.getStartedButton.frame;
  // getStartedButtonRect.origin.x = screen.size.width;
  // _introViewController.getStartedView.getStartedButton.frame = 
  //   getStartedButtonRect;
  
  [_introViewController resetViews];
  [self presentViewController: _introViewController animated: animated
    completion: nil];
}

- (void) showIntroAnimatedDissolve: (BOOL) animated
{
  _introViewController.modalTransitionStyle = 
    UIModalTransitionStyleCrossDissolve;
  [self showIntroAnimated: animated];
}

- (void) showIntroAnimatedVertical: (BOOL) animated
{
  _introViewController.modalTransitionStyle = 
    UIModalTransitionStyleCoverVertical;
  [self showIntroAnimated: animated];
}

- (void) showLoggedInButtons
{
  [self removeCurrentButtonsFromMenuScroll];
  currentMenuButtons = [NSArray arrayWithArray: buttonsLoggedIn];
  [self addCurrentMenuButtonsToMenuScroll];
}

- (void) showLoggedOutButtons
{
  [self removeCurrentButtonsFromMenuScroll];
  currentMenuButtons = [NSArray arrayWithArray: buttonsLoggedOut];
  [self addCurrentMenuButtonsToMenuScroll];
}

- (void) showLogin
{
  [_loginViewController showLogin];
  [self presentLoginViewController];
}

- (void) showLogout
{
  UIAlertView *alertView = [[UIAlertView alloc] initWithTitle: 
    @"Logout" message: @"Are you sure?" delegate: self
      cancelButtonTitle: @"No" otherButtonTitles: @"Yes", nil];
  [alertView show];
  [self hideMenuWithFactor: 1.0f];
}

- (void) showManageListings
{
  [self hideMenuWithFactor: 1.0f];
  [self presentDetailViewController: _manageListingsNavigationController];
}

- (void) showMenuWithFactor: (float) factor
{
  float duration = defaultDurationOfMenuAnimation;
  if (factor && factor > 0)
    duration /= factor;

  // Animate the detail view
  [UIView animateWithDuration: duration animations: ^{

    CGAffineTransform transformScale = CGAffineTransformMakeScale(
      zoomScale, zoomScale);
    float scaledWidthDifference = 
      (self.view.frame.size.width - (self.view.frame.size.width * zoomScale)) 
        * 0.5;
    float maxTranslationX = menuWidth - scaledWidthDifference;
    CGAffineTransform transformTranslation = 
      CGAffineTransformMakeTranslation(maxTranslationX, 0);
    _detailView.transform = CGAffineTransformConcat(
      transformScale, transformTranslation);

    // Zoom into the background image view
    blurView.transform = CGAffineTransformMakeScale(1, 1);

    // Hide the account image view
    _accountView.alpha     = 1.0;
    _accountView.transform = CGAffineTransformMakeScale(1, 1);
  } completion: ^(BOOL finished) {
    // Add detail view overlay to the detail view
    [_detailView addSubview: _detailViewOverlay];
    [[UIApplication sharedApplication] setStatusBarStyle:
      UIStatusBarStyleLightContent];
  }];

  // Animate the buttons
  // Top buttons slide in first
  for (OMBUserMenu *m in userMenuArray) {
    for (UIButton *button in m.currentButtons) {
      float index = 1 + [m.currentButtons indexOfObject: button];
      float speed = 1 + 
        (buttonSpeedFactor * (index / [m.currentButtons count]));
      [UIView animateWithDuration: duration / speed animations: ^{
        CGRect rect   = button.frame;
        rect.origin.x = 0;
        button.frame  = rect;
      }];
    }
  }
  // Buttons logged out
  for (UIButton *button in buttonsLoggedOut) {
    float index = 1 + [buttonsLoggedOut indexOfObject: button];
    float speed = 1 + 
      (buttonSpeedFactor * (index / [buttonsLoggedOut count]));
    [UIView animateWithDuration: duration / speed animations: ^{
      CGRect rect   = button.frame;
      rect.origin.x = 0;
      button.frame  = rect;
    }];
  }
    
  menuIsVisible = YES;
}

- (void) showRenterApplication
{
  [self presentViewController: _renterApplicationViewController 
    animated: YES completion: nil];
}

- (void) showSearch
{
  [self presentViewController: _mapFilterNavigationController
    animated: YES completion: ^{
      OMBMapViewController *mapViewController = (OMBMapViewController *)
        [_mapNavigationController.viewControllers firstObject];
      [_mapNavigationController popToRootViewControllerAnimated: NO];
      [mapViewController switchToListView];
      [self hideMenuWithFactor: 1.0f];
      [self presentDetailViewController: _mapNavigationController];
    }];
}

- (void) showSignUp
{
  [_loginViewController showSignUp];
  [self presentLoginViewController];
}

- (void) tappedDetailView: (UITapGestureRecognizer *) gesture
{
  if (menuIsVisible) {
    [self hideMenuWithFactor: 1.0f];
  }
}

- (void) updateStatusBarStyle
{
  if ([self respondsToSelector: @selector(setNeedsStatusBarAppearanceUpdate)])
    [self setNeedsStatusBarAppearanceUpdate];
}

@end
