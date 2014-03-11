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

@interface OMBResidenceListStore ()
{
  OMBResidenceListConnection *listConnection;
}

@end

@implementation OMBResidenceListStore

#pragma mark - Initializer

- (id) init
{
  if (!(self = [super init])) return nil;

  _residences = [NSMutableDictionary dictionary];

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
  NSNumber *key = [NSNumber numberWithInt: residence.uid];
  if (![_residences objectForKey: key])
    [_residences setObject: residence forKey: key];
  // NSPredicate *predicate = [NSPredicate predicateWithFormat: @"%K == %i",
  //   @"uid", residence.uid];
  // if ([[_residences filteredArrayUsingPredicate: predicate] count] == 0)
  //   [_residences addObject: residence];
}

- (void) cancelConnection
{
  if (listConnection) {
    [listConnection cancelConnection];
    listConnection = nil;
  }
}

- (void) fetchResidencesWithParameters: (NSDictionary *) parameters
delegate: (id) delegate completion: (void (^) (NSError *error)) block
{
  listConnection = [[OMBResidenceListConnection alloc] initWithParameters: 
    parameters];
  listConnection.completionBlock = block;
  listConnection.delegate        = delegate;
  [listConnection start];
}

- (void) readFromDictionary: (NSDictionary *) dictionary
{
  for (NSDictionary *dict in [dictionary objectForKey: @"objects"]) {
    OMBResidence *residence = [[OMBResidence alloc] init];
    [residence readFromResidenceDictionary: dict];
    [self addResidence: residence];
  }
}

- (NSArray *) sortedResidencesByDistanceFromCoordinate: 
  (CLLocationCoordinate2D) coordinate
{
  // MKMapPoint p1 = MKMapPointForCoordinate(coord1);
  // MKMapPoint p2 = MKMapPointForCoordinate(coord2);
  // CLLocationDistance dist = MKMetersBetweenMapPoints(p1, p2);
  return [[_residences allValues] sortedArrayUsingComparator: 
    ^(id obj1, id obj2) {
      MKMapPoint center = MKMapPointForCoordinate(coordinate);

      // Residence 1
      OMBResidence *res1 = (OMBResidence *) obj1;
      CLLocationCoordinate2D coord1 = CLLocationCoordinate2DMake(res1.latitude,
        res1.longitude);
      MKMapPoint p1 = MKMapPointForCoordinate(coord1);
      CLLocationDistance dist1 = MKMetersBetweenMapPoints(p1, center);

      // Residence 2
      OMBResidence *res2 = (OMBResidence *) obj2;
      CLLocationCoordinate2D coord2 = CLLocationCoordinate2DMake(res2.latitude,
        res2.longitude);
      MKMapPoint p2 = MKMapPointForCoordinate(coord2);
      CLLocationDistance dist2 = MKMetersBetweenMapPoints(p2, center);

      if (dist1 > dist2)
        return (NSComparisonResult) NSOrderedDescending;
      if (dist1 < dist2)
        return (NSComparisonResult) NSOrderedAscending;
      return (NSComparisonResult) NSOrderedSame;
    }];
}

- (NSArray *) sortedResidencesWithKey: (NSString *) string
ascending: (BOOL) ascending
{
  NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey: string
    ascending: ascending];
  return [[_residences allValues] sortedArrayUsingDescriptors: @[sort]];
}

@end
