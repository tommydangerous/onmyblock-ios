//
//  OMBMapViewController.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 10/18/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBMapViewController.h"

#import "OMBAnnotation.h"
#import "OMBAnnotationView.h"

@implementation OMBMapViewController

#pragma mark Initializer

- (id) init
{
  self = [super init];
  if (self) {
    // Location manager
    locationManager                 = [[CLLocationManager alloc] init];
    locationManager.delegate        = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.distanceFilter  = 50;
  }
  return self;
}

#pragma mark Override

#pragma mark Override UIViewController

- (void) loadView
{
  CGRect screen = [[UIScreen mainScreen] bounds];
  // Map view
  mapView          = [[OCMapView alloc] init];
  mapView.delegate = self;
  mapView.frame    = screen;
  mapView.mapType  = MKMapTypeStandard;
  self.view = mapView;
  // Region, Span
  // MKMapPoint, MKMapSize, MKMapRect, MKAnnotation
}

- (void) viewDidLoad
{
  mapView.showsUserLocation = YES;
  // Load default latitude and longitude
  CLLocationCoordinate2D coordinate;
  coordinate.latitude  = 32.78166389765503;
  coordinate.longitude = -117.16957478041991;

  [self setMapViewRegion: coordinate withMiles: 4];

  // Find user's location
  [locationManager startUpdatingLocation];
}

#pragma mark - Protocol

#pragma mark - Protocol CLLocationManagerDelegate

- (void) locationManager: (CLLocationManager *) manager
didFailWithError: (NSError *) error
{
  NSLog(@"Location manager did fail with error: %@", 
    error.localizedDescription);
}

- (void) locationManager: (CLLocationManager *) manager
didUpdateLocations: (NSArray *) locations
{
  [self foundLocations: locations];
}

#pragma mark - Protocol MKMapViewDelegate

- (void) mapView: (MKMapView *) map regionDidChangeAnimated: (BOOL) animated
{
  // Tells the delegate that the region displayed by the map view just changed
  CLLocationCoordinate2D coordinate = map.centerCoordinate;
  NSLog(@"Center: %f, %f", coordinate.latitude, coordinate.longitude);

  MKCoordinateRegion region = map.region;
  float maxLatitude, maxLongitude, minLatitude, minLongitude;
  // Northwest = maxLatitude, minLongitude
  maxLatitude  = region.center.latitude + (region.span.latitudeDelta / 2.0);
  minLongitude = region.center.longitude - (region.span.longitudeDelta / 2.0);
  NSLog(@"Northwest: %f, %f", maxLatitude, minLongitude);
  // Southeat = minLatitude, maxLongitude
  minLatitude  = region.center.latitude - (region.span.latitudeDelta / 2.0);
  maxLongitude = region.center.longitude + (region.span.longitudeDelta / 2.0);
  NSLog(@"Southeast: %f, %f", minLatitude, maxLongitude);

  [self addAnnotationAtCoordinate: coordinate];
}

- (void) mapView: (MKMapView *) map
  didUpdateUserLocation: (MKUserLocation *) userLocation
{

}

- (MKAnnotationView *) mapView: (MKMapView *) map 
viewForAnnotation: (id <MKAnnotation>) annotation
{
  // If the annotation is the user's location, show the default pulsing circle
  if (annotation == map.userLocation)
    return nil;

  static NSString *ReuseIdentifier = @"AnnotationViewIdentifier";
  OMBAnnotationView *annotationView = (OMBAnnotationView *)
    [map dequeueReusableAnnotationViewWithIdentifier: ReuseIdentifier];
  if (!annotationView) {
    annotationView = 
      [[OMBAnnotationView alloc] initWithAnnotation: annotation 
        reuseIdentifier: ReuseIdentifier];
    }
  [annotationView loadAnnotation: annotation];
  return annotationView;
}

#pragma mark - Methods

- (void) addAnnotationAtCoordinate: (CLLocationCoordinate2D) coordinate
{
  // Add annotation
  OMBAnnotation *annotation = [[OMBAnnotation alloc] init];
  annotation.coordinate = coordinate;
  [mapView addAnnotation: annotation];
}

- (void) foundLocations: (NSArray *) locations
{
  CLLocationCoordinate2D coordinate;
  for (CLLocation *location in locations) {
    coordinate = location.coordinate;
    NSLog(@"%f, %f", coordinate.latitude, coordinate.longitude);
  }
  [self setMapViewRegion: coordinate withMiles: 2];
  [locationManager stopUpdatingLocation];
}

- (void) setMapViewRegion: (CLLocationCoordinate2D) coordinate 
withMiles: (int) miles
{
  // 1609 meters = 1 mile
  int distanceInMiles = 1609 * miles;
  MKCoordinateRegion region =
    MKCoordinateRegionMakeWithDistance(coordinate, distanceInMiles, 
      distanceInMiles);
  [mapView setRegion: region animated: NO];
}

@end
