//
//  OMBAppDelegate.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 10/17/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "TestFlight.h"

#import "OMBAppDelegate.h"

#import "MFSideMenu.h"
#import "OMBLoginViewController.h"
#import "OMBMenuViewController.h"
#import "OMBNavigationController.h"
#import "OMBTabBarController.h"
#import "OMBUser.h"
#import "UIColor+Extensions.h"

NSString *const FBSessionStateChangedNotification = 
  @"com.onmyblock.Login:FBSessionStateChangedNotification";

@implementation OMBAppDelegate

@synthesize menuContainer    = _menuContainer;
@synthesize rightMenu        = _rightMenu;
@synthesize tabBarController = _tabBarController;

- (BOOL) application: (UIApplication *) application 
didFinishLaunchingWithOptions: (NSDictionary *) launchOptions
{
  [TestFlight takeOff: @"15e1558a-a34f-4a2f-b224-5df00bfd1d28"];

  CGRect screen = [[UIScreen mainScreen] bounds];
  self.window   = [[UIWindow alloc] initWithFrame: screen];

  // View controllers
  _loginViewController =
    [[OMBNavigationController alloc] initWithRootViewController:
      [[OMBLoginViewController alloc] init]];
  _tabBarController = [[OMBTabBarController alloc] init];
  _rightMenu        = [[OMBMenuViewController alloc] init];
  _menuContainer = 
    [MFSideMenuContainerViewController containerWithCenterViewController:
      _tabBarController leftMenuViewController: nil
        rightMenuViewController: _rightMenu];
  [_menuContainer setMenuWidth: screen.size.width * 0.8];
  [_menuContainer setShadowEnabled: NO];

  // Set root view controller for app
  self.window.backgroundColor    = [UIColor whiteColor];
  self.window.rootViewController = _menuContainer;
  [self.window makeKeyAndVisible];

  // Facebook
  if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded)
    // If current session has a valid Facebook token
    [self openSession];

  return YES;
}

- (BOOL) application: (UIApplication *) application openURL: (NSURL *) url
sourceApplication: (NSString *) sourceApplication annotation: (id) annotation
{
  // Delegate method to call the Facebook session object 
  // that handles the incoming URL
  return [FBSession.activeSession handleOpenURL: url];
}

- (void) applicationWillResignActive: (UIApplication *) application
{
}

- (void) applicationDidEnterBackground: (UIApplication *) application
{
}

- (void) applicationWillEnterForeground: (UIApplication *) application
{
}

- (void) applicationDidBecomeActive: (UIApplication *) application
{
}

- (void) applicationWillTerminate: (UIApplication *) application
{
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) openSession
{
  [FBSession openActiveSessionWithReadPermissions: @[@"email"] 
    allowLoginUI: YES completionHandler: 
      ^(FBSession *session, FBSessionState state, NSError *error) {
        [self sessionStateChanged: session state: state error: error];
      }
    ];
}

- (void) sessionStateChanged: (FBSession *) session
state: (FBSessionState) state error: (NSError *) error
{
  NSLog(@"Session state changed");
  switch (state) {
    // If the user was or is logged in
    case FBSessionStateOpen: {
      [OMBUser currentUser];
      // Dismiss login view controller
      [_loginViewController dismissViewControllerAnimated: NO
        completion: nil];
      // Dismiss sign up view controller

      break;
    }
    case FBSessionStateClosed:
    case FBSessionStateClosedLoginFailed:
      [FBSession.activeSession closeAndClearTokenInformation];
      break;
    default:
      break;
  }
  // The user model listens for this notification
  [[NSNotificationCenter defaultCenter] postNotificationName:
    FBSessionStateChangedNotification object: session];
  if (error) {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle: @"Error"
      message: error.localizedDescription delegate: nil
        cancelButtonTitle: @"Try again" otherButtonTitles: nil];
    [alertView show];
  }
}

- (void) showLogin
{
  [(OMBLoginViewController *) _loginViewController.topViewController showLogin];
  [self showLoginViewController];
}

- (void) showLoginViewController
{
  UINavigationController *nav = 
    (UINavigationController *) _tabBarController.selectedViewController;
  [nav.topViewController presentViewController: _loginViewController 
    animated: YES completion: ^{
      [_menuContainer setMenuState: MFSideMenuStateClosed completion: nil];
    }
  ];
}

- (void) showSignUp
{
  [(OMBLoginViewController *) 
    _loginViewController.topViewController showSignUp];
  [self showLoginViewController];
}

@end
