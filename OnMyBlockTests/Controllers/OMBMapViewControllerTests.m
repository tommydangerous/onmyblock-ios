//
//  OMBMapViewControllerTests.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 10/21/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "OCMapView.h"
#import "OMBMapViewController.h"
#import "OMBPropertyInfoView.h"

#pragma mark - Categories

#pragma mark OMBMapViewController

@interface OMBMapViewController (testing)

#pragma mark - Getters

- (CLLocationManager *) locationManager;
- (OCMapView *) mapView;
- (OMBPropertyInfoView *) propertyInfoView;

@end

@implementation OMBMapViewController (testing)

#pragma mark - Getters

- (CLLocationManager *) locationManager
{
  return locationManager;
}

- (OCMapView *) mapView
{
  return mapView;
}

- (OMBPropertyInfoView *) propertyInfoView
{
  return propertyInfoView;
}

@end

#pragma mark - Unit Tests

@interface OMBMapViewControllerTests : XCTestCase
{
  CLLocationCoordinate2D coordinate;
  OMBMapViewController *mapViewController;
}

@end

@implementation OMBMapViewControllerTests

#pragma mark - Setup and Teardown

- (void)setUp
{
  [super setUp];
  coordinate.latitude  = 32;
  coordinate.longitude = -117;
  mapViewController    = [[OMBMapViewController alloc] init];

  [mapViewController loadView];
}

- (void)tearDown
{
  [super tearDown];
  mapViewController = nil;
}

#pragma mark - Tests

#pragma mark Attributes

- (void) testMapViewControllerHasALocationManager
{
  XCTAssertNotNil([mapViewController locationManager],
    @"Map view controller should not have a nil location manager");
}

- (void) testMapViewControllerHasMapViewInLoadView
{
  XCTAssertNotNil([mapViewController mapView],
    @"Map view controller should not have a nil map view");
}

- (void) testMapViewControllerHasPropertyInfoViewInLoadView
{
  XCTAssertNotNil([mapViewController propertyInfoView],
    @"Map view controller should not have a nil property info view");
}

#pragma mark Methods

- (void) testAddAnnotationAtCoordinate
{
  [mapViewController addAnnotationAtCoordinate: coordinate withTitle: @"test"];
  XCTAssertEqualWithAccuracy([[[mapViewController mapView] annotations] count],
    1, 0, @"Map view should have 1 annotation after adding an annotation");
}

@end
