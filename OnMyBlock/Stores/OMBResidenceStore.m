//
//  OMBResidenceStore.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 10/21/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBResidenceStore.h"

#import "OMBMapViewController.h"
#import "OMBPropertiesConnection.h"
#import "OMBResidence.h"

@implementation OMBResidenceStore

@synthesize mapViewController = _mapViewController;
@synthesize residences        = _residences;

#pragma mark - Initializer

- (id) init
{
  self = [super init];
  if (self) {
    _residences = [NSMutableDictionary dictionary];
  }
  return self;
}

#pragma mark - Methods

#pragma mark - Class Methods

+ (OMBResidenceStore *) sharedStore
{
  static OMBResidenceStore *store = nil;
  if (!store)
    store = [[OMBResidenceStore alloc] init];
  return store;
}

#pragma mark - Instance Methods

- (void) addResidence: (OMBResidence *) residence
{
  [_residences setObject: residence forKey: [residence dictionaryKey]];
}

- (void) fetchPropertiesWithParameters: (NSDictionary *) parameters
{
  OMBPropertiesConnection *connection = 
    [[OMBPropertiesConnection alloc] initWithParameters: parameters];
  [connection start];
}

- (void) readFromDictionary: (NSDictionary *) dictionary
{
  // Argument is an array of dictionaries
  for (NSDictionary *dict in dictionary) {
    if ([dict objectForKey: @"ad"] != [NSNull null]) {
      NSString *address = [dict objectForKey: @"ad"];
      float latitude, longitude;
      latitude  = [[dict objectForKey: @"lat"] floatValue];
      longitude = [[dict objectForKey: @"lng"] floatValue];
      // key = 32,-117-8550 fun street
      NSString *key = [NSString stringWithFormat: @"%f,%f-%@",
        latitude, longitude, address];
      OMBResidence *residence = [_residences objectForKey: key];
      // If the residence isn't in the store, add it to the map
      if (!residence) {
        residence = [[OMBResidence alloc] init];
        [residence readFromDictionary: dict];
        [self addResidence: residence];
        CLLocationCoordinate2D coordinate;
        coordinate.latitude  = residence.latitude;
        coordinate.longitude = residence.longitude;
        // We add the annotation to the map
        [_mapViewController addAnnotationAtCoordinate: coordinate 
          withTitle: residence.address];
      }
      else
        [residence readFromDictionary: dict];
    }
  }
}

@end
