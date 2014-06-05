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
  
}

-(void) dealloc
{
  NSLog(@"dealloc");
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  
  self.delegate.nextSection = NO;
  
  NSString *barButtonTitle =
    [self incompleteSections] > 0 ? @"Next": @"Save";
  
  if([self incompleteSections] == 1 &&
     [self lastIncompleteSection] == tagSection){
    barButtonTitle = @"Save";
    NSLog(@"last and unique");
  }
  
  saveBarButtonItem.title = barButtonTitle;
}

- (void) viewDidDisappear:(BOOL)animated
{
  [super viewDidDisappear:animated];
  
  //if(nextSection)
    //[self.delegate nextIncompleteSection];
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (int)incompleteSections
{
  int incompletes = 0;
  // Title
  if (![residence.title length])
    incompletes += 1;
  // Description
  if (![residence.description length])
    incompletes += 1;
  // Rent / Auction Details
  if (!residence.minRent)
    incompletes += 1;
  // Address
  if (![residence.address length] || ![residence.city length] ||
      ![residence.state length] || ![residence.zip length])
    incompletes += 1;
  // Lease Details
  if (!residence.moveInDate)
    incompletes += 1;
  // Listing Details
  if (!residence.bedrooms)
    incompletes += 1;
  
  return incompletes;
}

- (OMBFinishListingSection)lastIncompleteSection
{
  
  if (![residence.title length])
    return OMBFinishListingSectionTitle;
  // Description
  if (![residence.description length])
    return OMBFinishListingSectionDescription;
  // Rent / Auction Details
  if (!residence.minRent)
    return OMBFinishListingSectionRentDetails;
  // Address
  if (![residence.address length] || ![residence.city length] ||
      ![residence.state length] || ![residence.zip length])
    return OMBFinishListingSectionAddress;
  // Lease Details
  if (!residence.moveInDate)
    return OMBFinishListingSectionLeaseDetails;
  // Listing Details
  if (!residence.bedrooms)
    return OMBFinishListingSectionListingDetails;
  
  return OMBFinishListingSectionNone;
  
}

- (void) nextSection
{
  BOOL animated = YES;
  if([self incompleteSections] > 0){
    animated = NO;
    self.delegate.nextSection = YES;
  }
  
  [self.navigationController popViewControllerAnimated: animated];
}

- (void) save
{
  // Subclasses implement this
  [self nextSection];
}

@end
