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

@class AMBlurView;
@class OCMapView;
@class OMBActivityView;
@class OMBEmptyBackgroundWithImageAndLabel;
@class OMBMapFilterViewController;
@class OMBPropertyInfoView;

extern float const PropertyInfoViewImageHeightPercentage;

typedef NS_ENUM(NSInteger, OMBMapViewListSortKey) {
  OMBMapViewListSortKeyDistance,
  OMBMapViewListSortKeyRecent,
  OMBMapViewListSortKeyHighestPrice,
  OMBMapViewListSortKeyLowestPrice
};

@interface OMBMapViewController : OMBViewController
<CLLocationManagerDelegate, MKMapViewDelegate, UIAlertViewDelegate,
  UIGestureRecognizerDelegate, UIScrollViewDelegate, UITableViewDataSource,
  UITableViewDelegate>
{
  UIActivityIndicatorView *activityIndicatorView;
  OMBActivityView *activityView;
  CLLocationCoordinate2D centerCoordinate;
  CGFloat currentDistanceOfScrolling;
  NSArray *currentResidencesForList;
  UIButton *currentLocationButton;
  OMBMapViewListSortKey currentSortKey;
  OMBEmptyBackgroundWithImageAndLabel *emptyBackground;
  BOOL fetching;
  UILabel *filterLabel;
  UIView *filterView;
  BOOL isDraggingListView;
  BOOL isScrollingFast;
  BOOL isScrollingListViewDown;
  BOOL isShowingSortButtons;
  CGPoint lastOffset;
  NSTimeInterval lastOffsetCapture;
  CLLocationManager *locationManager;
  AMBlurView *navigationBarCover;
  int pagination;
  CGFloat previousOffsetY;
  NSUInteger previousZoomLevel;
  OMBPropertyInfoView *propertyInfoView;
  UISegmentedControl *segmentedControl;
  UIImageView *sortArrow;
  UIView *sortButtonsView;
  NSMutableArray *sortButtonArray;
  UIButton *sortButtonHighestPrice;
  UIButton *sortButtonLowestPrice;
  UIButton *sortButtonPopular;
  UIButton *sortButtonMostRecent;
  NSArray *sortKeys;
  UILabel *sortLabel;
  UILabel *sortSelectionLabel;
  AMBlurView *sortView;
  NSMutableArray *residentAnnotations;
}

@property (nonatomic, strong) UITableView *listView;
@property (nonatomic, strong) UIView *listViewContainer;
// @property (nonatomic, strong) OCMapView *mapView;
@property (nonatomic, strong) MKMapView *mapView;
@property (nonatomic) CGFloat radiusInMiles;
@property (nonatomic, strong) UITableView *residentListMap;

#pragma mark - Methods

#pragma mark Instance Methods

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
