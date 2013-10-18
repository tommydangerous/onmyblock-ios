//
//  OMBAnnotation.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 10/18/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBAnnotation.h"

@implementation OMBAnnotation

@synthesize coordinate = _coordinate;

#pragma mark - Setters

- (void) setCoordinate: (CLLocationCoordinate2D) coord
{
  _coordinate = coord;
}

@end
