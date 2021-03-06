//
//  OMBResidenceListStore.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 1/16/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBResidenceListStore.h"

// Models
#import "OMBResidence.h"

// Networking
#import "OMBSessionManager.h"

@interface OMBResidenceListStore ()
{
  NSMutableArray *residenceArray;
  NSURLSessionDataTask *sessionDataTask;
}

@end

@implementation OMBResidenceListStore

#pragma mark - Initializer

- (id) init
{
  if (!(self = [super init])) return nil;

  residenceArray  = [NSMutableArray array];
  self.residences = [NSMutableDictionary dictionary];

  return self;
}

#pragma mark - Methods

#pragma mark - Class Methods

+ (OMBResidenceListStore *) sharedStore
{
  static OMBResidenceListStore *store = nil;

  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    store = [[OMBResidenceListStore alloc] init];
  });

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

- (void)cancelConnection
{
  if (sessionDataTask) {
    [sessionDataTask cancel];
  }
}

- (void)fetchResidencesWithParameters:(NSDictionary *)dictionary
delegate:(id<OMBResidenceListStoreDelegate>)delegate
{
  sessionDataTask = [[OMBSessionManager sharedManager] GET:@"places/grid" 
    parameters:dictionary
    success:^(NSURLSessionDataTask *task, id responseObject) {
      if ([delegate respondsToSelector:
        @selector(fetchResidencesForListSucceeded:)]) {
        [delegate fetchResidencesForListSucceeded:responseObject];
      }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
      if ([delegate respondsToSelector:
        @selector(fetchResidencesForListFailed:)]) {
        [delegate fetchResidencesForListFailed:error];
      }
    }
  ];
}

- (void) readFromDictionary: (NSDictionary *) dictionary
{
  // NSLog(@"%@", dictionary);
  for (NSDictionary *dict in [dictionary objectForKey: @"objects"]) {
    OMBResidence *residence = [[OMBResidence alloc] init];
    [residence readFromDictionaryLightning: dict];
    // Add to array and dictionary
    [residenceArray addObject: residence];
    [self addResidence: residence];

    // OMBResidence *residence = [[OMBResidence alloc] init];
    // [residence readFromResidenceDictionary: dict];
    // [self addResidence: residence];
  }
}

- (void) removeResidences
{
  [residenceArray removeAllObjects];
  [self.residences removeAllObjects];
}

- (NSArray *) residenceArray
{
  return [NSArray arrayWithArray: residenceArray];
}

- (NSArray *) sortedResidencesByDistanceFromCoordinate: 
  (CLLocationCoordinate2D) coordinate
{
  return [[self.residences allValues] sortedArrayUsingComparator: 
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
  // MKMapPoint p1 = MKMapPointForCoordinate(coord1);
  // MKMapPoint p2 = MKMapPointForCoordinate(coord2);
  // CLLocationDistance dist = MKMetersBetweenMapPoints(p1, p2);
}

- (NSArray *) sortedResidencesWithKey: (NSString *) string
ascending: (BOOL) ascending
{
  NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey: string
    ascending: ascending];
  return [[_residences allValues] sortedArrayUsingDescriptors: @[sort]];
}

@end
