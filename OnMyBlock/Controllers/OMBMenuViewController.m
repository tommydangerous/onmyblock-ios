//
//  OMBMenuViewController.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 10/25/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import <CoreImage/CoreImage.h>

#import "OMBMenuViewController.h"
#import "DRNRealTimeBlurView.h"
#import "MFSideMenu.h"
#import "OMBNavigationController.h"
#import "OMBTabBarController.h"
#import "OMBUser.h"
#import "UIColor+Extensions.h"
#import "UIImage+Color.h"
#import "UIImage+NegativeImage.h"
#import "UIImage+Resize.h"

@implementation OMBMenuViewController

#pragma mark - Initializer

- (id) init
{
  if (!(self = [super init])) return nil;

  self.screenName = @"Menu View Controller";

  buttons = [NSMutableArray array];
  // OMBAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
  // tabBarController = appDelegate.tabBarController;

  [[NSNotificationCenter defaultCenter] addObserver: self
    selector: @selector(showLoggedInButtons)
      name: OMBUserLoggedInNotification object: nil];
  [[NSNotificationCenter defaultCenter] addObserver: self
    selector: @selector(showLoggedOutButtons)
      name: OMBUserLoggedOutNotification object: nil];

  return self;
}

#pragma mark - Override

#pragma mark - Override UIViewController

