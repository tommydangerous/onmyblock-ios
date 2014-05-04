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
  if (!(self = [super initWithRootViewController: viewController])) return nil;

  self.delegate = self;
  // self.navigationBar.barTintColor = [UIColor backgroundColor];
  self.navigationBar.tintColor    = [UIColor blue];
  self.navigationBar.translucent  = YES;

  return self;
}

- (id) initWithRootViewControllerTransparentNavigationBar:
(UIViewController *) viewController
{
  if (!(self = [self initWithRootViewController: viewController])) return nil;

  [self.navigationBar setBackgroundImage: [UIImage new]
    forBarMetrics: UIBarMetricsDefault];
  self.navigationBar.shadowImage = [UIImage new];
  self.navigationBar.translucent = YES;

  return self;
}

#pragma mark - Protocol

#pragma mark - Protocol UINavigationController

- (void) navigationController: (UINavigationController *) navigationController
        didShowViewController: (UIViewController *) viewController
                     animated: (BOOL) animated
{
  if (_completionBlock) {
    _completionBlock();
    _completionBlock = nil;
  }
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) pushViewController: (UIViewController *) viewController
animated: (BOOL) animated completion: (dispatch_block_t) completion
{
  _completionBlock = completion;
  [super pushViewController: viewController animated: animated];
}

@end
