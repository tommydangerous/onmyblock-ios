//
//  OMBMapViewController.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 10/18/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

#import "OMBNavigationController.h"
#import "OMBViewController.h"

@class OCMapView;
@class OMBMapFilterViewController;
@class OMBPropertyInfoView;

@interface OMBMapViewController : OMBViewController
<CLLocationManagerDelegate, MKMapViewDelegate, 
  UICollectionViewDataSource, UICollectionViewDelegate,
    UITableViewDataSource, UITableViewDelegate>
{
  UILabel *filterLabel;
  UIView *filterView;
  CLLocationManager *locationManager;
  OMBNavigationController *mapFilterNavigationController;
  OMBMapFilterViewController *mapFilterViewController;
  OMBPropertyInfoView *propertyInfoView;
  UISegmentedControl *segmentedControl;
}

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewLayout *collectionViewLayout;
@property (nonatomic, strong) UITableView *listView;
@property (nonatomic, strong) OCMapView *mapView;

#pragma mark - Methods

#pragma mark Instance Methods

- (void) addAnnotationAtCoordinate: (CLLocationCoordinate2D) coordinate
withTitle: (NSString *) title;
- (void) addAnnotations: (NSArray *) annotations;
- (void) refreshProperties;
- (void) reloadTable;
- (void) removeAllAnnotations;
- (void) setMapViewRegion: (CLLocationCoordinate2D) coordinate 
withMiles: (int) miles;
- (void) updateFilterLabel;

@end