- (void) loadView
{
  [super loadView];
  CGRect screen   = [[UIScreen mainScreen] bounds];
  float menuWidth = screen.size.width * 0.8;
  // View
  self.view       = [[UIView alloc] init];
  self.view.frame = CGRectMake(0, 0, menuWidth, screen.size.height);
  // Background view
  UIImageView *backgroundView = [[UIImageView alloc] init];
  backgroundView.frame        = self.view.frame;
  UIImage *image = [UIImage imageNamed: @"menu_background.jpg"];
  backgroundView.image = [UIImage image: image size: 
    CGSizeMake(
      ((self.view.frame.size.height / image.size.height) * image.size.width), 
        self.view.frame.size.height)];
  [self.view addSubview: backgroundView];
  // Black tint
  UIView *colorView = [[UIView alloc] init];
  colorView.backgroundColor = [UIColor colorWithRed: 0 green: 0 blue: 0
    alpha: 0.5];
  colorView.frame = self.view.frame;
  [self.view addSubview: colorView];
  // Blur
  DRNRealTimeBlurView *blurView = [[DRNRealTimeBlurView alloc] init];
  blurView.frame   = self.view.frame;
  blurView.renderStatic = YES;
  [self.view addSubview: blurView];

  UIColor *fadedBlack = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 0.3];
  UIFont *fontLight18 = [UIFont fontWithName: @"HelveticaNeue-Light" size: 18];

  scroll                              = [[UIScrollView alloc] init];
  scroll.alwaysBounceVertical         = YES;
  scroll.frame                        = self.view.frame;
  scroll.showsVerticalScrollIndicator = NO;
  [self.view addSubview: scroll];

  // Search button
  searchButton = [[UIButton alloc] init];
  searchButton.contentEdgeInsets = UIEdgeInsetsMake(0, (20 + 24 + 20), 0, 20);
  searchButton.contentHorizontalAlignment = 
    UIControlContentHorizontalAlignmentLeft;
  searchButton.frame = CGRectMake(0, 20, menuWidth, (20 + 30 + 20));
  searchButton.titleLabel.font = fontLight18;
  [searchButton addTarget: self action: @selector(showSearch)
    forControlEvents: UIControlEventTouchUpInside];
  [searchButton setTitle: @"Search" forState: UIControlStateNormal];
  [searchButton setBackgroundImage: [UIImage imageWithColor: fadedBlack] 
    forState: UIControlStateHighlighted];
  [buttons addObject: searchButton];
  [scroll addSubview: searchButton];
  UIImageView *searchImageView = [[UIImageView alloc] init];
  searchImageView.frame = CGRectMake(20, 
    ((searchButton.frame.size.height - 24) / 2.0), 24, 24);
  UIImage *searchImage = [UIImage imageNamed: @"search.png"];
  searchImageView.image = [UIImage image: [searchImage negativeImage]
    size: searchImageView.frame.size];
  [searchButton addSubview: searchImageView];

  // Sign up button
  signUpButton = [[UIButton alloc] init];
  signUpButton.contentEdgeInsets = searchButton.contentEdgeInsets;
  signUpButton.contentHorizontalAlignment = 
    searchButton.contentHorizontalAlignment;
  signUpButton.frame = CGRectMake(searchButton.frame.origin.x,
    (searchButton.frame.origin.y + searchButton.frame.size.height),
      searchButton.frame.size.width, searchButton.frame.size.height);
  signUpButton.titleLabel.font = searchButton.titleLabel.font;
  [signUpButton addTarget: self action: @selector(showSignUp)
    forControlEvents: UIControlEventTouchUpInside];
  [signUpButton setTitle: @"Sign up" forState: UIControlStateNormal];
  [signUpButton setBackgroundImage: [UIImage imageWithColor: fadedBlack] 
    forState: UIControlStateHighlighted];
  [buttons addObject: signUpButton];
  [scroll addSubview: signUpButton];
  UIImageView *signUpImageView = [[UIImageView alloc] init];
  signUpImageView.frame = searchImageView.frame;
  UIImage *signUpImage = [UIImage imageNamed: @"sign_up_icon.png"];
  signUpImageView.image = [UIImage image: signUpImage
    size: searchImageView.frame.size];
  [signUpButton addSubview: signUpImageView];

  // Favorites button
  favoritesButton = [[UIButton alloc] init];
  favoritesButton.contentEdgeInsets = searchButton.contentEdgeInsets;
  favoritesButton.contentHorizontalAlignment = 
    searchButton.contentHorizontalAlignment;
  favoritesButton.frame = CGRectMake(searchButton.frame.origin.x,
    (searchButton.frame.origin.y + searchButton.frame.size.height),
      searchButton.frame.size.width, searchButton.frame.size.height);
  favoritesButton.hidden = YES;
  favoritesButton.titleLabel.font = searchButton.titleLabel.font;
  [favoritesButton addTarget: self action: @selector(showFavorites)
    forControlEvents: UIControlEventTouchUpInside];
  [favoritesButton setTitle: @"Favorites" forState: UIControlStateNormal];
  [favoritesButton setBackgroundImage: [UIImage imageWithColor: fadedBlack] 
    forState: UIControlStateHighlighted];
  [buttons addObject: favoritesButton];
  [scroll addSubview: favoritesButton];
  UIImageView *favoritesImageView = [[UIImageView alloc] init];
  favoritesImageView.frame = searchImageView.frame;
  UIImage *favoritesImage = [UIImage imageNamed: @"favorite.png"];
  favoritesImageView.image = [UIImage image: favoritesImage
    size: searchImageView.frame.size];
  [favoritesButton addSubview: favoritesImageView];

  // Login
  loginButton = [[UIButton alloc] init];
  loginButton.contentEdgeInsets = searchButton.contentEdgeInsets;
  loginButton.contentHorizontalAlignment = 
    searchButton.contentHorizontalAlignment;
  loginButton.frame = CGRectMake(searchButton.frame.origin.x,
    (signUpButton.frame.origin.y + signUpButton.frame.size.height),
      searchButton.frame.size.width, searchButton.frame.size.height);
  loginButton.titleLabel.font = searchButton.titleLabel.font;
  [loginButton addTarget: self action: @selector(showlogin)
    forControlEvents: UIControlEventTouchUpInside];
  [loginButton setTitle: @"Login" forState: UIControlStateNormal];
  [loginButton setBackgroundImage: [UIImage imageWithColor: fadedBlack] 
    forState: UIControlStateHighlighted];
  [buttons addObject: loginButton];
  [scroll addSubview: loginButton];
  UIImageView *loginImageView = [[UIImageView alloc] init];
  loginImageView.frame = searchImageView.frame;
  UIImage *loginImage = [UIImage imageNamed: @"login_icon.png"];
  loginImageView.image = [UIImage image: loginImage
    size: searchImageView.frame.size];
  [loginButton addSubview: loginImageView];

  // Logout
  logoutButton = [[UIButton alloc] init];
  logoutButton.contentEdgeInsets = searchButton.contentEdgeInsets;
  logoutButton.contentHorizontalAlignment = 
    searchButton.contentHorizontalAlignment;
  logoutButton.frame = CGRectMake(searchButton.frame.origin.x,
    (signUpButton.frame.origin.y + signUpButton.frame.size.height),
      searchButton.frame.size.width, searchButton.frame.size.height);
  logoutButton.hidden = YES;
  logoutButton.titleLabel.font = searchButton.titleLabel.font;
  [logoutButton addTarget: self action: @selector(showLogout)
    forControlEvents: UIControlEventTouchUpInside];
  [logoutButton setTitle: @"Logout" forState: UIControlStateNormal];
  [logoutButton setBackgroundImage: [UIImage imageWithColor: fadedBlack] 
    forState: UIControlStateHighlighted];
  [buttons addObject: logoutButton];
  [scroll addSubview: logoutButton];
  UIImageView *logoutImageView = [[UIImageView alloc] init];
  logoutImageView.frame = searchImageView.frame;
  UIImage *logoutImage = [UIImage imageNamed: @"logout_icon.png"];
  logoutImageView.image = [UIImage image: logoutImage
    size: searchImageView.frame.size];
  [logoutButton addSubview: logoutImageView];

  if ([[OMBUser currentUser] loggedIn])
    [self showLoggedInButtons];
}

