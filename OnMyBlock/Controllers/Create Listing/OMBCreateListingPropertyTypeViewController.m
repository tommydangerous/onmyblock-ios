//
//  OMBCreateListingPropertyTypeViewController.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/26/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBCreateListingPropertyTypeViewController.h"

@implementation OMBCreateListingPropertyTypeViewController

#pragma mark - Initializer

- (id) init
{
  if (!(self = [super init])) return nil;

  self.screenName = @"Create Listing Property Type";
  self.title      = @"Type of Place";

  return self;
}

@end
