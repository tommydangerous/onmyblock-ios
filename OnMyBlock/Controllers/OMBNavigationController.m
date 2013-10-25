//
//  OMBNavigationController.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 10/18/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBNavigationController.h"

#import "UIColor+Extensions.h"

@implementation OMBNavigationController

#pragma mark - Initializer

- (id) initWithRootViewController: (UIViewController *) viewController
{
  self = [super initWithRootViewController: viewController];
  if (self) {
    // self.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationBar.tintColor    = [UIColor blue];
  }
  return self;
}

@end
