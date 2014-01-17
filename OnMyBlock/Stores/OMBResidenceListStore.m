//
//  OMBResidenceListStore.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 1/16/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBResidenceListStore.h"

#import "OMBResidence.h"
#import "OMBResidenceListConnection.h"

@implementation OMBResidenceListStore

#pragma mark - Initializer

- (id) init
{
  if (!(self = [super init])) return nil;

  _residences = [NSMutableArray array];

  return self;
}

#pragma mark - Methods

#pragma mark - Class Methods

+ (OMBResidenceListStore *) sharedStore
{
  static OMBResidenceListStore *store = nil;
  if (!store)
    store = [[OMBResidenceListStore alloc] init];
  return store;
}

#pragma mark - Instance Methods

- (void) addResidence: (OMBResidence *) residence
{
  NSPredicate *predicate = [NSPredicate predicateWithFormat: @"%K == %i",
    @"uid", residence.uid];
  if ([[_residences filteredArrayUsingPredicate: predicate] count] == 0)
    [_residences addObject: residence];
}

- (void) fetchResidencesWithParameters: (NSDictionary *) dictionary
completion: (void (^) (NSError *error)) block
{
  OMBResidenceListConnection *conn = 
    [[OMBResidenceListConnection alloc] initWithParameters: dictionary];
  conn.completionBlock = block;
  [conn start];
}

- (void) readFromDictionary: (NSDictionary *) dictionary
{
  for (NSDictionary *dict in [dictionary objectForKey: @"objects"]) {
    OMBResidence *residence = [[OMBResidence alloc] init];
    [residence readFromResidenceDictionary: dict];
    [self addResidence: residence];
  }
}

- (NSArray *) sortedResidencesByDistance
{
  // MKMapPoint p1 = MKMapPointForCoordinate(coord1);
  // MKMapPoint p2 = MKMapPointForCoordinate(coord2);
  // CLLocationDistance dist = MKMetersBetweenMapPoints(p1, p2);
  return [NSArray array];
}

@end
