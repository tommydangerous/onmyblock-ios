//
//  OMBResidenceMapStore.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 3/6/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBResidenceMapStore.h"

#import "OMBAllResidenceStore.h"
#import "OMBAnnotation.h"
#import "OMBResidence.h"
#import "OMBResidenceListConnection.h"

const NSUInteger MAX_ANNOTATIONS = 500;

@interface OMBResidenceMapStore ()
{
  NSMutableArray *annotations;
}

@end

@implementation OMBResidenceMapStore

#pragma mark - Initializer

- (id) init
{
  if (!(self = [super init])) return nil;

  annotations = [NSMutableArray array];

  return self;
}

#pragma mark - Methods

#pragma mark - Class Methods

+ (OMBResidenceMapStore *) sharedStore
{
  static OMBResidenceMapStore *store = nil;
  if (!store)
    store = [[OMBResidenceMapStore alloc] init];
  return store;
}

#pragma mark - Instance Methods

- (NSArray *) annotations
{
  return [NSArray arrayWithArray: annotations];
}

- (void) fetchResidencesWithParameters: (NSDictionary *) parameters
delegate: (id) delegate completion: (void (^) (NSError *error)) block
{
  OMBResidenceListConnection *conn = 
    [[OMBResidenceListConnection alloc] initWithParameters: parameters];
  conn.completionBlock = block;
  conn.delegate        = delegate;
  [conn start];
}

- (void) readFromDictionary: (NSDictionary *) dictionary
{
  [annotations removeAllObjects];
  NSArray *array = [dictionary objectForKey: @"objects"];
  if ([array count] > MAX_ANNOTATIONS) {
    array = [array subarrayWithRange: NSMakeRange(0, MAX_ANNOTATIONS)];
  }
  for (NSDictionary *dict in array) {
    // Create residence
    NSUInteger residenceUID = [[dict objectForKey: @"id"] intValue];
    OMBResidence *residence = 
      [[OMBAllResidenceStore sharedStore] residenceForUID: residenceUID];
    if (!residence)
      residence = [[OMBResidence alloc] init];
    [residence readFromResidenceDictionary: dict];
    // Create annotation
    OMBAnnotation *annotation = [[OMBAnnotation alloc] init];
    annotation.coordinate = CLLocationCoordinate2DMake(
      residence.latitude, residence.longitude);;
    annotation.residenceUID = residence.uid;
    // Add to annotations set
    [annotations addObject: annotation];
  }
}

@end
