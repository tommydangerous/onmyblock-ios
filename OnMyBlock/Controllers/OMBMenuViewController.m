//
//  OMBMenuViewController.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 10/25/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBMenuViewController.h"

#import "UIColor+Extensions.h"

@interface OMBMenuViewController ()

@end

@implementation OMBMenuViewController

#pragma mark - Initializer

- (id) init
{
  if (!(self = [super init])) return nil;

  return self;
}

#pragma mark - Override

#pragma mark - Override UIViewController

- (void) loadView
{
  [super loadView];
  CGRect screen = [[UIScreen mainScreen] bounds];
  // View
  self.view = [[UIView alloc] init];
  self.view.frame = screen;
  // Background view
  UIView *backgroundView         = [[UIView alloc] init];
  backgroundView.frame           = screen;
  backgroundView.backgroundColor = [UIColor grayDark];
  [self.view addSubview: backgroundView];
}

@end
