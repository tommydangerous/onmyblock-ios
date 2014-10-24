//
//  OMBMapViewController.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 10/18/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

#import "OMBViewController.h"

extern float const PropertyInfoViewImageHeightPercentage;

typedef NS_ENUM(NSInteger, OMBMapViewListSortKey) {
  OMBMapViewListSortKeyDistance,
  OMBMapViewListSortKeyRecent,
  OMBMapViewListSortKeyHighestPrice,
  OMBMapViewListSortKeyLowestPrice
};

@interface OMBMapViewController : OMBViewController

@property (nonatomic, strong) UITableView *listView;
@property (nonatomic, strong) UIView *listViewContainer;
@property (nonatomic, strong) MKMapView *mapView;
@property (nonatomic) CGFloat radiusInMiles;
@property (nonatomic, strong) UITableView *residentListMap;

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) addAnnotationAtCoordinate: (CLLocationCoordinate2D) coordinate
withTitle: (NSString *) title;
- (void) addAnnotations: (NSArray *) annotations;
- (void) goToCurrentLocationAnimated: (BOOL) animated;
- (void) refreshProperties;
- (void) reloadTable;
- (void) removeAllAnnotations;
- (void) setMapViewRegion: (CLLocationCoordinate2D) coordinate
withMiles: (int) miles animated: (BOOL) animated;
- (void) switchToListView;
- (void) updateFilterLabel;

@end
