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
  self = [super init];
  if (self) {
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
  }
  return self;
}

@end
