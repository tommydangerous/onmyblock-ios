//
//  OMBRenterInfoAddViewController.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 3/11/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBRenterInfoAddViewController.h"

@interface OMBRenterInfoAddViewController ()

@end

@implementation OMBRenterInfoAddViewController

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

  self.navigationItem.leftBarButtonItem  = cancelBarButtonItem;
  self.navigationItem.rightBarButtonItem = saveBarButtonItem;
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) cancel
{
  [self.navigationController dismissViewControllerAnimated: YES
    completion: nil];
}

- (void) save
{
  [self cancel];
}
  
@end
