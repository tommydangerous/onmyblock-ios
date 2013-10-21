//
//  OMBPropertiesStore.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 10/18/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBPropertiesStore.h"

#import "OMBMapViewController.h"
#import "OMBProperty.h"

@implementation OMBPropertiesStore

@synthesize mapViewController = _mapViewController;
@synthesize properties        = _properties;

#pragma mark - Initializer

- (id) init
{
  self = [super init];
  if (self) {
    _properties = [NSMutableDictionary dictionary];
  }
  return self;
}

#pragma mark - Methods

#pragma mark Class Methods

+ (OMBPropertiesStore *) sharedStore
{
  static OMBPropertiesStore *store = nil;
  if (!store)
    store = [[OMBPropertiesStore alloc] init];
  return store;
}

#pragma mark Instance Methods

- (void) addProperty: (OMBProperty *) property
{
  [_properties setObject: property forKey: property.latitudeLongitudeKey];
}

- (void) readFromDictionary: (NSDictionary *) dictionary
{
  // Argument is an array of hashes
  for (NSDictionary *dict in dictionary) {
    float latitude, longitude;
    latitude  = [[dict objectForKey: @"lat"] floatValue];
    longitude = [[dict objectForKey: @"lng"] floatValue];
    NSString *key = [NSString stringWithFormat: @"%f,%f",
      latitude, longitude];
    OMBProperty *property = [_properties objectForKey: key];
    if (!property) {
      property = [[OMBProperty alloc] init];
      [property readFromDictionary: dict];
      [self addProperty: property];
      // If the property isn't in the store, add it to the map
      CLLocationCoordinate2D coordinate;
      coordinate.latitude  = property.latitude;
      coordinate.longitude = property.longitude;
      [_mapViewController addAnnotationAtCoordinate: coordinate];
    }
    else
      [property readFromDictionary: dict];
  }
}

@end
