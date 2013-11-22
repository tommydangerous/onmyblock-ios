//
//  OMBNeighborhoodStore.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 10/22/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBNeighborhoodStore.h"

#import "OMBNeighborhood.h"

@implementation OMBNeighborhoodStore

@synthesize neighborhoods = _neighborhoods;

#pragma mark - Initializer

- (id) init
{
  self = [super init];
  if (self) {
    _neighborhoods = [NSDictionary dictionary];

    OMBNeighborhood *currentLocation = [[OMBNeighborhood alloc] init];
    currentLocation.coordinate = CLLocationCoordinate2DMake(0, 0);
    currentLocation.name       = @"current location";

    OMBNeighborhood *downtown = [[OMBNeighborhood alloc] init];
    downtown.coordinate = CLLocationCoordinate2DMake(32.7153292, -117.1572551);
    downtown.name       = @"downtown";

    OMBNeighborhood *hillcrest = [[OMBNeighborhood alloc] init];
    hillcrest.coordinate = CLLocationCoordinate2DMake(32.7478638, -117.1647094);
    hillcrest.name       = @"hillcrest";

    OMBNeighborhood *laJolla = [[OMBNeighborhood alloc] init];
    laJolla.coordinate = CLLocationCoordinate2DMake(32.84722, -117.27333);
    laJolla.name       = @"la jolla";

    OMBNeighborhood *missionBeach = [[OMBNeighborhood alloc] init];
    missionBeach.coordinate = CLLocationCoordinate2DMake(32.7706526, 
      -117.2514447);
    missionBeach.name       = @"mission beach";

    OMBNeighborhood *missionValley = [[OMBNeighborhood alloc] init];
    missionValley.coordinate = CLLocationCoordinate2DMake(32.7670907, 
      -117.1623501);
    missionValley.name       = @"mission valley";

    OMBNeighborhood *oceanBeach = [[OMBNeighborhood alloc] init];
    oceanBeach.coordinate = CLLocationCoordinate2DMake(32.7494988, 
      -117.2470353);
    oceanBeach.name       = @"ocean beach";

    OMBNeighborhood *pacificBeach = [[OMBNeighborhood alloc] init];
    pacificBeach.coordinate = CLLocationCoordinate2DMake(32.806374, 
      -117.2382163);
    pacificBeach.name       = @"pacific beach";

    OMBNeighborhood *utc = [[OMBNeighborhood alloc] init];
    utc.coordinate = CLLocationCoordinate2DMake(32.8577324, 
      -117.2054294);
    utc.name       = @"university towne center";

    _neighborhoods = @{
      currentLocation.name: currentLocation,
      downtown.name: downtown,
      hillcrest.name: hillcrest,
      laJolla.name: laJolla,
      missionBeach.name: missionBeach,
      missionValley.name: missionValley,
      oceanBeach.name: oceanBeach,
      pacificBeach.name: pacificBeach,
      utc.name: utc
    };
  }
  return self;
}

#pragma mark - Methods

#pragma mark - Class Methods

+ (OMBNeighborhoodStore *) sharedStore
{
  static OMBNeighborhoodStore *store = nil;
  if (!store)
    store = [[OMBNeighborhoodStore alloc] init];
  return store;
}

#pragma mark - Instance Methods

- (NSArray *) sortedNeighborhoods
{
  NSArray *keys = [[_neighborhoods allKeys] sortedArrayUsingSelector:
    @selector(localizedCaseInsensitiveCompare:)];
  NSMutableArray *array = [NSMutableArray array];
  for (NSString *key in keys) {
    [array addObject: [_neighborhoods objectForKey: key]];
  }
  return array;
}

@end
