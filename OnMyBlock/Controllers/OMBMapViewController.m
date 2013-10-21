//
//  OMBMapViewController.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 10/18/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "OMBMapViewController.h"

#import "OMBAnnotation.h"
#import "OMBAnnotationView.h"
#import "OMBPropertiesStore.h"
#import "OMBProperty.h"
#import "OMBPropertyInfoView.h"
#import "UIColor+Extensions.h"

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
    [OMBPropertiesStore sharedStore].mapViewController = self;
  }
  return self;
}

#pragma mark Override

#pragma mark Override UIViewController

- (void) loadView
{
  CGRect screen = [[UIScreen mainScreen] bounds];
  self.view = [[UIView alloc] initWithFrame: screen];
  // Tap gesture
  // UITapGestureRecognizer *tap = 
  //  [[UITapGestureRecognizer alloc] initWithTarget:
  //   self action: @selector(hidePropertyInfoView)];
  // Map view
  mapView          = [[OCMapView alloc] init];
  mapView.delegate = self;
  mapView.frame    = screen;
  mapView.mapType  = MKMapTypeStandard;
  mapView.rotateEnabled = NO;
  mapView.showsPointsOfInterest = NO;
  // [mapView addGestureRecognizer: tap];
  [self.view addSubview: mapView];
  // Region, Span
  // MKMapPoint, MKMapSize, MKMapRect, MKAnnotation

  // Property info view
  propertyInfoView = [[OMBPropertyInfoView alloc] init];
  [self.view addSubview: propertyInfoView];
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
  // Need to do this to uncluster when zooming in
  CLLocationCoordinate2D coordinate = map.centerCoordinate;
  OMBAnnotation *annotation = [[OMBAnnotation alloc] init];
  annotation.coordinate = coordinate;
  [mapView addAnnotation: annotation];
  [mapView removeAnnotation: annotation];
  // [self addAnnotationAtCoordinate: coordinate];
  // NSLog(@"Center: %f, %f", coordinate.latitude, coordinate.longitude);

  MKCoordinateRegion region = map.region;
  float maxLatitude, maxLongitude, minLatitude, minLongitude;
  // Northwest = maxLatitude, minLongitude
  maxLatitude  = region.center.latitude + (region.span.latitudeDelta / 2.0);
  minLongitude = region.center.longitude - (region.span.longitudeDelta / 2.0);
  // NSLog(@"Northwest: %f, %f", maxLatitude, minLongitude);
  // Southeat = minLatitude, maxLongitude
  minLatitude  = region.center.latitude - (region.span.latitudeDelta / 2.0);
  maxLongitude = region.center.longitude + (region.span.longitudeDelta / 2.0);
  // NSLog(@"Southeast: %f, %f", minLatitude, maxLongitude);

  NSString *bounds = [NSString stringWithFormat: @"[%f,%f,%f,%f]",
    minLongitude, maxLatitude, maxLongitude, minLatitude];
  NSDictionary *parameters = @{
    @"bounds": bounds
  };
  [[OMBPropertiesStore sharedStore] fetchPropertiesWithParameters: parameters];

  [self hidePropertyInfoView];
}

- (void) mapView: (MKMapView *) map 
didSelectAnnotationView: (MKAnnotationView *) annotationView
{
  // If user clicked on a cluster
  if ([annotationView.annotation isKindOfClass: [OCAnnotation class]]) {
    [self zoomClusterAtAnnotation: (OCAnnotation *) annotationView.annotation];
  }
  // If user clicked on a single property
  else {
    CLLocationCoordinate2D coordinate = annotationView.annotation.coordinate;
    NSString *key = [NSString stringWithFormat: @"%f,%f-%@",
      coordinate.latitude, coordinate.longitude, 
        annotationView.annotation.title];
    OMBProperty *property = 
      [[OMBPropertiesStore sharedStore].properties objectForKey: key];
    [propertyInfoView loadPropertyData: property];  
    [self showPropertyInfoView];
  }
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

#pragma mark Instance Methods

- (void) addAnnotationAtCoordinate: (CLLocationCoordinate2D) coordinate
withTitle: (NSString *) title;
{
  // Add annotation
  OMBAnnotation *annotation = [[OMBAnnotation alloc] init];
  annotation.coordinate     = coordinate;
  annotation.title          = title;
  [mapView addAnnotation: annotation];
}

- (void) foundLocations: (NSArray *) locations
{
  CLLocationCoordinate2D coordinate;
  for (CLLocation *location in locations) {
    coordinate = location.coordinate;
  }
  [self setMapViewRegion: coordinate withMiles: 2];
  [locationManager stopUpdatingLocation];
}

- (void) hidePropertyInfoView
{
  CGRect screen = [[UIScreen mainScreen] bounds];
  if (propertyInfoView.frame.origin.y != screen.size.height) {
    CGRect frame = propertyInfoView.frame;
    void (^animations) (void) = ^(void) {
      propertyInfoView.frame = CGRectMake(frame.origin.x, 
        screen.size.height, frame.size.width, frame.size.height);
    };
    [UIView animateWithDuration: 0.1 delay: 0 
      options: UIViewAnimationOptionCurveLinear
        animations: animations completion: nil];
  }
}

- (void) setMapViewRegion: (CLLocationCoordinate2D) coordinate 
withMiles: (int) miles
{
  // 1609 meters = 1 mile
  int distanceInMiles = 1609 * miles;
  MKCoordinateRegion region =
    MKCoordinateRegionMakeWithDistance(coordinate, distanceInMiles, 
      distanceInMiles);
  [mapView setRegion: region animated: YES];
}

- (void) showPropertyInfoView
{  
  CGRect screen = [[UIScreen mainScreen] bounds];
  CGRect frame = propertyInfoView.frame;
  void (^animations) (void) = ^(void) {
    propertyInfoView.frame = CGRectMake(frame.origin.x, 
      (screen.size.height - frame.size.height), frame.size.width, 
        frame.size.height);
  };
  [UIView animateWithDuration: 0.1 delay: 0 
    options: UIViewAnimationOptionCurveLinear
      animations: animations completion: nil];
}

- (void) zoomClusterAtAnnotation: (OCAnnotation *) cluster
{
  MKMapRect zoomRect = MKMapRectNull;
  for (id <MKAnnotation> annotation in [cluster annotationsInCluster]) {
    MKMapPoint annotationPoint = MKMapPointForCoordinate(annotation.coordinate);
    MKMapRect pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 
      0, 0);
    if (MKMapRectIsNull(zoomRect))
      zoomRect = pointRect;
    else
      zoomRect = MKMapRectUnion(zoomRect, pointRect);
  }
  [mapView setVisibleMapRect: zoomRect animated: YES];
}

@end
