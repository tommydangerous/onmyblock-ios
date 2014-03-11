//
//  OMBAmenityStore.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 3/10/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBAmenityStore.h"

@interface OMBAmenityStore ()
{
  NSDictionary *amenities;
}

@end

@implementation OMBAmenityStore

#pragma mark - Initializer

- (id) init
{
  if (!(self = [super init])) return nil;

  amenities = @{
    @"basics": @[
      @"air conditioning",
      @"ceiling fans",
      @"central heating",
      @"dishwasher",
      @"driveway",
      @"full kitchen",
      @"fully furnished",
      @"garage",
      @"garbage disposal",
      @"street parking",
      @"washer/dryer"
    ],
    @"extras": @[
      @"fireplace",
      @"hard floors",
      @"gym",
      @"jacuzzi",
      @"newly remodeled",
      @"pool",
      @"quiet location",
      @"smoking allowed",
      @"storage",
    ],
    @"outdoors": @[
      @"backyard",
      @"barbequeue",
      @"fence",
      @"front yard",
      @"patio/balcony",
      @"shared courtyard"
    ],
    @"pets": @[
      @"cats allowed",
      @"dogs allowed"
    ],
    @"accessibility": @[
      @"handicap friendly",
      @"elevator",
      @"wheelchair ramps"
    ]
  };

  return self;
}

#pragma mark - Methods

#pragma mark - Class Methods

+ (OMBAmenityStore *) sharedStore
{
  static OMBAmenityStore *store = nil;
  if (!store)
    store = [[OMBAmenityStore alloc] init];
  return store;
}

#pragma mark - Instance Methods

- (NSArray *) allAmenities
{
  NSMutableArray *array = [NSMutableArray array];
  for (NSString *category in [self categories]) {
    for (NSString *amenity in [self amenitiesForCategory: category]) {
      [array addObject: amenity];
    }
  }
  return (NSArray *) array;
}

- (NSArray *) amenitiesForCategory: (NSString *) category
{
  return [[amenities objectForKey: category] sortedArrayUsingComparator: 
    ^(id obj1, id obj2) {
      if (obj1 > obj2)
        return (NSComparisonResult) NSOrderedDescending;
      if (obj1 < obj2)
        return (NSComparisonResult) NSOrderedAscending;
      return (NSComparisonResult) NSOrderedSame;
    }];
}

- (NSArray *) categories
{
  return [amenities allKeys];
}

@end
