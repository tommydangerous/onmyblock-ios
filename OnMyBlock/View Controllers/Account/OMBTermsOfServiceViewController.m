//
//  OMBTermsOfServiceViewController.m
//  OnMyBlock
//
//  Created by Tommy Dang on 12/2/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBTermsOfServiceViewController.h"

#import "OMBTermsOfServiceStore.h"

@implementation OMBTermsOfServiceViewController

#pragma mark - Initializer

- (id) init
{
	if (!(self = [super init])) return nil;

  self.storeArray = [OMBTermsOfServiceStore sharedStore].sections;

	self.screenName = self.title = @"Terms of Service";

	return self;
}

@end
