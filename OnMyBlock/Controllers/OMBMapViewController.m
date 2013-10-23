//
//  OMBMapViewController.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 10/18/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "OMBMapViewController.h"

#import "NSString+Extensions.h"
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
  // Left bar button item
  self.navigationItem.leftBarButtonItem = 
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

  // Filter
  // View
  filterView = [[UIView alloc] init];
  filterView.backgroundColor = [UIColor grayDarkAlpha: 0.8];
  filterView.frame = CGRectMake(0, (20 + 44), screen.size.width, 30);
  filterView.hidden = YES;
  [self.view addSubview: filterView];
  // Label
  filterLabel = [[UILabel alloc] init];
  filterLabel.backgroundColor = [UIColor clearColor];
  filterLabel.font = [UIFont fontWithName: @"HelveticaNeue-Light" size: 15];
  filterLabel.frame = CGRectMake(10, 0, (filterView.frame.size.width - 20),
    filterView.frame.size.height);
  filterLabel.text = @"";
  filterLabel.textAlignment = NSTextAlignmentCenter;
  filterLabel.textColor = [UIColor whiteColor];
  [filterView addSubview: filterLabel];

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

  // Fetch properties with parameters
  NSString *bath = [NSString stringWithFormat: @"%@",
    mapFilterViewController.bath ? mapFilterViewController.bath : @""];
  NSString *beds = 
    [[mapFilterViewController.beds allValues] componentsJoinedByString: @","];
  NSString *bounds = [NSString stringWithFormat: @"[%f,%f,%f,%f]",
    minLongitude, maxLatitude, maxLongitude, minLatitude];
  NSString *maxRent = [NSString stringWithFormat: @"%@",
    mapFilterViewController.maxRent ? mapFilterViewController.maxRent : @""];
  NSString *minRent = [NSString stringWithFormat: @"%@",
    mapFilterViewController.minRent ? mapFilterViewController.minRent : @""];
  NSDictionary *parameters = @{
    @"ba":       bath,
    @"bd":       beds,
    @"bounds":   bounds,
    @"max_rent": maxRent,
    @"min_rent": minRent
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

- (void) updateFilterLabel
{
  filterLabel.text = @"";
  NSMutableArray *strings = [NSMutableArray array];

  // Rent
  NSString *maxRentString = @"";
  NSString *minRentString = @"";
  NSString *rentString    = @"";
  if (mapFilterViewController.maxRent)
    maxRentString = [NSString numberToCurrencyString: 
      [mapFilterViewController.maxRent intValue]];
  if (mapFilterViewController.minRent)
    minRentString = [NSString numberToCurrencyString: 
      [mapFilterViewController.minRent intValue]];
  // $1,234 - $5,678
  if ([maxRentString length] > 0 && [minRentString length] > 0)
    rentString = [NSString stringWithFormat: @"%@ - %@", 
      minRentString, maxRentString];
  // Below $5,678
  else if ([maxRentString length] > 0 && [minRentString length] == 0)
    rentString = [NSString stringWithFormat: @"Below %@", maxRentString];
  // Above $1,234
  else if ([maxRentString length] == 0 && [minRentString length] > 0)
    rentString = [NSString stringWithFormat: @"Above %@", minRentString];
  if ([rentString length] > 0)
    [strings addObject: rentString];

  // Beds
  NSString *bedString = @"";
  NSString *lastBed   = @"";
  for (NSString *bed in mapFilterViewController.bedsArray) {
    if ([[mapFilterViewController.beds objectForKey: bed] length] > 0) {
      if ([lastBed length] > 0)
        bedString = [bedString stringByAppendingString: @", "];
      bedString = [bedString stringByAppendingString: bed];
      lastBed = bed;
    }
  }
  if ([lastBed length] > 0) {
    if ([lastBed isEqualToString: @"Studio"])
      lastBed = @"";
    else if ([lastBed isEqualToString: @"1"])
      lastBed = @" bed";
    else
      lastBed = @" beds";
  }
  bedString = [bedString stringByAppendingString: lastBed];
  if ([bedString length] > 0)
    [strings addObject: bedString];

  // Bath
  if (mapFilterViewController.bath)
    [strings addObject: [NSString stringWithFormat: @"%@+ baths", 
      mapFilterViewController.bath]];

  // Put everything together
  if ([strings count] > 0)
    filterLabel.text = [strings componentsJoinedByString: @", "];
  // Figure out if the filter label needs to be hidden or not
  if ([filterLabel.text length] > 0)
    filterView.hidden = NO;
  else
    filterView.hidden = YES;
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
}

@end
