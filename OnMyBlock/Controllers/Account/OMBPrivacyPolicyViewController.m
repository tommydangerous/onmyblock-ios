//
//  OMBPrivacyPolicyViewController.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/2/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBPrivacyPolicyViewController.h"

#import "OMBPrivacyPolicyStore.h"

@implementation OMBPrivacyPolicyViewController

#pragma mark - Initializer

- (id) init
{
  if (!(self = [super init])) return nil;

  self.storeArray = [OMBPrivacyPolicyStore sharedStore].sections;

  self.screenName = self.title = @"Privacy Policy";

  return self;
}

@end
