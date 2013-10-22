//
//  OMBResidenceDetailViewController.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 10/21/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBResidenceDetailViewController.h"

#import "OMBResidence.h"

@implementation OMBResidenceDetailViewController

#pragma mark - Initializer

- (id) initWithResidence: (OMBResidence *) object
{
  self = [super init];
  if (self) {
    residence  = object;
    self.title = residence.address;
  }
  return self;
}

@end
