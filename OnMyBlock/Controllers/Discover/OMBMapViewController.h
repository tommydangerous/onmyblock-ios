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
@class OMBMapFilterViewController;
@class OMBPropertyInfoView;

extern float const PropertyInfoViewImageHeightPercentage;

@interface OMBMapViewController : OMBViewController
<CLLocationManagerDelegate, MKMapViewDelegate, 
  UICollectionViewDataSource, UICollectionViewDelegate, 
  UIGestureRecognizerDelegate, UIScrollViewDelegate, UITableViewDataSource, 
  UITableViewDelegate>
{
  CGFloat currentDistanceOfScrolling;
  UIButton *currentLocationButton;
  UILabel *filterLabel;
  UIView *filterView;
  BOOL isDraggingListView;
  BOOL isScrollingListViewDown;
  BOOL isShowingSortButtons;
  CLLocationManager *locationManager;
  OMBNavigationController *mapFilterNavigationController;
  OMBMapFilterViewController *mapFilterViewController;
  AMBlurView *navigationBarCover;
  CGFloat previousOffsetY;
  OMBPropertyInfoView *propertyInfoView;
  UISegmentedControl *segmentedControl;
  UIImageView *sortArrow;
  UIView *sortButtonsView;
  NSArray *sortButtonArray;
  UIButton *sortButtonHighestPrice;
  UIButton *sortButtonLowestPrice;
  UIButton *sortButtonPopular;
  UIButton *sortButtonMostRecent;
  UILabel *sortLabel;
  UILabel *sortSelectionLabel;
  AMBlurView *sortView;
}

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewLayout *collectionViewLayout;
@property (nonatomic, strong) UITableView *listView;
@property (nonatomic, strong) UIView *listViewContainer;
@property (nonatomic, strong) OCMapView *mapView;

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
- (void) showMapFilterViewControllerAnimated: (BOOL) animated;
- (void) switchToListView;
- (void) updateFilterLabel;

@end
