//
//  OMBTabBarController.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 10/18/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBTabBarController.h"

#import "OMBMapViewController.h"
#import "OMBNavigationController.h"

@implementation OMBTabBarController

@synthesize mapViewController = _mapViewController;

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
  _mapViewController = 
    [[OMBNavigationController alloc] initWithRootViewController: 
      [[OMBMapViewController alloc] init]];

  self.viewControllers = @[
    _mapViewController
  ];

  return self;
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) switchToViewController: (UIViewController *) vc
{
  self.viewControllers = [NSArray arrayWithObjects: 
    self.selectedViewController, vc, nil];
  self.selectedViewController = vc;
}

@end
