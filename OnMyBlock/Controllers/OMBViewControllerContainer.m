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
#import "OMBFavoritesListViewController.h"
#import "OMBGetStartedView.h"
#import "OMBIntroViewController.h"
#import "OMBLoginViewController.h"
#import "OMBMapViewController.h"
#import "OMBNavigationController.h"
#import "OMBRenterApplicationViewController.h"
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

  panGesture = [[UIPanGestureRecognizer alloc] initWithTarget: self 
    action: @selector(drag:)];
  panGesture.cancelsTouchesInView   = YES;
  panGesture.delegate               = self;
  panGesture.maximumNumberOfTouches = 1;
  [self.view addGestureRecognizer: panGesture];

  // View Controllers
  _accountNavigationController = 
    [[OMBNavigationController alloc] initWithRootViewController:
      [[OMBAccountViewController alloc] init]];
  _favoritesNavigationController = 
    [[OMBNavigationController alloc] initWithRootViewController:
      [[OMBFavoritesListViewController alloc] init]];
  _introViewController = [[OMBIntroViewController alloc] init];
  _loginViewController = [[OMBLoginViewController alloc] init];
  _mapNavigationController = 
    [[OMBNavigationController alloc] initWithRootViewController: 
      [[OMBMapViewController alloc] init]];
  _renterApplicationViewController = 
    [[OMBRenterApplicationViewController alloc] init];

  backgroundView = [[UIView alloc] initWithFrame: self.view.frame];
  [self.view addSubview: backgroundView];
  // Background view
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

  backgroundImageView.transform = CGAffineTransformMakeScale(2, 2);
  blurView.transform = CGAffineTransformMakeScale(2, 2);

  // Menu
  _menuScroll = [[UIScrollView alloc] init];
  _menuScroll.alwaysBounceVertical = YES;
  _menuScroll.frame = CGRectMake(0, 0, menuWidth, screenHeight);
  [self.view addSubview: _menuScroll];

  // Buttons
  float imageSize = 22;
  float leftPad   = 25;
  // Discover
  discoverButton = [[UIButton alloc] init];
  discoverButton.contentEdgeInsets = UIEdgeInsetsMake(0, 
    (leftPad + imageSize + leftPad), 0, 20);
  discoverButton.contentHorizontalAlignment = 
    UIControlContentHorizontalAlignmentLeft;
  discoverButton.frame = CGRectMake((-1 * menuWidth), 0, 
    menuWidth, (10 + 40 + 10));
  discoverButton.titleLabel.font = [UIFont fontWithName: @"HelveticaNeue-Light"
    size: 15];
  [discoverButton addTarget: self action: @selector(showDiscover)
    forControlEvents: UIControlEventTouchUpInside];
  [discoverButton setTitle: @"Discover" forState: UIControlStateNormal];
  [discoverButton setTitleColor: [UIColor grayMedium] 
    forState: UIControlStateHighlighted];
  [buttonsLoggedIn addObject: discoverButton];
  [buttonsLoggedOut addObject: discoverButton];
  UIImageView *discoverImageView = [[UIImageView alloc] init];
  discoverImageView.frame = CGRectMake(leftPad, 
    ((discoverButton.frame.size.height - imageSize) * 0.5), 
      imageSize, imageSize);
  discoverImageView.image = [UIImage image: 
    [UIImage imageNamed: @"search_icon.png"] 
      size: discoverImageView.frame.size];
  [discoverButton addSubview: discoverImageView];

  // Logged out
  // How it Works
  howItWorksButton = [[UIButton alloc] init];
  howItWorksButton.contentEdgeInsets = discoverButton.contentEdgeInsets;
  howItWorksButton.contentHorizontalAlignment = 
    discoverButton.contentHorizontalAlignment;
  howItWorksButton.titleLabel.font = discoverButton.titleLabel.font;
  [howItWorksButton addTarget: self action: @selector(showIntroVertical)
    forControlEvents: UIControlEventTouchUpInside];
  [howItWorksButton setTitle: @"How it Works" forState: UIControlStateNormal];
  [howItWorksButton setTitleColor: [UIColor grayMedium] 
    forState: UIControlStateHighlighted];  
  [buttonsLoggedOut addObject: howItWorksButton];
  UIImageView *howItWorksImageView = [[UIImageView alloc] init];
  howItWorksImageView.frame = discoverImageView.frame;
  UIImage *howItWorksImage = [UIImage imageNamed: @"how_it_works_icon.png"];
  howItWorksImageView.image = [UIImage image: howItWorksImage
    size: howItWorksImageView.frame.size];
  [howItWorksButton addSubview: howItWorksImageView];
  // Login
  loginButton = [[UIButton alloc] init];
  loginButton.contentEdgeInsets = discoverButton.contentEdgeInsets;
  loginButton.contentHorizontalAlignment = 
    discoverButton.contentHorizontalAlignment;
  loginButton.titleLabel.font = discoverButton.titleLabel.font;
  [loginButton addTarget: self action: @selector(showLogin)
    forControlEvents: UIControlEventTouchUpInside];
  [loginButton setTitle: @"Login" forState: UIControlStateNormal];
  [loginButton setTitleColor: [UIColor grayMedium] 
    forState: UIControlStateHighlighted];  
  [buttonsLoggedOut addObject: loginButton];
  UIImageView *loginImageView = [[UIImageView alloc] init];
  loginImageView.frame = discoverImageView.frame;
  UIImage *loginImage = [UIImage imageNamed: @"login_icon.png"];
  loginImageView.image = [UIImage image: loginImage
    size: loginImageView.frame.size];
  [loginButton addSubview: loginImageView];
  // Sign up
  signUpButton = [[UIButton alloc] init];
  signUpButton.contentEdgeInsets = loginButton.contentEdgeInsets;
  signUpButton.contentHorizontalAlignment = 
    loginButton.contentHorizontalAlignment;
  signUpButton.titleLabel.font = loginButton.titleLabel.font;
  [signUpButton addTarget: self action: @selector(showSignUp)
    forControlEvents: UIControlEventTouchUpInside];
  [signUpButton setTitle: @"Sign up" forState: UIControlStateNormal];
  [signUpButton setTitleColor: [UIColor grayMedium] 
    forState: UIControlStateHighlighted];
  [buttonsLoggedOut addObject: signUpButton];
  UIImageView *signUpImageView = [[UIImageView alloc] init];
  signUpImageView.frame = loginImageView.frame;
  UIImage *signUpImage = [UIImage imageNamed: @"sign_up_icon.png"];
  signUpImageView.image = [UIImage image: signUpImage
    size: signUpImageView.frame.size];
  [signUpButton addSubview: signUpImageView];

  // Logged in
  // Create Listing
  createListingButton = [[UIButton alloc] init];
  createListingButton.contentEdgeInsets = discoverButton.contentEdgeInsets;
  createListingButton.contentHorizontalAlignment = 
    discoverButton.contentHorizontalAlignment;
  createListingButton.titleLabel.font = discoverButton.titleLabel.font;
  [createListingButton addTarget: self action: @selector(showCreateListing)
    forControlEvents: UIControlEventTouchUpInside];
  [createListingButton setTitle: @"Create Listing" 
    forState: UIControlStateNormal];
  [createListingButton setTitleColor: [UIColor grayMedium] 
    forState: UIControlStateHighlighted];
  [buttonsLoggedIn addObject: createListingButton];
  UIImageView *createListingImageView = [[UIImageView alloc] init];
  createListingImageView.frame = discoverImageView.frame;
  UIImage *createListingImage = [UIImage imageNamed: 
    @"create_listing_icon.png"];
  createListingImageView.image = [UIImage image: createListingImage
    size: createListingImageView.frame.size];
  [createListingButton addSubview: createListingImageView];
  // My Auctions
  myAuctionsButton = [[UIButton alloc] init];
  myAuctionsButton.contentEdgeInsets = discoverButton.contentEdgeInsets;
  myAuctionsButton.contentHorizontalAlignment = 
    discoverButton.contentHorizontalAlignment;
  myAuctionsButton.titleLabel.font = discoverButton.titleLabel.font;
  [myAuctionsButton addTarget: self action: @selector(showMyAuctions)
    forControlEvents: UIControlEventTouchUpInside];
  [myAuctionsButton setTitle: @"My Auctions" forState: UIControlStateNormal];
  [myAuctionsButton setTitleColor: [UIColor grayMedium] 
    forState: UIControlStateHighlighted];
  [buttonsLoggedIn addObject: myAuctionsButton];
  UIImageView *myAuctionsImageView = [[UIImageView alloc] init];
  myAuctionsImageView.frame = discoverImageView.frame;
  UIImage *myAuctionsImage = [UIImage imageNamed: @"my_auctions_icon.png"];
  myAuctionsImageView.image = [UIImage image: myAuctionsImage
    size: myAuctionsImageView.frame.size];
  [myAuctionsButton addSubview: myAuctionsImageView];
  // My Bids
  myBidsButton = [[UIButton alloc] init];
  myBidsButton.contentEdgeInsets = discoverButton.contentEdgeInsets;
  myBidsButton.contentHorizontalAlignment = 
    discoverButton.contentHorizontalAlignment;
  myBidsButton.titleLabel.font = discoverButton.titleLabel.font;
  [myBidsButton addTarget: self action: @selector(showMyBids)
    forControlEvents: UIControlEventTouchUpInside];
  [myBidsButton setTitle: @"My Bids" forState: UIControlStateNormal];
  [myBidsButton setTitleColor: [UIColor grayMedium] 
    forState: UIControlStateHighlighted];
  [buttonsLoggedIn addObject: myBidsButton];
  UIImageView *myBidsImageView = [[UIImageView alloc] init];
  myBidsImageView.frame = discoverImageView.frame;
  UIImage *myBidsImage = [UIImage imageNamed: @"my_bids_icon.png"];
  myBidsImageView.image = [UIImage image: myBidsImage
    size: myBidsImageView.frame.size];
  [myBidsButton addSubview: myBidsImageView];
  // Favorites
  favoritesButton = [[UIButton alloc] init];
  favoritesButton.contentEdgeInsets = discoverButton.contentEdgeInsets;
  favoritesButton.contentHorizontalAlignment = 
    discoverButton.contentHorizontalAlignment;
  favoritesButton.titleLabel.font = discoverButton.titleLabel.font;
  [favoritesButton addTarget: self action: @selector(showFavorites)
    forControlEvents: UIControlEventTouchUpInside];
  [favoritesButton setTitle: @"Favorites" forState: UIControlStateNormal];
  [favoritesButton setTitleColor: [UIColor grayMedium] 
    forState: UIControlStateHighlighted];
  [buttonsLoggedIn addObject: favoritesButton];
  UIImageView *favoritesImageView = [[UIImageView alloc] init];
  favoritesImageView.frame = discoverImageView.frame;
  UIImage *favoritesImage = [UIImage imageNamed: @"favorites_icon.png"];
  favoritesImageView.image = [UIImage image: favoritesImage
    size: favoritesImageView.frame.size];
  [favoritesButton addSubview: favoritesImageView];
  // Notifications
  notificationsButton = [[UIButton alloc] init];
  notificationsButton.contentEdgeInsets = discoverButton.contentEdgeInsets;
  notificationsButton.contentHorizontalAlignment = 
    discoverButton.contentHorizontalAlignment;
  notificationsButton.titleLabel.font = discoverButton.titleLabel.font;
  [notificationsButton addTarget: self action: @selector(showNotifications)
    forControlEvents: UIControlEventTouchUpInside];
  [notificationsButton setTitle: @"Notifications" 
    forState: UIControlStateNormal];
  [notificationsButton setTitleColor: [UIColor grayMedium] 
    forState: UIControlStateHighlighted];
  [buttonsLoggedIn addObject: notificationsButton];
  UIImageView *notificationsImageView = [[UIImageView alloc] init];
  notificationsImageView.frame = discoverImageView.frame;
  UIImage *notificationsImage = [UIImage imageNamed: @"notifications_icon.png"];
  notificationsImageView.image = [UIImage image: notificationsImage
    size: notificationsImageView.frame.size];
  [notificationsButton addSubview: notificationsImageView];
  // Messages
  messagesButton = [[UIButton alloc] init];
  messagesButton.contentEdgeInsets = discoverButton.contentEdgeInsets;
  messagesButton.contentHorizontalAlignment = 
    discoverButton.contentHorizontalAlignment;
  messagesButton.titleLabel.font = discoverButton.titleLabel.font;
  [messagesButton addTarget: self action: @selector(showMessages)
    forControlEvents: UIControlEventTouchUpInside];
  [messagesButton setTitle: @"Messages" forState: UIControlStateNormal];
  [messagesButton setTitleColor: [UIColor grayMedium] 
    forState: UIControlStateHighlighted];
  [buttonsLoggedIn addObject: messagesButton];
  UIImageView *messagesImageView = [[UIImageView alloc] init];
  messagesImageView.frame = discoverImageView.frame;
  UIImage *messagesImage = [UIImage imageNamed: @"messages_icon.png"];
  messagesImageView.image = [UIImage image: messagesImage
    size: messagesImageView.frame.size];
  [messagesButton addSubview: messagesImageView];

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
  float accountImageSize = screenHeight * 0.1;  
  // The distance between the bottom of the detail view scaled
  // and the bottom of the screen
  float accountViewPadding = (screenHeight * (1 - zoomScale)) * 0.5;
  // Half the difference of the image and the bottom part of the screen
  accountViewPadding = (accountViewPadding - accountImageSize) * 0.5;
  CGRect accountViewRect = CGRectMake(
    (screenWidth - (accountImageSize + accountViewPadding)),
      (screenHeight - (accountImageSize + accountViewPadding)), 
        accountImageSize, accountImageSize);
  accountView = [[OMBCenteredImageView alloc] initWithFrame: accountViewRect];
  accountView.alpha = 0.0;  
  accountView.layer.borderColor = [UIColor whiteColor].CGColor;
  accountView.layer.borderWidth = 1.0;  
  // Button
  accountButton = [[UIButton alloc] init];
  accountButton.frame = CGRectMake(0, 0, accountView.frame.size.width,
    accountView.frame.size.height);
  [accountButton addTarget: self action: @selector(showAccount)
    forControlEvents: UIControlEventTouchUpInside];
  [accountView addSubview: accountButton];
  accountView.transform = CGAffineTransformMakeScale(0, 0);

  [self presentDetailViewController: _mapNavigationController];

  // Set the frame for the buttons
  [self setFramesForButtons: buttonsLoggedIn];
  [self setFramesForButtons: buttonsLoggedOut];

  currentMenuButtons = [NSArray arrayWithArray: buttonsLoggedOut];

  [self adjustMenuScrollContent];
  [self addCurrentMenuButtonsToMenuScroll];
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
      for (UIButton *button in currentMenuButtons) {
        float index = 1 + [currentMenuButtons indexOfObject: button];
        float speed = 1 + 
          (buttonSpeedFactor * (index / [currentMenuButtons count]));
        CGRect rect = button.frame;
        rect.origin.x = (-1 * menuWidth) * (1 - (percentComplete * speed));
        if (rect.origin.x >= 0)
          rect.origin.x = 0;
        button.frame = rect;
      }

      // Animate the account view
      accountView.alpha     = percentComplete;
      accountView.transform = CGAffineTransformMakeScale(percentComplete,
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
    accountView.alpha     = 0.0;
    accountView.transform = CGAffineTransformMakeScale(0, 0);
  } completion: ^(BOOL finished) {
    // Remove detail view overlay from the detail view
    [_detailViewOverlay removeFromSuperview];
  }];

  // Animate the buttons
  // Top buttons slide out first
  for (UIButton *button in currentMenuButtons) {
    float index = 1 + [currentMenuButtons indexOfObject: button];
    float speed = 1 + 
      (buttonSpeedFactor * (([currentMenuButtons count] - index) /
        [currentMenuButtons count]));
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
  [accountView removeFromSuperview];
  // Adjust the intro view
  [_introViewController setupForLoggedOutUser];
  [self showIntroAnimatedDissolve: NO];
  [self showLoggedOutButtons];
  [self adjustMenuScrollContent];
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

- (void) setupForLoggedInUser
{
  // Add the account view
  [self.view addSubview: accountView];
  // Show the buttons for users who are logged in
  [self showLoggedInButtons];
  // Adjust the menu scroll content inset and content size
  [self adjustMenuScrollContent];
  // Hide the menu
  [self hideMenuWithFactor: 1];
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
      [accountView setImage: image];
    }
  ];
}

