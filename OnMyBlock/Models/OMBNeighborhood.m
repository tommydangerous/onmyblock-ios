//
//  OMBNeighborhood.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 10/22/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBNeighborhood.h"

@implementation OMBNeighborhood

@synthesize coordinate = _coordinate;
@synthesize name       = _name;

#pragma mark - Methods

#pragma mark - Instance Methods

- (NSString *) nameTitle
{
  return [_name capitalizedString];
}

@end
