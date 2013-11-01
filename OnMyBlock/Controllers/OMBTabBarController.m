//
//  OMBTabBarController.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 10/18/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBTabBarController.h"

#import "OMBFavoritesListViewController.h"
#import "OMBLoginViewController.h"
#import "OMBMapViewController.h"
#import "OMBNavigationController.h"
#import "OMBUser.h"

@implementation OMBTabBarController

@synthesize favoritesViewController = _favoritesViewController;
@synthesize mapViewController       = _mapViewController;

#pragma mark Initializer

- (id) init
{
  if (!(self = [super init])) return nil;
  
  CGRect screen = [[UIScreen mainScreen] bounds];
  // Hide UITabBar
  CGRect frame      = self.tabBar.frame;
  frame.origin.y    = screen.size.height;
  self.tabBar.frame = frame;
  // View controllers
  _favoritesViewController = 
    [[OMBNavigationController alloc] initWithRootViewController:
      [[OMBFavoritesListViewController alloc] init]];
  _mapViewController = 
    [[OMBNavigationController alloc] initWithRootViewController: 
      [[OMBMapViewController alloc] init]];

  self.viewControllers = @[
    _mapViewController
  ];

  [[NSNotificationCenter defaultCenter] addObserver: self
    selector: @selector(switchToMapViewController)
      name: OMBUserLoggedOutNotification object: nil];

  return self;
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) switchToMapViewController
{
  if (self.selectedViewController == _favoritesViewController)
    [self switchToViewController: _mapViewController];
}

- (void) switchToViewController: (OMBNavigationController *) vc
{
  self.viewControllers        = @[self.selectedViewController, vc];
  self.selectedViewController = vc;
}

@end