- (void) showAccount
{
  [self hideMenuWithFactor: 1];
  [self presentDetailViewController: _accountNavigationController];
}

- (void) showCreateListing
{
  NSLog(@"SHOW CREATE LISTING");
}

- (void) showDiscover
{
  [self hideMenuWithFactor: 1];
  [self presentDetailViewController: _mapNavigationController];
}

- (void) showFavorites
{
  [self hideMenuWithFactor: 1];
  [self presentDetailViewController: _favoritesNavigationController];
}

- (void) showIntroVertical
{
  // This is only used when user clicks How it Works when logged out
  [self showIntroAnimatedVertical: YES];
}

- (void) showIntroAnimated: (BOOL) animated
{
  CGRect screen = [[UIScreen mainScreen] bounds];

  CGRect getStartedButtonRect = 
    _introViewController.getStartedView.getStartedButton.frame;
  getStartedButtonRect.origin.x = screen.size.width;
  _introViewController.getStartedView.getStartedButton.frame = 
    getStartedButtonRect;
  _introViewController.pageControl.currentPage = 0;
  _introViewController.scroll.contentOffset    = CGPointZero;
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
  [self hideMenuWithFactor: 1];
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
    accountView.alpha     = 1.0;
    accountView.transform = CGAffineTransformMakeScale(1, 1);
  } completion: ^(BOOL finished) {
    // Add detail view overlay to the detail view
    [_detailView addSubview: _detailViewOverlay];
  }];

  // Animate the buttons
  // Top buttons slide in first
  for (UIButton *button in currentMenuButtons) {
    float index = 1 + [currentMenuButtons indexOfObject: button];
    float speed = 1 + 
      (buttonSpeedFactor * (index / [currentMenuButtons count]));
    [UIView animateWithDuration: duration / speed animations: ^{
      CGRect rect   = button.frame;
      rect.origin.x = 0;
      button.frame  = rect;
    }];
  }
  menuIsVisible = YES;
}

- (void) showMessages
{
  NSLog(@"SHOW MESSAGES");
}

- (void) showMyAuctions
{
  NSLog(@"SHOW MY AUCTIONS");
}

- (void) showMyBids
{
  NSLog(@"SHOW MY BIDS");
}

- (void) showNotifications
{
  NSLog(@"SHOW NOTIFICATIONS");
}

- (void) showRenterApplication
{
  [self presentViewController: _renterApplicationViewController 
    animated: YES completion: nil];
}

- (void) showSignUp
{
  [_loginViewController showSignUp];
  [self presentLoginViewController];
}

- (void) tappedDetailView: (UITapGestureRecognizer *) gesture
{
  if (menuIsVisible) {
    [self hideMenuWithFactor: 1];
  }
}

- (void) updateStatusBarStyle
{
  if ([self respondsToSelector: @selector(setNeedsStatusBarAppearanceUpdate)])
    [self setNeedsStatusBarAppearanceUpdate];
}

@end
