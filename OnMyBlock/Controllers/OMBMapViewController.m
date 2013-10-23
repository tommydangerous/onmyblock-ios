//
//  OMBMapViewController.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 10/18/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "OMBMapViewController.h"

#import "OCMapView.h"
#import "OMBAnnotation.h"
#import "OMBAnnotationView.h"
#import "OMBMapFilterViewController.h"
#import "OMBNavigationController.h"
#import "OMBPropertyInfoView.h"
#import "OMBResidenceStore.h"
#import "OMBResidence.h"
#import "OMBResidenceDetailViewController.h"
#import "UIColor+Extensions.h"
#import "UIImage+Resize.h"

@implementation OMBMapViewController

@synthesize mapView = _mapView;

#pragma mark Initializer

- (id) init
{
  self = [super init];
  if (self) {
    // self.title = @"Map";
    // Location manager
    locationManager                 = [[CLLocationManager alloc] init];
    locationManager.delegate        = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.distanceFilter  = 50;
    [OMBResidenceStore sharedStore].mapViewController = self;
  }
  return self;
}

#pragma mark - Override

#pragma mark - Override UIViewController

- (void) loadView
{
  CGRect screen = [[UIScreen mainScreen] bounds];
  self.view     = [[UIView alloc] initWithFrame: screen];

  // Navigation item
  // Right bar button item
  self.navigationItem.rightBarButtonItem = 
    [[UIBarButtonItem alloc] initWithImage: [UIImage image:
      [UIImage imageNamed: @"search.png"] size: CGSizeMake(26, 26)]
        style: UIBarButtonItemStylePlain target: self 
          action: @selector(showMapFilterViewController)];
  // Title view
  CGSize segmentedControlImageSize = CGSizeMake(29 * 0.6, 29 * 0.6);
  segmentedControl = [[UISegmentedControl alloc] initWithItems: 
    @[
      [UIImage image: [UIImage imageNamed: @"map_segmented_control.png"] 
        size: segmentedControlImageSize],
      [UIImage image: [UIImage imageNamed: @"list_segmented_control.png"] 
        size: segmentedControlImageSize]
    ]
  ];
  segmentedControl.selectedSegmentIndex = 0;
  CGRect segmentedFrame = segmentedControl.frame;
  segmentedFrame.size.width = screen.size.width * 0.4;
  segmentedControl.frame = segmentedFrame;
  self.navigationItem.titleView = segmentedControl;

  // Map filter navigation and view controller
  mapFilterViewController = 
    [[OMBMapFilterViewController alloc] init];
  mapFilterViewController.mapViewController = self;
  mapFilterNavigationController = 
    [[OMBNavigationController alloc] initWithRootViewController: 
      mapFilterViewController];

  // Map view
  _mapView          = [[OCMapView alloc] init];
  _mapView.delegate = self;
  _mapView.frame    = screen;
  _mapView.mapType  = MKMapTypeStandard;
  // mapView.rotateEnabled = NO;
  _mapView.showsPointsOfInterest = NO;
  [self.view addSubview: _mapView];
  UITapGestureRecognizer *mapViewTap = 
    [[UITapGestureRecognizer alloc] initWithTarget: self 
      action: @selector(mapViewTapped)];
  [_mapView addGestureRecognizer: mapViewTap];

  // Property info view
  propertyInfoView = [[OMBPropertyInfoView alloc] init];
  [self.view addSubview: propertyInfoView];
  // Add a tap gesture to property info view
  UITapGestureRecognizer *tap = 
    [[UITapGestureRecognizer alloc] initWithTarget:
      self action: @selector(showResidenceDetailViewController)];
  [propertyInfoView addGestureRecognizer: tap];
}

- (void) viewDidLoad
{
  _mapView.showsUserLocation = YES;
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
  [_mapView addAnnotation: annotation];
  [_mapView removeAnnotation: annotation];
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

  NSString *beds = 
    [[mapFilterViewController.beds allValues] componentsJoinedByString: @","];
  NSString *bounds = [NSString stringWithFormat: @"[%f,%f,%f,%f]",
    minLongitude, maxLatitude, maxLongitude, minLatitude];
  NSDictionary *parameters = @{
    @"bd":     beds,
    @"bounds": bounds
  };
  // parameters = [-116,32,-125,43]
  [[OMBResidenceStore sharedStore] fetchPropertiesWithParameters: parameters];

  [self deselectAnnotations];
  [self hidePropertyInfoView];
}

- (void) mapView: (MKMapView *) map 
didDeselectAnnotationView: (MKAnnotationView *) annotationView
{
  if (![[NSString stringWithFormat: @"%@",
    [annotationView class]] isEqualToString: @"MKModernUserLocationView"]) {

    [(OMBAnnotationView *) annotationView deselect];
  }
}

- (void) mapView: (MKMapView *) map 
didSelectAnnotationView: (MKAnnotationView *) annotationView
{
  // If user clicked on a cluster
  if ([annotationView.annotation isKindOfClass: [OCAnnotation class]]) {
    [self zoomClusterAtAnnotation: (OCAnnotation *) annotationView.annotation];
  }
  // If user clicked on a single residence
  else if ([[NSString stringWithFormat: @"%@",
    [annotationView class]] isEqualToString: @"MKModernUserLocationView"]) {
    [self hidePropertyInfoView];
  }
  else {
    [(OMBAnnotationView *) annotationView select];
    CLLocationCoordinate2D coordinate = annotationView.annotation.coordinate;
    NSString *key = [NSString stringWithFormat: @"%f,%f-%@",
      coordinate.latitude, coordinate.longitude, 
        annotationView.annotation.title];
    OMBResidence *residence = 
      [[OMBResidenceStore sharedStore].residences objectForKey: key];
    [propertyInfoView loadResidenceData: residence];
    [self showPropertyInfoView];
  }
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
  [_mapView addAnnotation: annotation];
}

- (void) deselectAnnotations
{
  for (OMBAnnotation *annotation in _mapView.selectedAnnotations) {
    if ([annotation class] != [MKUserLocation class])
      [annotation.annotationView deselect];
    [_mapView deselectAnnotation: annotation animated: NO];
  }
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
    [UIView animateWithDuration: 0.15 delay: 0 
      options: UIViewAnimationOptionCurveLinear
        animations: animations completion: ^(BOOL finished) {
          propertyInfoView.imageView.image = nil;
        }];
  }
}

- (void) mapViewTapped
{
  [self deselectAnnotations];
  [self hidePropertyInfoView];
}

- (void) refreshProperties
{
  [self mapView: _mapView regionDidChangeAnimated: YES];
}

- (void) removeAllAnnotations
{
  for (id annotation in _mapView.annotations) {
    if (![annotation isKindOfClass: [MKUserLocation class]])
      [_mapView removeAnnotation: annotation];
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
  [_mapView setRegion: region animated: YES];
}

- (void) showMapFilterViewController
{
  [self presentViewController: mapFilterNavigationController
    animated: YES completion: nil];
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
  [UIView animateWithDuration: 0.15 delay: 0 
    options: UIViewAnimationOptionCurveLinear
      animations: animations completion: nil];
}

- (void) showResidenceDetailViewController
{
  [self.navigationController pushViewController: 
    [[OMBResidenceDetailViewController alloc] initWithResidence: 
      propertyInfoView.residence] animated: YES];
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
  [_mapView setVisibleMapRect: zoomRect animated: YES];
  NSLog(@"%f, %f", zoomRect.size.width, zoomRect.size.height);
}

@end
