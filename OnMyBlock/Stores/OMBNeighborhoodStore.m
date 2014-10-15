//
//  OMBNeighborhoodStore.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 10/22/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBNeighborhoodStore.h"

#import "OMBNeighborhood.h"
#import "NSString+Extensions.h"

@implementation OMBNeighborhoodStore

#pragma mark - Initializer

- (id) init
{
  if (!(self = [super init])) return nil;

  // San Diego
  // Schools
  // Point Loma University
  OMBNeighborhood *ptLoma = [[OMBNeighborhood alloc] init];
  ptLoma.coordinate = CLLocationCoordinate2DMake(32.7169, -117.2507);
  ptLoma.name = @"Pt. Loma University";
  // San Diego State University
  OMBNeighborhood *sdsu = [[OMBNeighborhood alloc] init];
  sdsu.coordinate = CLLocationCoordinate2DMake(32.7753, -117.0722);
  sdsu.name = @"San Diego State Univeristy";
  // University of California - San Diego
  OMBNeighborhood *ucsd = [[OMBNeighborhood alloc] init];
  ucsd.coordinate = CLLocationCoordinate2DMake(32.8810, -117.2380);
  ucsd.name = @"UC San Diego";
  // Univeristy of San Diego
  OMBNeighborhood *usd = [[OMBNeighborhood alloc] init];
  usd.coordinate = CLLocationCoordinate2DMake(32.7719, -117.1878);
  usd.name = @"University of San Diego";
  // Neighborhoods
  // Downtown
  OMBNeighborhood *downtown = [[OMBNeighborhood alloc] init];
  downtown.coordinate = CLLocationCoordinate2DMake(32.7153292, -117.1572551);
  downtown.name = @"Downtown";
  // Hillcrest
  OMBNeighborhood *hillcrest = [[OMBNeighborhood alloc] init];
  hillcrest.coordinate = CLLocationCoordinate2DMake(32.7478638, -117.1647094);
  hillcrest.name = @"Hillcrest";
  // La Jolla
  OMBNeighborhood *laJolla = [[OMBNeighborhood alloc] init];
  laJolla.coordinate = CLLocationCoordinate2DMake(32.84722, -117.27333);
  laJolla.name = @"La Jolla";
  // Mission Beach
  OMBNeighborhood *missionBeach = [[OMBNeighborhood alloc] init];
  missionBeach.coordinate = CLLocationCoordinate2DMake(32.7706526, 
    -117.2514447);
  missionBeach.name = @"Mission Beach";
  // Mission Valley
  OMBNeighborhood *missionValley = [[OMBNeighborhood alloc] init];
  missionValley.coordinate = CLLocationCoordinate2DMake(32.7670907, 
    -117.1623501);
  missionValley.name = @"Mission Valley";
  // Ocean Beach
  OMBNeighborhood *oceanBeach = [[OMBNeighborhood alloc] init];
  oceanBeach.coordinate = CLLocationCoordinate2DMake(32.7494988, 
    -117.2470353);
  oceanBeach.name = @"Ocean Beach";
  // Pacific Beach
  OMBNeighborhood *pacificBeach = [[OMBNeighborhood alloc] init];
  pacificBeach.coordinate = CLLocationCoordinate2DMake(32.806374, 
    -117.2382163);
  pacificBeach.name = @"Pacific Beach";
  // University Towne Center
  OMBNeighborhood *utc = [[OMBNeighborhood alloc] init];
  utc.coordinate = CLLocationCoordinate2DMake(32.8577324, 
    -117.2054294);
  utc.name = @"University Towne Center";

  // San Luis Obispo
  // Schools
  // Cal Poly SLO
  OMBNeighborhood *calPolySlo = [[OMBNeighborhood alloc] init];
  calPolySlo.coordinate = CLLocationCoordinate2DMake(35.3017, -120.6598);
  calPolySlo.name = @"Cal Poly SLO";
  // Cuesta College
  OMBNeighborhood *cuestaCollege = [[OMBNeighborhood alloc] init];
  cuestaCollege.coordinate = CLLocationCoordinate2DMake(35.3300, -120.7424);
  cuestaCollege.name = @"Cuesta College";

  OMBNeighborhood *berkeley = [[OMBNeighborhood alloc] init];
  berkeley.coordinate = CLLocationCoordinate2DMake(37.871519, -122.260401);
  berkeley.name       = @"University of California - Berkeley";

  OMBNeighborhood *usc = [[OMBNeighborhood alloc] init];
  usc.coordinate = CLLocationCoordinate2DMake(34.021058, -118.283858);
  usc.name       = @"University of Southern California";

  self.neighborhoods = @{
    @"berkeley": @{
      @"schools": @{
        [berkeley nameKey]: berkeley
      }
    },
    @"san diego": @{
      @"schools": @{
        [ptLoma nameKey]: ptLoma,
        [sdsu nameKey]:   sdsu,
        [ucsd nameKey]:   ucsd,
        [usd nameKey]:    usd
      },
      @"neighborhoods": @{
        [downtown nameKey]:      downtown,
        [hillcrest nameKey]:     hillcrest,
        [laJolla nameKey]:       laJolla,
        [missionBeach nameKey]:  missionBeach,
        [missionValley nameKey]: missionValley,
        [oceanBeach nameKey]:    oceanBeach,
        [pacificBeach nameKey]:  pacificBeach,
        [utc nameKey]:           utc
      }
    },
    @"san luis obispo": @{
      @"schools": @{
        [calPolySlo nameKey]:    calPolySlo,
        [cuestaCollege nameKey]: cuestaCollege
      }
    },
    @"southern california": @{
      @"schools": @{
        [usc nameKey]: usc
      }
    }
  };

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

- (NSArray *) cities
{
  return [[self.neighborhoods allKeys] sortedArrayUsingSelector:
    @selector(localizedCaseInsensitiveCompare:)];
}

- (NSArray *) sortedNeighborhoodsForCity: (NSString *) string
{
  NSDictionary *city          = [self.neighborhoods objectForKey: string];
  NSDictionary *schools       = [city objectForKey: @"schools"];
  NSDictionary *neighborhoods = [city objectForKey: @"neighborhoods"];

  NSMutableArray *array = [NSMutableArray array];
  // Schools
  NSArray *schoolKeys = [[schools allKeys] sortedArrayUsingSelector:
    @selector(localizedCaseInsensitiveCompare:)];
  for (NSString *key in schoolKeys) {
    [array addObject: [schools objectForKey: key]];
  }
  // Neighborhoods
  NSArray *neighborhoodKeys = [[neighborhoods allKeys] sortedArrayUsingSelector:
    @selector(localizedCaseInsensitiveCompare:)];
  for (NSString *key in neighborhoodKeys) {
    [array addObject: [neighborhoods objectForKey: key]];
  }
  return array;
}

- (NSDictionary *) sortedNeighborhoodsForName: (NSString *) string
{
  NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
  
  for(NSString *keyCity in [self cities]){
    BOOL found = NO;
    NSDictionary *city          = [self.neighborhoods objectForKey: keyCity];
    NSDictionary *schools       = [city objectForKey: @"schools"];
    NSDictionary *neighborhoods = [city objectForKey: @"neighborhoods"];
    NSMutableArray *array       = [NSMutableArray array];
    
    // Schools
    NSArray *schoolKeys = [[schools allKeys] sortedArrayUsingSelector:
                           @selector(localizedCaseInsensitiveCompare:)];
    for (NSString *key in schoolKeys) {
      if([key containsString:string options:0] || [string isEqualToString:@""]){
        found = YES;
        [array addObject: [schools objectForKey: key]];
      }
    }
    // Neighborhoods
    NSArray *neighborhoodKeys = [[neighborhoods allKeys] sortedArrayUsingSelector:
                                 @selector(localizedCaseInsensitiveCompare:)];
    for (NSString *key in neighborhoodKeys) {
      if([key containsString:string options:0] || [string isEqualToString:@""]){
        found = YES;
        [array addObject: [neighborhoods objectForKey: key]];
      }
    }
    if(found){
      [dictionary setObject: array forKey:keyCity];
    }
  }
  return dictionary;
}

@end
