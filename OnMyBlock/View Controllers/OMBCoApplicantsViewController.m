//
//  OMBCoApplicantsViewController.m
//  OnMyBlock
//
//  Created by Morgan Schwanke on 12/2/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBCoApplicantsViewController.h"

@implementation OMBCoApplicantsViewController

#pragma mark - Initializer

- (id) init
{
	if (!(self = [super init])) return nil;

	self.screenName = self.title = @"Co-applicants";

	return self;
}

@end
