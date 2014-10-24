//
//  OMBStandardLeaseViewController.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 1/2/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBStandardLeaseViewController.h"

#import "OMBTermsOfServiceStore.h"

@implementation OMBStandardLeaseViewController

#pragma mark - Initializer

- (id) init
{
  if (!(self = [super init])) return nil;

  self.storeArray = [OMBTermsOfServiceStore sharedStore].sections;

  self.screenName = self.title = @"OMB Standard Lease";

  return self;
}

@end
