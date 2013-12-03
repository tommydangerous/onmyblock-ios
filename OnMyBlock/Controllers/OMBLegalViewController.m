//
//  OMBLegalViewController.m
//  OnMyBlock
//
//  Created by Morgan Schwanke on 12/2/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBLegalViewController.h"

@implementation OMBLegalViewController

#pragma mark - Initializer

- (id) init
{
	if (!(self = [super init])) return nil;

	self.screenName = self.title = @"Legal";

	return self;
}

@end
