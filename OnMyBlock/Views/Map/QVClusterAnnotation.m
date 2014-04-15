//
//  QVClusterAnnotation.m
//  MapCluster
//
//  Created by Tommy DANGerous on 4/15/14.
//  Copyright (c) 2014 Quantum Ventures. All rights reserved.
//

#import "QVClusterAnnotation.h"

@implementation QVClusterAnnotation

#pragma mark - Initializer

- (id) initWithCoordinate: (CLLocationCoordinate2D) coordinate
count: (NSInteger) count
{
  return [self initWithCoordinate: coordinate count: count
    coordinates: [NSArray array]];
}

- (id) initWithCoordinate: (CLLocationCoordinate2D) coordinate
count: (NSInteger) count coordinates: (NSArray *) array
{
  if (!(self = [super init])) return nil;

  _coordinate  = coordinate;
  _coordinates = array;
  _count       = count;
  _title       = [NSString stringWithFormat: @"%d places", _count];

  return self;
}

#pragma mark - Override

#pragma mark - Override NSObject

- (NSUInteger) hash
{
  NSString *toHash = [NSString stringWithFormat: @"%.5f%.5f",
    self.coordinate.latitude, self.coordinate.longitude];
  return [toHash hash];
}

- (BOOL) isEqual: (id) object
{
  return [self hash] == [object hash];
}

@end
