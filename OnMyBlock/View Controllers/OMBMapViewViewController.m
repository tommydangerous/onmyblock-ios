//
//  OMBMapViewViewController.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 1/27/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBMapViewViewController.h"

#import "OMBAnnotation.h"
#import "OMBAnnotationView.h"

@implementation OMBMapViewViewController

#pragma mark - Initializer

- (id) initWithCoordinate: (CLLocationCoordinate2D) coord 
title: (NSString *) string
{
  if (!(self = [super init])) return nil;

  coordinate = coord;

  self.screenName = @"Map View View Controller";
  self.title      = string;

  return self;
}

#pragma mark - Override

#pragma mark - Override UIViewController

- (void) loadView
{
  [super loadView];

  CGRect screen = [[UIScreen mainScreen] bounds];
  self.view     = [[UIView alloc] initWithFrame: screen];

  map          = [[MKMapView alloc] init];
  map.delegate = self;
  map.frame    = screen;
  map.mapType  = MKMapTypeStandard;
  map.showsPointsOfInterest = YES;
  [self.view addSubview: map];
}

- (void) viewWillAppear: (BOOL) animated
{
  [super viewWillAppear: animated];

  // Add annotation
  OMBAnnotation *annotation = [[OMBAnnotation alloc] init];
  annotation.coordinate     = coordinate;
  [map addAnnotation: annotation];

  // 1609 meters = 1 mile
  int miles = 4;
  int distanceInMiles = 1609 * miles;
  MKCoordinateRegion region =
    MKCoordinateRegionMakeWithDistance(coordinate, distanceInMiles, 
      distanceInMiles);
  [map setRegion: region animated: NO];
}

#pragma mark - Protocol

#pragma mark - Protocol MKMapViewDelegate

- (MKAnnotationView *) mapView: (MKMapView *) mapView
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

@end
