//
//  OMBResidenceStore.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 10/21/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBResidenceStore.h"

#import "OCMapView.h"
#import "OMBAnnotation.h"
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
completion: (void (^)(NSError *error)) completion
{
  OMBPropertiesConnection *connection = 
    [[OMBPropertiesConnection alloc] initWithParameters: parameters];
  connection.completionBlock = completion;
  [connection start];
}

- (NSArray *) propertiesFromAnnotations: (NSSet *) annotations 
sortedBy: (NSString *) string ascending: (BOOL) ascending
{
  NSMutableArray *array = [NSMutableArray array];
  for (id <MKAnnotation> annotation in annotations) {
    OMBResidence *residence;
    // If it is a cluster, loop through the annotations in the cluster
    if ([annotation isKindOfClass: [OCAnnotation class]]) {
      for (OMBAnnotation *annot in 
        [(OCAnnotation *) annotation annotationsInCluster]) {
        residence = [self residenceForAnnotation: annot];
        if (residence)
          [array addObject: residence];
      }
    }
    else {
      residence = [self residenceForAnnotation: (OMBAnnotation *) annotation];
      if (residence)
        [array addObject: residence];
    }
  } 
  return (NSArray *) array;
}

- (void) readFromDictionary: (NSDictionary *) dictionary
{
  NSMutableArray *annotations = [NSMutableArray array];

  NSArray *array = [dictionary objectForKey: @"objects"];
  for (NSDictionary *dict in array) {
    // Create residence
    OMBResidence *residence = [[OMBResidence alloc] init];
    [residence readFromResidenceDictionary: dict];
    [self addResidence: residence];
    // Create annotation
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(
      residence.latitude, residence.longitude);
    OMBAnnotation *annotation = [[OMBAnnotation alloc] init];
    annotation.coordinate = coordinate;
    annotation.title      = residence.address;
    // Add to array
    [annotations addObject: annotation];
  }
  [_mapViewController addAnnotations: annotations];

}

- (void) readFromPropertiesDictionary: (NSDictionary *) dictionary
{
  NSMutableArray *annotations = [NSMutableArray array];
  for (NSDictionary *dict in dictionary) {
    // Create residence
    OMBResidence *residence = [[OMBResidence alloc] init];
    [residence readFromPropertyDictionary: dict];
    [self addResidence: residence];
    // Create annotation
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(
      residence.latitude, residence.longitude);
    OMBAnnotation *annotation = [[OMBAnnotation alloc] init];
    annotation.coordinate = coordinate;
    annotation.title      = residence.address;
    // Add to array
    [annotations addObject: annotation];
  }
  [_mapViewController addAnnotations: annotations];
}

- (void) readFromPropertiesDictionary1: (NSDictionary *) dictionary
{
  NSMutableArray *annotations = [NSMutableArray array];
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
        [residence readFromPropertyDictionary: dict];
        [self addResidence: residence];
      }
      else {
        [residence readFromPropertyDictionary: dict];
      }
      BOOL exists = NO;
      CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(
        residence.latitude, residence.longitude);
      for (OMBAnnotation *annotation in 
        _mapViewController.mapView.annotations) {
        NSString *k = [NSString stringWithFormat: @"%f,%f-%@",
          coordinate.latitude, coordinate.longitude, annotation.title];
        if ([k isEqualToString: [residence dictionaryKey]]) {
          exists = YES;
          break;
        }      
      }
      if (!exists) {
        // We add the annotation to the map
        OMBAnnotation *annotation = [[OMBAnnotation alloc] init];
        annotation.coordinate = coordinate;
        annotation.title      = residence.address;
        [annotations addObject: annotation];
        // [_mapViewController addAnnotationAtCoordinate: coordinate 
        //   withTitle: residence.address];
      }
    }
  }
  [_mapViewController addAnnotations: annotations];
}

- (OMBResidence *) residenceForAnnotation: (OMBAnnotation *) annotation
{
  return [_residences objectForKey: [NSString stringWithFormat: 
    @"%f,%f-%@", annotation.coordinate.latitude, 
      annotation.coordinate.longitude, annotation.title]];
}

@end
