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
  if (!([super initWithRootViewController: viewController])) return nil;
  
  // self.navigationBar.barTintColor = [UIColor backgroundColor];
  self.navigationBar.tintColor    = [UIColor blue];
  self.navigationBar.translucent  = YES;
  
  return self;
}

@end
