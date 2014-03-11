//
//  OMBRenterInfoSectionCosignersViewController.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 3/11/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBRenterInfoSectionCosignersViewController.h"

#import "OMBRenterInfoAddViewController.h"

@interface OMBRenterInfoSectionCosignersViewController ()

@end

@implementation OMBRenterInfoSectionCosignersViewController

#pragma mark - Initializer

- (id) initWithUser: (OMBUser *) object
{
  if (!(self = [super initWithUser: object])) return nil;

  addViewController = [[OMBRenterInfoAddViewController alloc] init];
  self.title = @"Co-signers";

  return self;
}

#pragma mark - Override

#pragma mark - Override UIViewController

- (void) loadView
{
  [super loadView];
  
  [self setEmptyLabelText: @"You have no co-signers.\nAdding a co-signer "
    @"will greatly increase your acceptance rate."];

  [addButton setTitle: @"Add Co-signer" forState: UIControlStateNormal];
}

#pragma mark - Methods

#pragma mark - Instance Methods

@end
