//
//  OMBFinishListingSectionViewController.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/27/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBFinishListingSectionViewController.h"

#import "OMBFinishListingViewController.h"
#import "OMBResidence.h"

@implementation OMBFinishListingSectionViewController

#pragma mark - Initializer

- (id) initWithResidence: (OMBResidence *) object
{
  if (!(self = [super init])) return nil;

  residence = object;

  self.screenName = self.title = @"Finish Listing Section";

  return self;
}

#pragma mark - Override

#pragma mark - Override UIViewController

- (void) loadView
{
  [super loadView];
  
  UIFont *boldFont = [UIFont boldSystemFontOfSize: 17];
  saveBarButtonItem = [[UIBarButtonItem alloc] initWithTitle: @"Save"
    style: UIBarButtonItemStylePlain target: self action: @selector(save)];
  saveBarButtonItem.enabled = NO;
  [saveBarButtonItem setTitleTextAttributes: @{
    NSFontAttributeName: boldFont
  } forState: UIControlStateNormal];
  
  nextSection = NO;
}

-(void) dealloc
{
  NSLog(@"dealloc");
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  
  NSString *barButtonTitle =
    [self hasIncompleteSections] ? @"Next": @"Save";
  saveBarButtonItem.title = barButtonTitle;
}

- (void) viewDidDisappear:(BOOL)animated
{
  [super viewDidDisappear:animated];
  
  if(nextSection)
    [self.delegate nextIncompleteSection];
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) save
{
  // Subclasses implement this
  nextSection = YES;
  [self.navigationController popViewControllerAnimated: YES];
}

- (BOOL)hasIncompleteSections
{
  BOOL has = NO;
  // Title
  if (![residence.title length])
    has = YES;
  // Description
  if (![residence.description length])
    has = YES;
  // Rent / Auction Details
  if (!residence.minRent)
    has = YES;
  // Address
  if (![residence.address length])
    has = YES;
  // Lease Details
  if (!residence.moveInDate)
    has = YES;
  // Listing Details
  if (!residence.bedrooms)
    has = YES;
  return has;
}

@end
