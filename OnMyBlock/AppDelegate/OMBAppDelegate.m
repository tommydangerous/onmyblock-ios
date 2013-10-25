//
//  OMBAppDelegate.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 10/17/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBAppDelegate.h"

#import "MFSideMenu.h"
#import "OMBMenuViewController.h"
#import "OMBTabBarController.h"
#import "UIColor+Extensions.h"

@implementation OMBAppDelegate

@synthesize menuContainer    = _menuContainer;
@synthesize rightMenu        = _rightMenu;
@synthesize tabBarController = _tabBarController;

- (BOOL) application: (UIApplication *) application 
didFinishLaunchingWithOptions: (NSDictionary *) launchOptions
{
  CGRect screen = [[UIScreen mainScreen] bounds];
  self.window   = [[UIWindow alloc] initWithFrame: screen];

  // View controllers
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

  return YES;
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

@end