#pragma mark - Protocol

#pragma mark - Protocol UIAlertViewDelegate

- (void) alertView: (UIAlertView *) alertView 
clickedButtonAtIndex: (NSInteger) buttonIndex
{
  if (buttonIndex == 1)
    [self logout];
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) buttonSelected: (UIButton *) button
{

}

- (void) logout
{
  // [[NSNotificationCenter defaultCenter] postNotificationName:
  //   OMBCurrentUserLogoutNotification object: nil];
}

- (void) showFavorites
{
  [self switchToViewController: tabBarController.favoritesViewController 
    fromButton: favoritesButton];
}

- (void) showLoggedInButtons
{
  signUpButton.hidden = YES;
  loginButton.hidden  = YES;

  favoritesButton.hidden = NO;
  logoutButton.hidden    = NO;
}

- (void) showLoggedOutButtons
{
  signUpButton.hidden = NO;
  loginButton.hidden  = NO;

  favoritesButton.hidden = YES;
  logoutButton.hidden    = YES;
}

- (void) showlogin
{
  OMBAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
  [appDelegate showLogin];
}

- (void) showLogout
{
  UIAlertView *alertView = [[UIAlertView alloc] initWithTitle: 
    @"Logout" message: @"Are you sure?" delegate: self
      cancelButtonTitle: @"No" otherButtonTitles: @"Yes", nil];
  [alertView show];
  // OMBAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
  // [appDelegate.menuContainer toggleRightSideMenuCompletion: ^{}];
}

- (void) showSearch
{
  [self switchToViewController: tabBarController.mapViewController 
    fromButton: searchButton];
}

- (void) showSignUp
{
  OMBAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
  [appDelegate showSignUp];
}

- (void) switchToViewController: (OMBNavigationController *) nav
fromButton: (UIButton *) button;
{ 
  // If user is on the view controller that they want to switch to

  if ([[nav viewControllers] objectAtIndex: 0] == 
    [[(UINavigationController *) 
      tabBarController.selectedViewController viewControllers] 
        objectAtIndex: 0])
    // Pop to the root view controller
    [nav popToRootViewControllerAnimated: NO];
  tabBarController.viewControllers = 
    @[tabBarController.selectedViewController, nav];
  tabBarController.selectedViewController = nav;
  // OMBAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
  // [appDelegate.menuContainer setMenuState: MFSideMenuStateClosed completion: ^{
  //   [self buttonSelected: button];
  // }];
}

- (void) unselectAllButtons
{
  for (UIButton *b in buttons) {

  }
}

@end
