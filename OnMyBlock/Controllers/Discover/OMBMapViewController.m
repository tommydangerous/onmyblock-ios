//
//  OMBMapViewController.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 10/18/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "OMBMapViewController.h"

#import "AMBlurView.h"
#import "NSString+Extensions.h"
#import "NSUserDefaults+OnMyBlock.h"
#import "OCMapView.h"
#import "OMBActivityViewFullScreen.h"
#import "OMBActivityView.h"
#import "OMBAllResidenceStore.h"
#import "OMBAnnotation.h"
#import "OMBAnnotationCity.h"
#import "OMBAnnotationView.h"
#import "OMBEmptyBackgroundWithImageAndLabel.h"
#import "OMBMapFilterViewController.h"
#import "OMBMapResidenceDetailCell.h"
#import "OMBNavigationController.h"
#import "OMBNeighborhood.h"
#import "OMBNeighborhoodStore.h"
#import "OMBPropertyInfoView.h"
#import "OMBResidenceBookItConfirmDetailsViewController.h"
#import "OMBResidence.h"
#import "OMBResidenceCell.h"
#import "OMBResidenceCollectionViewCell.h"
#import "OMBResidenceDetailViewController.h"
#import "OMBResidenceListStore.h"
#import "OMBResidenceMapStore.h"
#import "OMBResidencePartialView.h"
#import "OMBSpringFlowLayout.h"
#import "OMBUser.h"
#import "OMBViewControllerContainer.h"
#import "QVClusterAnnotation.h"
#import "QVClusterAnnotationView.h"
#import "QVCoordinateQuadTree.h"
#import "SVPullToRefresh.h"
#import "UIColor+Extensions.h"
#import "UIImage+Color.h"
#import "UIImage+NegativeImage.h"
#import "UIImage+Resize.h"

#define CLCOORDINATE_EPSILON 0.005f
#define CLCOORDINATES_EQUAL2(coord1, coord2) (fabs(coord1.latitude - coord2.latitude) < CLCOORDINATE_EPSILON && fabs(coord1.longitude - coord2.longitude) < CLCOORDINATE_EPSILON)

float const PropertyInfoViewImageHeightPercentage = 0.4;

int kMaxRadiusInMiles = 100;

const CGFloat DEFAULT_MILE_RADIUS = 4.0f;
const NSUInteger MINIMUM_ZOOM_LEVEL = 12;

static NSString *CollectionCellIdentifier = @"CollectionCellIdentifier";

@interface OMBMapViewController ()
{
  OMBActivityViewFullScreen *activityViewFullScreen;
  BOOL firstLoad;
  BOOL isFetchingResidencesForMap;
  NSMutableArray *neighborhoodAnnotationArray;
  NSDictionary *previousMapFilterParameters;
  CGFloat radiusIncrementInMiles;
  OMBAnnotationCity *sanDiegoAnnotationCity;
}

@property (strong, nonatomic) QVCoordinateQuadTree *coordinateQuadTree;

@end

@implementation OMBMapViewController

#pragma mark Initializer

- (id) init
{
  if (!(self = [super init])) return nil;

  fetching           = NO;
  firstLoad          = YES;
  radiusIncrementInMiles = 2.0;
  self.radiusInMiles     = 0;

  // Location manager
  locationManager                 = [[CLLocationManager alloc] init];
  locationManager.delegate        = self;
  locationManager.desiredAccuracy = kCLLocationAccuracyBest;
  locationManager.distanceFilter  = 50;

  neighborhoodAnnotationArray = [NSMutableArray array];
  // Create neighborhood annotations
  if ([neighborhoodAnnotationArray count] == 0) {

  }
  for (NSString *cityName in [[OMBNeighborhoodStore sharedStore] cities]) {
    for (OMBNeighborhood *neighborhood in
      [[OMBNeighborhoodStore sharedStore] sortedNeighborhoodsForCity:
        cityName]) {

      OMBAnnotationCity *annotationCity = [[OMBAnnotationCity alloc] init];
      annotationCity.cityName   = neighborhood.name;
      annotationCity.coordinate = neighborhood.coordinate;

      [neighborhoodAnnotationArray addObject: annotationCity];
      // [self.mapView.annotationsToIgnore addObject: annotationCity];
      // [self.mapView removeAnnotation: annotationCity];
      // [self.mapView addAnnotation: annotationCity];
    }
  }

  previousZoomLevel = 0;

  self.screenName = @"Map View Controller";

  [[NSNotificationCenter defaultCenter] addObserver: self
    selector: @selector(refreshProperties)
      name: OMBUserLoggedInNotification object: nil];

  return self;
}

#pragma mark - Override

#pragma mark - Override UIViewController

- (void) loadView
{
  [super loadView];

  CGRect screen = [[UIScreen mainScreen] bounds];
  self.view     = [[UIView alloc] initWithFrame: screen];
  CGFloat screenHeight = screen.size.height;
  CGFloat screenWidth = screen.size.width;
  CGFloat padding = OMBPadding;

  // Navigation item
  // Left bar button item
  [self setMenuBarButtonItem];
  // Right bar button item
  self.navigationItem.rightBarButtonItem =
    [[UIBarButtonItem alloc] initWithImage: [UIImage image:
      [UIImage imageNamed: @"search_icon.png"] size: CGSizeMake(26, 26)]
        style: UIBarButtonItemStylePlain target: self
          action: @selector(showSearch)];

  // Title view
  segmentedControl = [[UISegmentedControl alloc] initWithItems:
    @[@"Map", @"List"]];
  segmentedControl.selectedSegmentIndex = 1;
  CGRect segmentedFrame = segmentedControl.frame;
  segmentedFrame.size.width = screen.size.width * 0.4;
  segmentedControl.frame = segmentedFrame;
  [segmentedControl addTarget: self action: @selector(switchViews:)
    forControlEvents: UIControlEventValueChanged];
  self.navigationItem.titleView = segmentedControl;

  // List view container
  _listViewContainer = [[UIView alloc] init];
  _listViewContainer.alpha = 1.0f;
  _listViewContainer.frame = screen;
  [self.view addSubview: _listViewContainer];

  navigationBarCover = [[AMBlurView alloc] init];
  navigationBarCover.alpha = 0.0f;
  navigationBarCover.blurTintColor = [UIColor whiteColor];
  navigationBarCover.frame = CGRectMake(0.0f, -20.0f,
    screen.size.width, 20.0f + 44.0f);
  [self.view addSubview: navigationBarCover];

  // Sort
  sortView = [[AMBlurView alloc] init];
  sortView.blurTintColor = [UIColor grayVeryLight];
  sortView.frame = CGRectMake(0.0f, 44.0f,
    _listViewContainer.frame.size.width, 20.0f + 37.0f);
  [_listViewContainer addSubview: sortView];
  UITapGestureRecognizer *sortViewTap =
    [[UITapGestureRecognizer alloc] initWithTarget: self
      action: @selector(showSortButtons)];
  [sortView.toolbar addGestureRecognizer: sortViewTap];
  // Sort label
  sortLabel = [[UILabel alloc] init];
  sortLabel.font = [UIFont fontWithName: @"HelveticaNeue" size: 14];
  sortLabel.frame = CGRectMake(padding, sortView.frame.size.height - 37.0f,
    0.0f, 37.0f);
  sortLabel.text = @"Sort by";
  sortLabel.textColor = [UIColor blue];
  CGRect sortRect = [sortLabel.text boundingRectWithSize:
    CGSizeMake(screenWidth, sortLabel.frame.size.height)
      options: NSStringDrawingUsesLineFragmentOrigin
        attributes: @{ NSFontAttributeName: sortLabel.font }
          context: nil];
  sortLabel.frame = CGRectMake(sortLabel.frame.origin.x,
    sortLabel.frame.origin.y, sortRect.size.width, sortLabel.frame.size.height);
  //[sortView addSubview: sortLabel];
  // Sort selection label
  sortSelectionLabel = [[UILabel alloc] init];
  sortSelectionLabel.font = sortLabel.font;
  sortSelectionLabel.frame = CGRectMake(0.0f, sortLabel.frame.origin.y,
    screenWidth, sortLabel.frame.size.height);
  sortSelectionLabel.text = @"Sort your Rental Results";
  sortSelectionLabel.textAlignment = NSTextAlignmentCenter;
  sortSelectionLabel.textColor = sortLabel.textColor;
  [sortView addSubview: sortSelectionLabel];
  // Sort arrow
  CGFloat sortArrowSize = sortLabel.frame.size.height - padding;
  sortArrow = [[UIImageView alloc] init];
  sortArrow.frame = CGRectMake(screenWidth - (sortArrowSize + padding),
    sortLabel.frame.origin.y +
    ((sortLabel.frame.size.height - sortArrowSize) * 0.5),
      sortArrowSize, sortArrowSize);
  sortArrow.image = [UIImage changeColorForImage:
    [UIImage  imageNamed: @"arrow_left_white.png"] toColor:[UIColor blue]];
  sortArrow.transform = CGAffineTransformMakeRotation(-90 * M_PI / 180.0f);
  [sortView addSubview: sortArrow];

  // Sort button array
  // sortKeys = @[
  //   @"distance",
  //   @"recent",
  //   @"highest price",
  //   @"lowest price"
  // ];
  // sortButtonArray = [NSMutableArray array];
  sortButtonHighestPrice = [[UIButton alloc] init];
  sortButtonLowestPrice  = [[UIButton alloc] init];
  sortButtonPopular      = [[UIButton alloc] init];
  sortButtonMostRecent   = [[UIButton alloc] init];
  sortButtonArray = [NSMutableArray arrayWithArray: @[
    sortButtonPopular,
    sortButtonMostRecent,
    sortButtonHighestPrice,
    sortButtonLowestPrice
  ]];
  CGFloat sortButtonViewHeight = sortView.frame.size.height +
    ((1 + 37) * [sortButtonArray count]);
  sortButtonsView = [[UIView alloc] init];
  sortButtonsView.frame = CGRectMake(0.0f, sortView.frame.origin.y,
    sortView.frame.size.width, sortButtonViewHeight);
  sortButtonsView.hidden = YES;
  // for (int i = 0; i < [sortKeys count]; i++) {
  //   UIButton *button = [UIButton new];
  //   button.backgroundColor = [UIColor colorWithWhite: 255/255.0 alpha: 0.95];
  //   button.frame = CGRectMake(0.0f, 20.0f,
  //     sortButtonsView.frame.size.width, 44.0f);
  //   button.hidden = YES;
  //   button.tag = i;
  //   button.titleLabel.font = sortLabel.font;
  //   [button addTarget: self action: @selector(sortButtonSelected:)
  //     forControlEvents: UIControlEventTouchUpInside];
  //   [button setBackgroundImage: [UIImage imageWithColor: [UIColor blue]]
  //     forState: UIControlStateHighlighted];
  //   [button setTitle: [[sortKeys objectAtIndex: i] capitalizedString]
  //     forState: UIControlStateNormal];
    // [button setTitleColor: [UIColor textColor]
    //   forState: UIControlStateNormal];
  //   [button setTitleColor: [UIColor whiteColor]
  //     forState: UIControlStateHighlighted];
  //   [sortButtonArray addObject: button];
  //   [sortButtonsView addSubview: button];
  // }
  for (UIButton *button in sortButtonArray) {
    button.backgroundColor = [UIColor colorWithWhite: 255/255.0 alpha: 0.95];
    button.frame = CGRectMake(0.0f, 20.0f,
      sortButtonsView.frame.size.width, 37.0f);
    button.hidden = YES;
    NSString *string = @"";
    if (button == sortButtonPopular) {
      // string = @"Student Popularity";
      string = @"Distance";
    }
    else if (button == sortButtonMostRecent) {
      string = @"Recent";
    }
    else if (button == sortButtonHighestPrice) {
      string = @"Highest Price";
    }
    else if (button == sortButtonLowestPrice) {
      string = @"Lowest Price";
    }
    button.tag = [sortButtonArray indexOfObject: button];
    button.titleLabel.font = sortLabel.font;
    [button addTarget: self action: @selector(sortButtonSelected:)
      forControlEvents: UIControlEventTouchUpInside];
    [button setBackgroundImage: [UIImage imageWithColor: [UIColor blue]]
      forState: UIControlStateHighlighted];
    [button setTitle: string forState: UIControlStateNormal];
    [button setTitleColor: [UIColor textColor]
      forState: UIControlStateNormal];
    [button setTitleColor: [UIColor whiteColor]
      forState: UIControlStateHighlighted];
    [sortButtonsView addSubview: button];
  }
  [_listViewContainer insertSubview: sortButtonsView belowSubview: sortView];

  // List view
  _listView = [[UITableView alloc] init];
  _listView.backgroundColor              = [UIColor grayUltraLight];
  _listView.canCancelContentTouches      = YES;
  _listView.dataSource                   = self;
  _listView.delegate                     = self;
  _listView.frame                        = screen;
  _listView.separatorColor               = nil;
  _listView.separatorStyle               = UITableViewCellSeparatorStyleNone;
  // _listView.showsVerticalScrollIndicator = NO;
  _listView.tableHeaderView = [[UIView alloc] initWithFrame:
    CGRectMake(0.0f, 0.0f, _listView.frame.size.width,
      sortLabel.frame.size.height)];
  [_listViewContainer insertSubview: _listView atIndex: 0];

  // Map view
  // self.mapView          = [[OCMapView alloc] init];
  self.mapView = [[MKMapView alloc] init];
  self.mapView.alpha    = 0.0f;
  self.mapView.frame    = screen;
  self.mapView.mapType  = MKMapTypeStandard;
  self.mapView.showsPointsOfInterest = NO;
  self.mapView.showsUserLocation     = NO;
  [self.view addSubview: self.mapView];
  UITapGestureRecognizer *mapViewTap =
    [[UITapGestureRecognizer alloc] initWithTarget: self
      action: @selector(mapViewTapped)];
  mapViewTap.delegate = self;
  [self.mapView addGestureRecognizer: mapViewTap];

  self.coordinateQuadTree = [[QVCoordinateQuadTree alloc] init];
  self.coordinateQuadTree.mapView = self.mapView;
  [self.coordinateQuadTree buildTreeWithResidences:
    [[OMBResidenceMapStore sharedStore] residences]];

  // Filter
  // View
  filterView = [[UIView alloc] init];
  filterView.backgroundColor = [UIColor colorWithWhite: 1.0f alpha: 0.8f];
  filterView.frame = CGRectMake(0.0f, 64.0f, screenWidth, 20.0f);
  filterView.hidden = YES;
  [self.view addSubview: filterView];
  // Label
  filterLabel = [[UILabel alloc] init];
  filterLabel.backgroundColor = [UIColor clearColor];
  filterLabel.font = [UIFont fontWithName: @"HelveticaNeue-Light" size: 13];
  filterLabel.frame = CGRectMake(10.0f, 0.0f,
    filterView.frame.size.width - (10 * 2), filterView.frame.size.height);
  filterLabel.text = @"";
  filterLabel.textAlignment = NSTextAlignmentCenter;
  filterLabel.textColor = [UIColor textColor];
  [filterView addSubview: filterLabel];

  // Current location button
  currentLocationButton = [[UIButton alloc] init];
  currentLocationButton.backgroundColor = [UIColor whiteColor];
  currentLocationButton.frame = CGRectMake(padding * 0.5f,
    screenHeight - ((padding * 1.5) + (padding * 2)),
      padding * 2, padding * 2);
  currentLocationButton.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
  // currentLocationButton.layer.borderColor = [UIColor grayMedium].CGColor;
  // currentLocationButton.layer.borderWidth = 1.0;
  currentLocationButton.layer.cornerRadius = 2.0;
  currentLocationButton.layer.shadowOffset = CGSizeMake(0, 0);
  currentLocationButton.layer.shadowRadius = 1;
  currentLocationButton.layer.shadowOpacity = 0.5;
  [currentLocationButton setImage: [UIImage imageNamed: @"gps_cursor.png"]
    forState: UIControlStateNormal];
  [currentLocationButton setImage: [UIImage imageNamed: @"gps_cursor_blue.png"]
    forState: UIControlStateHighlighted];
  [currentLocationButton addTarget: self action: @selector(goToCurrentLocation)
    forControlEvents: UIControlEventTouchUpInside];
  [self.mapView addSubview: currentLocationButton];

  // Property info view
  propertyInfoView = [[OMBPropertyInfoView alloc] init];
  [_mapView addSubview: propertyInfoView];
  // Add a tap gesture to property info view
  UITapGestureRecognizer *tap =
    [[UITapGestureRecognizer alloc] initWithTarget:
      self action: @selector(showResidenceDetailViewController)];
  [propertyInfoView addGestureRecognizer: tap];

  // Resident list on MapView(when cluster<=10)
  residentAnnotations = [NSMutableArray array];
  CGFloat originYreslist = _mapView.frame.size.height;
  CGRect reslistRect =
    CGRectMake(_mapView.frame.origin.x,
      originYreslist, _mapView.frame.size.width,
        originYreslist * 0.5f);
  _residentListMap = [UITableView new];
  _residentListMap.backgroundColor = [UIColor backgroundColor];
  _residentListMap.dataSource = self;
  _residentListMap.delegate   = self;
  _residentListMap.frame      = reslistRect;
  _residentListMap.separatorColor    = [UIColor grayLight];;
  _residentListMap.separatorStyle    = UITableViewCellSeparatorStyleSingleLine;
  _residentListMap.showsVerticalScrollIndicator = NO;
  [_mapView addSubview: _residentListMap];
  [_residentListMap removeGestureRecognizer: mapViewTap];
  // Activity indicator view
  activityIndicatorView =
    [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:
      UIActivityIndicatorViewStyleWhiteLarge];
  activityIndicatorView.frame = CGRectMake(
    (screenWidth - activityIndicatorView.frame.size.width) * 0.5f,
      screenHeight - (activityIndicatorView.frame.size.height * 2),
        activityIndicatorView.frame.size.width,
          activityIndicatorView.frame.size.height);
  [_listViewContainer addSubview: activityIndicatorView];

  activityView = [[OMBActivityView alloc] init];
  [_listViewContainer addSubview: activityView];
  activityView.spinnerView.backgroundColor = [UIColor clearColor];
  CGRect spinRect = activityView.spinner.frame;
  spinRect.origin.y = screenHeight -
    ((spinRect.size.height * 0.5f) +
      activityView.spinnerView.frame.size.height);
  activityView.spinner.frame = spinRect;

  activityViewFullScreen = [[OMBActivityViewFullScreen alloc] init];
  [_listViewContainer addSubview: activityViewFullScreen];

  // Empty background
  CGFloat emptyBackgroundHeight = screenHeight - sortView.frame.size.height;
  CGRect emptyBackgroundRect = CGRectMake(0.0f,
    screenHeight - emptyBackgroundHeight,
      screenWidth, emptyBackgroundHeight);
  emptyBackground = [[OMBEmptyBackgroundWithImageAndLabel alloc] initWithFrame:
    emptyBackgroundRect];
  emptyBackground.alpha = 0.0f;
  emptyBackground.imageView.image = [UIImage imageNamed: @"search.png"];
  NSString *text = @"Sorry but we found no results near you. Please choose "
    @"another location or change filters.";
  [emptyBackground setLabelText: text];
  [_listViewContainer addSubview: emptyBackground];
}

- (void) viewDidAppear: (BOOL) animated
{
  [super viewDidAppear: animated];
}

- (void) viewDidDisappear: (BOOL) animated
{
  [super viewDidDisappear: animated];
  [self showSortViewAnimated: NO];
}

- (void) viewDidLoad
{
  [super viewDidLoad];

  self.mapView.delegate = self;

  __weak OMBMapViewController *weakSelf = self;

  pagination = 0;
  // setup infinite scrolling
  [_listView addInfiniteScrollingWithActionHandler:^{
    [weakSelf reloadWithPagination];
  }];
}

- (void) viewWillDisappear: (BOOL) animated
{
  [super viewWillDisappear: animated];
  [self showNavigationBarAnimated: NO];
}

- (void) viewWillAppear: (BOOL) animated
{
  [super viewWillAppear: animated];

  if (centerCoordinate.latitude == 0.0f && centerCoordinate.longitude == 0.0f) {
    centerCoordinate = CLLocationCoordinate2DMake(32.78166389765503,
      -117.16957478041991);
    [self setMapViewRegion: centerCoordinate withMiles: DEFAULT_MILE_RADIUS
      animated: YES];
    // Find user's location
  }

  // This is so that the spinner doesn't freeze and just stay there
  if (fetching)
    fetching = NO;
  // Only stop the spinner if it is spinning and there is at least 1 residence
  if (activityView.isSpinning && [[self residencesForList] count])
    [activityView stopSpinning];

  // This reloads the list view if it is visible
  [self reloadTable];

  NSDictionary *dictionary = (NSDictionary *)
    [self appDelegate].container.mapFilterViewController.valuesDictionary;

  BOOL shouldSearch = 
    [self appDelegate].container.mapFilterViewController.shouldSearch;

  // Filter
  // If there is a neighborhood in the filter, then try to re-fetch
  if ([dictionary objectForKey: @"neighborhood"] != [NSNull null] &&
    [[dictionary objectForKey: @"neighborhood"] isKindOfClass:
      [OMBNeighborhood class]]) {
    // Neighborhood
    OMBNeighborhood *neighborhood = [dictionary objectForKey:
      @"neighborhood"];
    // If the current center coordinate is not equal to the neighborhood's
    // and it should search
    if (!CLCOORDINATES_EQUAL2(centerCoordinate, neighborhood.coordinate) &&
        shouldSearch) {
      centerCoordinate = neighborhood.coordinate;
      // If it is on the list, then re-fetch residences for the list
      if ([self isOnList]) {
        [self resetAndFetchResidencesForList];
      }
      else {
        // Move the map so it re-fetches residences for the map
        [self setMapViewRegion: centerCoordinate withMiles: DEFAULT_MILE_RADIUS
          animated: NO];
        [self resetListViewResidences];
      }
    }
    // Remove this object so that whenever the user comes back from the
    // residence detail view, it doesn't refresh everything
    // [[self appDelegate].container.mapFilterViewController.valuesDictionary
    //   removeObjectForKey: @"neighborhood"];
  }
  // If there are filter values, apply and search
  else if (shouldSearch) {
    if ([self isOnList]) {
      [self resetAndFetchResidencesForList];

      firstLoad = YES;
      self.listView.showsPullToRefresh = NO;
    }
    else {  
      [self setMapViewRegion: centerCoordinate withMiles: DEFAULT_MILE_RADIUS
        animated: NO];
      [self resetListViewResidences];
    }
  }

  // If the view controller should search, then set it back to no
  // so it doesn't always keep changing the center location
  if ([self appDelegate].container.mapFilterViewController.shouldSearch)
    [self appDelegate].container.mapFilterViewController.shouldSearch = NO;

  // Check any filter values and display them
  [self updateFilterLabel];

  if (firstLoad)
    [activityViewFullScreen startSpinning];
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

- (void) mapView: (MKMapView *) mapView didAddAnnotationViews: (NSArray *) views
{
  for (UIView *view in views) {
    [self addBounceAnimationToView: view];
  }
}

- (void) mapView: (MKMapView *) map regionDidChangeAnimated: (BOOL) animated
{
  // Tells the delegate that the region displayed by the map view just changed
  // Need to do this to uncluster when zooming in
  // CLLocationCoordinate2D coordinate = map.centerCoordinate;
  // OMBAnnotation *annotation = [[OMBAnnotation alloc] init];
  // annotation.coordinate = coordinate;
  // [_mapView addAnnotation: annotation];
  // [_mapView removeAnnotation: annotation];

  NSUInteger currentZoomLevel =
    [self zoomLevelForMapRect: self.mapView.visibleMapRect
      withMapViewSizeInPixels: self.mapView.bounds.size];

  MKCoordinateRegion region = map.region;
  float maxLatitude, maxLongitude, minLatitude, minLongitude;
  // Northwest = maxLatitude, minLongitude
  maxLatitude  = region.center.latitude + (region.span.latitudeDelta / 2.0);
  minLongitude = region.center.longitude - (region.span.longitudeDelta / 2.0);
  minLatitude  = region.center.latitude - (region.span.latitudeDelta / 2.0);
  maxLongitude = region.center.longitude + (region.span.longitudeDelta / 2.0);
  NSString *bounds = [NSString stringWithFormat: @"[%f,%f,%f,%f]",
    minLongitude, maxLatitude, maxLongitude, minLatitude];

  NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:
    @{
      @"bounds": bounds
    }
  ];
  if ([self mapFilterParameters] != nil) {
    if ([previousMapFilterParameters isEqual: [self mapFilterParameters]]) {

    }
    else {
      [self.mapView removeAnnotations: self.mapView.annotations];
      previousMapFilterParameters = [NSDictionary dictionaryWithDictionary:
        [self mapFilterParameters]];
    }
    [params addEntriesFromDictionary: [self mapFilterParameters]];
  }

  if (!isFetchingResidencesForMap) {
    isFetchingResidencesForMap = YES;
    [[OMBResidenceMapStore sharedStore] fetchResidencesWithParameters: params
      delegate: self completion: ^(NSError *error) {
        isFetchingResidencesForMap = NO;
        [[NSOperationQueue new] addOperationWithBlock: ^{
          double zoomScale = self.mapView.bounds.size.width /
            self.mapView.visibleMapRect.size.width;
          NSArray *annotations =
            [self.coordinateQuadTree clusteredAnnotationsWithinMapRect:
              map.visibleMapRect withZoomScale: zoomScale];

          [self updateMapViewAnnotationsWithAnnotations: annotations];
        }];
      }];
  }

  [self deselectAnnotations];
  [self hidePropertyInfoView];
  [self hideResidentListAnnotation];

  if (![self isOnList]) {
    // If the center coordinate changed
    if (!CLCOORDINATES_EQUAL2(map.centerCoordinate, centerCoordinate)) {
      [self resetListViewResidences];
    }
  }

  previousZoomLevel = currentZoomLevel;
}

- (void) DONOTHINGmapView: (MKMapView *) map
regionWillChangeAnimated: (BOOL) animated
{
  // This messes up the map because it drag/scrolls every other time

  // Max zoom level
  // 1609 meters = 1 mile
  int distanceInMiles = 1609 * 5;
  MKCoordinateRegion maxRegion =
    MKCoordinateRegionMakeWithDistance(map.region.center, distanceInMiles,
      distanceInMiles);

  if (map.region.span.latitudeDelta > maxRegion.span.latitudeDelta ||
    map.region.span.longitudeDelta > maxRegion.span.longitudeDelta)
    [_mapView setRegion: maxRegion animated: YES];
}

- (void) mapView: (MKMapView *) map
didDeselectAnnotationView: (MKAnnotationView *) annotationView
{
  if (![[NSString stringWithFormat: @"%@",
    [annotationView class]] isEqualToString: @"MKModernUserLocationView"]) {

    if ([annotationView isKindOfClass: [QVClusterAnnotationView class]]) {
      QVClusterAnnotationView *aView = (QVClusterAnnotationView *)
        annotationView;
      [aView deselect];
    }
  }
}

- (void) mapView: (MKMapView *) map
didSelectAnnotationView: (MKAnnotationView *) annotationView
{
  // If user clicked on the current location
  if ([annotationView isKindOfClass: [QVClusterAnnotationView class]]) {
    QVClusterAnnotationView *aView = (QVClusterAnnotationView *)
      annotationView;
    // If user clicked on a cluster
    if (aView.count > 1) {
      if (aView.count > 5) {
        [self zoomAtAnnotation: annotationView.annotation];
      }
      else {
        [residentAnnotations removeAllObjects];
        QVClusterAnnotation *annotation = (QVClusterAnnotation *)
          aView.annotation;
        for (NSDictionary *dict in annotation.coordinates) {
          CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(
            [dict[@"latitude"] doubleValue], [dict[@"longitude"] doubleValue]);
          OMBResidence *residence =
            [[OMBResidenceMapStore sharedStore] residenceForCoordinate: coord];
          if (residence)
            [residentAnnotations addObject: residence];
        }
        [self.residentListMap reloadData];
        [self showResidentListAnnotation];
      }
    }
    // If user clicked on a single residence
    else {
      if ([aView.annotation isKindOfClass: [QVClusterAnnotation class]]) {
        [aView select];
        QVClusterAnnotation *annotation = (QVClusterAnnotation *)
          aView.annotation;
        [self showPropertyInfoViewWithResidence:
          [[OMBResidenceMapStore sharedStore] residenceForCoordinate:
            annotation.coordinate]];
      }
    }
  }
}

- (MKAnnotationView *) mapView: (MKMapView *) mapView
viewForAnnotation: (id <MKAnnotation>) annotation
{
  if (annotation == _mapView.userLocation)
    return nil;

  static NSString *const QVAnnotationViewReuseID = @"QVAnnotationViewReuseID";

  QVClusterAnnotationView *annotationView = (QVClusterAnnotationView *)
    [mapView dequeueReusableAnnotationViewWithIdentifier:
      QVAnnotationViewReuseID];

  if (!annotationView) {
    annotationView = [[QVClusterAnnotationView alloc] initWithAnnotation:
      annotation reuseIdentifier: QVAnnotationViewReuseID];
  }

  annotationView.count = [(QVClusterAnnotation *) annotation count];

  return annotationView;
}

#pragma mark - Protocol OMBConnection

- (void) JSONDictionary: (NSDictionary *) dictionary
{
  // List view
  if ([self isOnList]) {
    [[OMBResidenceListStore sharedStore] readFromDictionary: dictionary];
  }
  // Map
  else {
    if (previousZoomLevel >= MINIMUM_ZOOM_LEVEL) {
      [[OMBResidenceMapStore sharedStore] readFromDictionary: dictionary];
      [self.coordinateQuadTree buildTreeWithResidences:
        [[OMBResidenceMapStore sharedStore] residences]];

      // Add annotations that don't exist
      // NSMutableSet *masterSet = [NSMutableSet setWithSet:
      //   [[OMBResidenceMapStore sharedStore] annotations]];
      // [masterSet minusSet: [NSSet setWithArray: self.mapView.annotations]];

      // NSLog(@"ADDING: %i", [[masterSet allObjects] count]);
      // [self.mapView addAnnotations: [masterSet allObjects]];

      // dispatch_async(dispatch_get_main_queue(), ^{
      //   [self.mapView addAnnotations:
      //     [[OMBResidenceMapStore sharedStore] annotations]];
      // });

      // NSMutableArray *arrayOfDictonaries = [NSMutableArray array];
      // NSArray *array = [dictionary objectForKey: @"objects"];
      // NSUInteger arrayCount = [array count];
      // int size = 500;
      // for (int i = 0; i < (arrayCount / size) + 1; i++) {
      //   NSUInteger location = i * size;
      //   NSUInteger length   = arrayCount - location;
      //   if (length > size)
      //     length = size;
      //   NSArray *subarray = [array subarrayWithRange:
      //     NSMakeRange(location, length)];
      //   [arrayOfDictonaries addObject: @{
      //     @"objects": subarray
      //   }];
      // }
      // for (NSDictionary *dict in arrayOfDictonaries) {
      //   // Read from dictionary
      //   dispatch_async(dispatch_get_main_queue(), ^{
      //     [[OMBResidenceMapStore sharedStore] readFromDictionary: dict];
      //     // Add annotations that don't exist
      //     NSMutableSet *masterSet = [NSMutableSet setWithSet:
      //       [[OMBResidenceMapStore sharedStore] annotations]];
      //     [masterSet minusSet:
      //       [NSSet setWithArray: self.mapView.annotations]];

      //     NSLog(@"ADDING: %i", [[masterSet allObjects] count]);
      //     [self.mapView addAnnotations: [masterSet allObjects]];
      //     [self addAnnotations: [masterSet allObjects]];
      //     [self addAnnotations:
      //       [[[OMBResidenceMapStore sharedStore] annotations] allObjects]];
      //   });
      // }
    }
  }
}

#pragma mark - UIAlertViewDelegate Protocol

- (void) alertView: (UIAlertView *) alertView
clickedButtonAtIndex: (NSInteger) buttonIndex
{
  if (buttonIndex == 0) {
    [[self userDefaults] permissionCurrentLocationSet: NO];
  }
  else if (buttonIndex == 1) {
    [[self userDefaults] permissionCurrentLocationSet: YES];
    [self goToCurrentLocation];
  }
}

#pragma mark - Protocol UIGestureRecognizerDelegate

- (BOOL) gestureRecognizer: (UIGestureRecognizer *) gestureRecognizer
shouldReceiveTouch: (UITouch *) touch
{
  if (gestureRecognizer.view == _mapView) {
    CGPoint touchPoint = [touch locationInView: _mapView];
    return !CGRectContainsPoint(_residentListMap.frame, touchPoint);
  }
  return YES;
}

#pragma mark - Protocol UIScrollViewDelegate

- (void) scrollViewDidEndDecelerating: (UIScrollView *) scrollView
{
  if (scrollView == _listView) {
    [self downloadResidenceImagesForVisibleCells];
  }
}

- (void) scrollViewDidEndDragging: (UIScrollView *) scrollView
willDecelerate: (BOOL) decelerate
{
  if (scrollView == _listView) {
    isDraggingListView = NO;
    [self hideOrShowNavigationBarAndSortView];
  }
}

- (void) scrollViewWillEndDragging: (UIScrollView *) scrollView
withVelocity: (CGPoint) velocity
targetContentOffset: (inout CGPoint *) targetContentOffset
{
  if (scrollView == _listView) {
    if (velocity.y < 0.0001) {
      [self downloadResidenceImagesForVisibleCells];
    }
  }
}

- (void) scrollViewWillBeginDragging: (UIScrollView *) scrollView
{
  if (scrollView == _listView) {
    isDraggingListView = YES;
    previousOffsetY = scrollView.contentOffset.y;
    currentDistanceOfScrolling = 0.0f;
    if (isShowingSortButtons) {
      [UIView animateWithDuration: 0.1 animations: ^{
        sortArrow.transform =
          CGAffineTransformMakeRotation(-90 * M_PI / 180.0f);
        for (UIButton *button in sortButtonArray) {
          button.alpha = 0.0f;
        }
      } completion: ^(BOOL finished) {
        for (UIButton *button in sortButtonArray) {
          button.alpha  = 1.0f;
          [self makeSortButtonsVisible: NO];
        }
      }];
      isShowingSortButtons = NO;
    }
  }
}

- (void) scrollViewDidScroll: (UIScrollView *) scrollView
{
  CGFloat y = scrollView.contentOffset.y;
  if (isDraggingListView && scrollView == _listView) {
    if (scrollView.contentSize.height < scrollView.frame.size.height)
      return;
    CGFloat difference = y - previousOffsetY;
    currentDistanceOfScrolling += difference;
    previousOffsetY = y;
    UINavigationBar *bar = self.navigationController.navigationBar;
    // Scrolling down
    // User needs to scroll pass the top 66 pixels first
    if (difference > 0 && y > -1 * (20.f + 44.0f)) {
      isScrollingListViewDown = YES;
      CGFloat sortViewOriginY = sortView.frame.origin.y - difference;
      if (sortViewOriginY <= 0.0f) {
        // Start scrolling the navigation bar
        CGFloat barOriginY = bar.frame.origin.y - difference;
        CGFloat percentage = (20.0f - barOriginY) / bar.frame.size.height;
        bar.alpha = 1 - percentage;
        navigationBarCover.alpha = percentage;
        if (sortViewOriginY <= -44.0f) {
          sortViewOriginY = -44.0f;
        }
        if (barOriginY <= -24.0f) {
          barOriginY = -24.0f;
        }
        // Move the navigation bar up
        bar.frame = CGRectMake(bar.frame.origin.x, barOriginY,
          bar.frame.size.width, bar.frame.size.height);
        // Move the navigation bar cover
        navigationBarCover.frame = CGRectMake(navigationBarCover.frame.origin.x,
          bar.frame.origin.y - 20.0f, navigationBarCover.frame.size.width,
            navigationBarCover.frame.size.height);
      }
      // Move the sort view up
      sortView.frame = CGRectMake(sortView.frame.origin.x,
        sortViewOriginY, sortView.frame.size.width,
          sortView.frame.size.height);
    }
    // Scrolling up
    // User needs to scroll at least 44 pixels up before showing
    else if (difference < 0 && currentDistanceOfScrolling <= -44.0f) {
      isScrollingListViewDown = NO;
      CGFloat sortViewOriginY = sortView.frame.origin.y - difference;
      if (sortViewOriginY >= 44.0f) {
        sortViewOriginY = 44.0f;
      }
      sortView.frame = CGRectMake(sortView.frame.origin.x,
        sortViewOriginY, sortView.frame.size.width,
          sortView.frame.size.height);
      CGFloat barOriginY = bar.frame.origin.y - difference;
      if (barOriginY >= 20.0f) {
        barOriginY = 20.0f;
      }
      CGFloat percentage =
        (barOriginY + 24.0f) / bar.frame.size.height;
      bar.alpha = percentage;
      navigationBarCover.alpha = 1 - percentage;
      bar.frame = CGRectMake(bar.frame.origin.x, barOriginY,
        bar.frame.size.width, bar.frame.size.height);
      // Move the navigation bar cover
      navigationBarCover.frame = CGRectMake(navigationBarCover.frame.origin.x,
        bar.frame.origin.y - 20.0f, navigationBarCover.frame.size.width,
          navigationBarCover.frame.size.height);
    }
  }

  if (scrollView == _listView) {
    // Fetch more residences when scrolling down
    CGFloat scrollViewHeight = scrollView.frame.size.height;
    CGFloat contentHeight    = scrollView.contentSize.height;
    CGFloat totalContentOffset = contentHeight - scrollViewHeight;
    CGFloat limit = totalContentOffset - (scrollViewHeight / 1.0f);
    if (y > limit) {
      if ([self isOnList]) {
        [self fetchResidencesForList];
      }
    }

    // Check the speed of scrolling,  if it is slow, download
    // the rest of the images for the visible cells
    CGPoint currentOffset = scrollView.contentOffset;
    NSTimeInterval currentTime = [NSDate timeIntervalSinceReferenceDate];
    NSTimeInterval timeDiff = currentTime - lastOffsetCapture;
    if (timeDiff > 0.1) {
      CGFloat distance = currentOffset.y - lastOffset.y;
      // The multiply by 10, / 1000 isn't really necessary.......
      // In pixels per millisecond
      CGFloat scrollSpeedNotAbs = (distance * 10) / 1000;
      CGFloat scrollSpeed = fabsf(scrollSpeedNotAbs);

      if (scrollSpeed > 0.3) {
        isScrollingFast = YES;
      }
      else {
        isScrollingFast = NO;
      }
      // if (!isScrollingFast)
      //   [self downloadResidenceImagesForVisibleCells];

      lastOffset = currentOffset;
      lastOffsetCapture = currentTime;
    }
  }
}

#pragma mark - Protocol UITableViewDataSource

- (UITableViewCell *) tableView: (UITableView *) tableView
cellForRowAtIndexPath: (NSIndexPath *) indexPath
{
  static NSString *EmptyCellID = @"EmptyCellID";
  UITableViewCell *emptyCell = [tableView dequeueReusableCellWithIdentifier:
    EmptyCellID];
  if (!emptyCell)
    emptyCell = [[UITableViewCell alloc] initWithStyle:
      UITableViewCellStyleDefault reuseIdentifier: EmptyCellID];

  // Resident list
  if(tableView == _listView){
    static NSString *CellIdentifier = @"CellIdentifier";
    OMBResidenceCell *cell = [tableView dequeueReusableCellWithIdentifier:
      CellIdentifier];
    if (!cell) {
      cell = [[OMBResidenceCell alloc] initWithStyle:
        UITableViewCellStyleDefault reuseIdentifier: CellIdentifier];
    }
    OMBResidence *residence = [[self residencesForList] objectAtIndex:
      indexPath.row];
    [cell loadResidenceData: residence];
    __weak OMBMapViewController *weakSelf = self;
    cell.residencePartialView.selected =
    ^(OMBResidence *residence, NSInteger __unused imageIndex) {
      [weakSelf.navigationController pushViewController:
       [[OMBResidenceDetailViewController alloc] initWithResidence:
        residence] animated: YES];
    };
    return cell;
  }
  // Resident annotation
  else if(tableView == _residentListMap) {
    static NSString *AnnotationResidentID = @"AnnotationResidentID";
    OMBMapResidenceDetailCell *cell = [tableView
      dequeueReusableCellWithIdentifier:AnnotationResidentID];
    if (!cell) {
      cell = [[OMBMapResidenceDetailCell alloc] initWithStyle:
        UITableViewCellStyleDefault reuseIdentifier: AnnotationResidentID];
      cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    [cell loadResidenceData:[residentAnnotations objectAtIndex:
      indexPath.row]];
    return cell;
  }

  return emptyCell;
}

- (NSInteger) tableView: (UITableView *) tableView
numberOfRowsInSection: (NSInteger) section
{
  // Resident list
  if(tableView == _listView){
    if([currentResidencesForList count] < (pagination + 1) * 10)
      return [currentResidencesForList count];
    else
      return (pagination + 1) * 10;
  }
  // Resident annotation
  else if(tableView == _residentListMap){
    return residentAnnotations.count;
  }

  return 0;
  // return [currentResidencesForList count];
  // return [[OMBResidenceListStore sharedStore].residences count];
  // return [[self propertiesSortedBy: @"" ascending: NO] count];
}

#pragma mark - Protocol UITableViewDelegate

- (void) tableView: (UITableView *) tableView
didEndDisplayingCell: (UITableViewCell *) cell
forRowAtIndexPath: (NSIndexPath *) indexPath
{
  if (tableView == _listView) {
    if ([[self residencesForList] count] > indexPath.row) {
      // Cancel the download of the cover photo
      if ([cell isKindOfClass: [OMBResidenceCell class]])
        [(OMBResidenceCell *) cell cancelResidenceCoverPhotoDownload];
    }
  }
}

- (void) tableView: (UITableView *) tableView
didSelectRowAtIndexPath: (NSIndexPath *) indexPath
{
  if (tableView == _residentListMap &&
     [residentAnnotations count] > indexPath.row) {
    OMBResidence *residence = [residentAnnotations objectAtIndex:
      indexPath.row];
    [self.navigationController pushViewController:
      [[OMBResidenceDetailViewController alloc] initWithResidence:
        residence] animated: YES];
  }

  [tableView deselectRowAtIndexPath: indexPath animated: YES];
}

- (CGFloat) tableView: (UITableView *) tableView
heightForRowAtIndexPath: (NSIndexPath *) indexPath
{
  CGRect screen = [[UIScreen mainScreen] bounds];
  // Resident list
  if(tableView == _listView){
    return screen.size.height * PropertyInfoViewImageHeightPercentage;
  }
  // Resident annotation
  else if(tableView == _residentListMap){
    return _residentListMap.frame.size.height / 3.0f;
  }
  return 0;
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

- (void) addAnnotations: (NSArray *) annotations
{
  if (previousZoomLevel >= 10) {
    dispatch_async(dispatch_get_main_queue(), ^{
      // NSLog(@"ADDING: %i", [annotations count]);
      [self.mapView addAnnotations: annotations];
    });
  }
  else {

  }
  // int count = (int) [annotations count];
  // [_mapView removeAnnotations: _mapView.annotations];
  // if (count < 700)
  //   [_mapView addAnnotations: annotations];
  // else {
  //   // Create annotation
  //   CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(
  //     32.7150, -117.1625);
  //   OMBAnnotationCity *annotation = [[OMBAnnotationCity alloc] init];
  //   annotation.cityName   = @"San Diego";
  //   annotation.coordinate = coordinate;
  //   annotation.title      = [NSString stringWithFormat: @"%i", count];
  //   [_mapView addAnnotation: annotation];
  // }
}

- (void) addBounceAnimationToView: (UIView *) view
{
  CAKeyframeAnimation *bounceAnimation =
    [CAKeyframeAnimation animationWithKeyPath: @"transform.scale"];

  bounceAnimation.values = @[@(0.05), @(1.1), @(0.9), @(1)];

  bounceAnimation.duration = 0.6;
  NSMutableArray *timingFunctions = [[NSMutableArray alloc] init];
  for (NSInteger i = 0; i < 4; i++) {
    [timingFunctions addObject: [CAMediaTimingFunction functionWithName:
      kCAMediaTimingFunctionEaseInEaseOut]];
  }
  [bounceAnimation setTimingFunctions: timingFunctions.copy];
  bounceAnimation.removedOnCompletion = NO;

  [view.layer addAnimation: bounceAnimation forKey: @"bounce"];
}

- (void) deselectAnnotations
{
  for (id annotation in self.mapView.selectedAnnotations) {
    [self.mapView deselectAnnotation: annotation animated: YES];
    // if ([annotation class] != [MKUserLocation class] &&
    //   [annotation isKindOfClass: [QVClusterAnnotation class]]) {

    //   [self.mapView deselectAnnotation: annotation animated: YES];

    //   QVClusterAnnotation *ann = (QVClusterAnnotation *) annotation;
    //   QVClusterAnnotationView *aView = ann.annotationView;
    //   aView.isSelected = NO;
    //   [aView setNeedsDisplay];
    // }
  }
}

- (void) OLDdeselectAnnotations
{
  for (OMBAnnotation *annotation in _mapView.selectedAnnotations) {
    if ([annotation class] != [MKUserLocation class] &&
      [annotation class] != [OCAnnotation class])

      [annotation.annotationView deselect];
    [_mapView deselectAnnotation: annotation animated: NO];
  }
}

- (void) downloadResidenceImagesForVisibleCells
{
  for (id obj in [_listView visibleCells]) {
    if ([obj isKindOfClass: [OMBResidenceCell class]]) {
      OMBResidenceCell *cell = (OMBResidenceCell *) obj;
      [cell downloadResidenceImages];
    }
  }
}

- (void) fetchResidencesForList
{
  // Fetch residences for list

  // One degree of latitude is always approximately 111 kilometers (69 miles)
  // One degree of longitude is approximately 111 kilometers (69 miles)

  if (fetching || _radiusInMiles > kMaxRadiusInMiles) {
    return;
  }
  else {
    // if (!activityView.isSpinning) {
    //   [activityView startSpinning];
    // }
  }
  fetching = YES;

  _radiusInMiles += radiusIncrementInMiles;

  // CGFloat maxLatitude, maxLongitude, minLatitude, minLongitude;

  // CGFloat degrees = _radiusInMiles / 69.0f;

  // Northwest = maxLatitude, minLongitude
  // maxLatitude  = centerCoordinate.latitude + (degrees * 0.5f);
  // minLongitude = centerCoordinate.longitude - (degrees * 0.5f);

  // // Southeast = minLatitude, maxLongitude
  // minLatitude  = centerCoordinate.latitude - (degrees * 0.5f);
  // maxLongitude = centerCoordinate.longitude + (degrees * 0.5f);

  // Bounds
  // NSString *bounds = [NSString stringWithFormat: @"[%f,%f,%f,%f]",
  //   minLongitude, maxLatitude, maxLongitude, minLatitude];

  NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:
    [self mapFilterParameters]];
  // [params setObject: bounds forKey: @"bounds"];

  // Latitude
  [params setObject: @(centerCoordinate.latitude) forKey: @"latitude"];
  // Longitude
  [params setObject: @(centerCoordinate.longitude) forKey: @"longitude"];
  // Radius
  [params setObject: @(radiusIncrementInMiles) forKey: @"radius"];
  // Current radius
  [params setObject: @(self.radiusInMiles) forKey: @"current_radius"];

  NSInteger currentCount =
    [[OMBResidenceListStore sharedStore].residences count];
  // NSLog(@"CURRENT COUNT: %i", currentCount);

  [[OMBResidenceListStore sharedStore] fetchResidencesWithParameters: params
    delegate: self completion: ^(NSError *error) {
      if (firstLoad) {
        [activityViewFullScreen stopSpinning];
        firstLoad = NO;
      }

      _listView.showsPullToRefresh = YES;

      fetching = NO;
      [self resetCurrentResidencesForList];
      [self reloadTable];

      if (currentCount == 0)
        [self downloadResidenceImagesForVisibleCells];

      // Stop fetching residences after 100 mile radius
      if (_radiusInMiles < kMaxRadiusInMiles) {
        NSInteger newCount =
          [[OMBResidenceListStore sharedStore].residences count];
        // NSLog(@"NEW COUNT:     %i", newCount);

        // If the count never changed
        if (newCount == currentCount ||
          _listView.contentSize.height <= _listView.frame.size.height) {
          // Fetch again
          [self fetchResidencesForList];
        }
        // If new residences were found and added
        else {
          // if (activityView.isSpinning)
          //   [activityView stopSpinning];
          if ([[self residencesForList] count])
            emptyBackground.alpha = 0.0f;
        }
      }
      // Stop fetching if radius is more than 100 miles
      else {
        // if (activityView.isSpinning)
        //   [activityView stopSpinning];
        if ([[self residencesForList] count] == 0)
          [UIView animateWithDuration: OMBStandardDuration animations: ^{
            emptyBackground.alpha = 1.0f;
          }];
      }

      [self reloadTable];
    }
  ];
}

- (void) foundLocations: (NSArray *) locations
{
  if ([locations count]) {
    for (CLLocation *location in locations) {
      centerCoordinate = location.coordinate;
    }
    if (fetching) {
      fetching = NO;
      [[OMBResidenceListStore sharedStore] cancelConnection];
    }
    [self fetchResidencesForList];
    [self setMapViewRegion: centerCoordinate withMiles: 2 animated: YES];
  }
  [locationManager stopUpdatingLocation];
}

- (void) goToCurrentLocation
{
  [self goToCurrentLocationAnimated: YES];
}

- (void) goToCurrentLocationAnimated: (BOOL) animated
{
  if ([[self userDefaults] permissionCurrentLocation]) {
    if (!self.mapView.showsUserLocation)
      self.mapView.showsUserLocation = YES;
    [locationManager startUpdatingLocation];
    //self.mapView.showsUserLocation = YES;
    /*if(_mapView.userLocation)
      [_mapView setCenterCoordinate: [_mapView userLocation].coordinate
        animated: animated];*/
  }
  else {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:
      @"Use Current Location" message: @"Allowing OnMyBlock to use your "
      @"current location will help us find better listings near you."
        delegate: self cancelButtonTitle: @"Not now"
          otherButtonTitles: @"Yes", nil];
    [alertView show];
  }
  // [_mapView setCenterCoordinate: [_mapView userLocation].coordinate
  //   animated: animated];
}

- (void) hideNavigationBarAndSortView
{
  UINavigationBar *bar = self.navigationController.navigationBar;
  [UIView animateWithDuration: 0.25 animations: ^{
    CGFloat contentOffsetY = sortView.frame.origin.y + 44.0f;
    bar.alpha = 0.0f;
    bar.frame = CGRectMake(bar.frame.origin.x, 20.0f - bar.frame.size.height,
      bar.frame.size.width, bar.frame.size.height);
    navigationBarCover.alpha = 1.0f;
    navigationBarCover.frame = CGRectMake(navigationBarCover.frame.origin.x,
      bar.frame.origin.y - 20.0f, navigationBarCover.frame.size.width,
        navigationBarCover.frame.size.height);
    sortView.frame = CGRectMake(sortView.frame.origin.x, -44.0f,
      sortView.frame.size.width, sortView.frame.size.height);

    // Scroll the remainder of the navigation bar
    _listView.contentOffset = CGPointMake(_listView.contentOffset.x,
      _listView.contentOffset.y + contentOffsetY);
  }];
}

- (void) hideOrShowNavigationBarAndSortView
{
  if (isScrollingListViewDown && _listView.contentOffset.y > 20.0f) {
    [self hideNavigationBarAndSortView];
  }
  else {
    [self showNavigationBarAndSortView];
  }
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
			[propertyInfoView.residencePartialView resetFilmstrip];
        }];
  }
}

- (void) hideResidentListAnnotation
{
  CGRect screen = [[UIScreen mainScreen] bounds];
  if (_residentListMap.frame.origin.y != screen.size.height) {
    CGRect frame = _residentListMap.frame;
    void (^animations) (void) = ^(void) {
      _residentListMap.frame = CGRectMake(frame.origin.x,
        screen.size.height, frame.size.width, screen.size.height * 0.5f);
    };
    [UIView animateWithDuration: 0.15 delay: 0
      options: UIViewAnimationOptionCurveLinear
        animations:animations completion:^(BOOL finished) {
          //
    }];
  }
}

- (BOOL) isOnList
{
  if (segmentedControl.selectedSegmentIndex == 1)
    return YES;
  return NO;
}

- (void) makeSortButtonsVisible: (BOOL) visible
{
  sortButtonsView.hidden = !visible;
  for (UIButton *button in sortButtonArray) {
    button.hidden = !visible;
  }
}

- (NSMutableDictionary *) mapFilterParameters
{
  // Parameters
  NSDictionary *dictionary = (NSDictionary *)
    [self appDelegate].container.mapFilterViewController.valuesDictionary;

  if (!dictionary)
    return nil;

  // Bathrooms
  id bathrooms = [dictionary objectForKey: @"bathrooms"];
  if (bathrooms == [NSNull null])
    bathrooms = @"";

  // Bedrooms
  NSString *bedrooms = [[dictionary objectForKey:
    @"bedrooms"] componentsJoinedByString: @","];

  // Min rent, max rent
  NSNumber *minRent;
  if ([dictionary objectForKey: @"minRent"] != [NSNull null])
    minRent = [dictionary objectForKey: @"minRent"];
  else
    minRent = [NSNumber numberWithInt: 0];
  NSNumber *maxRent;
  if ([dictionary objectForKey: @"maxRent"] != [NSNull null])
    maxRent = [dictionary objectForKey: @"maxRent"];
  else
    maxRent = [NSNumber numberWithInt: 99999];
  if ([maxRent intValue] == 0 && [minRent intValue] == 0) {
    maxRent = [NSNumber numberWithInt: 99999];
  }
  if ([maxRent intValue] < [minRent intValue]) {
    NSNumber *tempMaxRent = maxRent;
    NSNumber *tempMinRent = minRent;
    maxRent = tempMinRent;
    minRent = tempMaxRent;
  }

  // Move in date
  NSString *moveInDateString = @"";
  if ([dictionary objectForKey: @"moveInDate"] != [NSNull null]) {
    NSDate *date = [dictionary objectForKey: @"moveInDate"];
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    moveInDateString = [dateFormatter stringFromDate: date];
  }

  NSMutableDictionary *params = (NSMutableDictionary *) @{
    @"bathrooms": bathrooms,
    @"bedrooms":  bedrooms,
    @"max_rent":  maxRent,
    @"min_rent":  minRent,
    @"move_in_date": moveInDateString
  };

  return params;
}

- (void) mapViewTapped
{
  [self deselectAnnotations];
  [self hidePropertyInfoView];
  [self hideResidentListAnnotation];
}

- (void) refreshProperties
{
  [self mapView: _mapView regionDidChangeAnimated: YES];
}

- (void) reloadTable
{
  // if (_collectionView.alpha == 1.0)
  //   [_collectionView reloadData];
  if (_listView.alpha == 1.0)
    [_listView reloadData];
}


-(void) reloadWithPagination
{
  pagination++;
  __weak OMBMapViewController *weakSelf = self;
  if (pagination >= 1) {
    dispatch_queue_t myThread = dispatch_queue_create(
      "mythreadpagination", NULL);
    dispatch_async(myThread, ^{
      dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf.listView.infiniteScrollingView stopAnimating];
        [weakSelf.listView reloadData];
      });
      // [weakSelf.listView.infiniteScrollingView stopAnimating];
    });
  }
}

- (void) removeAllAnnotations
{
  for (id annotation in _mapView.annotations) {
    if (![annotation isKindOfClass: [MKUserLocation class]])
      [_mapView removeAnnotation: annotation];
  }
}

- (void) resetAndFetchResidencesForList
{
  self.mapView.centerCoordinate = centerCoordinate;
  [self resetListViewResidences];
  [self fetchResidencesForList];
}

- (void) resetCurrentResidencesForList
{
  // Sort
  // Distance
  if (currentSortKey == OMBMapViewListSortKeyDistance) {
    currentResidencesForList = 
      [[OMBResidenceListStore sharedStore] residenceArray];
    // currentResidencesForList = [[OMBResidenceListStore sharedStore]
    //   sortedResidencesByDistanceFromCoordinate: centerCoordinate];
  }
  // Recent
  else if (currentSortKey == OMBMapViewListSortKeyRecent) {
    currentResidencesForList =
      [[OMBResidenceListStore sharedStore] sortedResidencesWithKey:
        @"updatedAt" ascending: NO];
  }
  // Highest price
  else if (currentSortKey == OMBMapViewListSortKeyHighestPrice) {
    currentResidencesForList =
      [[OMBResidenceListStore sharedStore] sortedResidencesWithKey:
        @"minRent" ascending: NO];
  }
  // Lowest price
  else if (currentSortKey == OMBMapViewListSortKeyLowestPrice) {
    currentResidencesForList =
      [[OMBResidenceListStore sharedStore] sortedResidencesWithKey:
        @"minRent" ascending: YES];
  }
  else {
    currentResidencesForList = 
      [[OMBResidenceListStore sharedStore] residenceArray];
    // currentResidencesForList = [[OMBResidenceListStore sharedStore]
    //   sortedResidencesByDistanceFromCoordinate: centerCoordinate];
  }
}

- (void) resetListViewResidences
{
  centerCoordinate         = self.mapView.centerCoordinate;
  currentResidencesForList = nil;
  pagination               = 0;
  self.radiusInMiles       = 0.0f;
  [[OMBResidenceListStore sharedStore] removeResidences];
  [self.listView reloadData];
}

- (NSArray *) residencesForList
{
  if (!currentResidencesForList)
    [self resetCurrentResidencesForList];
  return currentResidencesForList;
}

- (void) setMapViewRegion: (CLLocationCoordinate2D) coordinate
withMiles: (int) miles animated: (BOOL) animated
{
  // 1609 meters = 1 mile
  int distanceInMiles = 1609 * miles;
  MKCoordinateRegion region =
    MKCoordinateRegionMakeWithDistance(coordinate, distanceInMiles,
      distanceInMiles);
  [_mapView setRegion: region animated: animated];
}

- (void) showSearch
{
  [[self appDelegate].container showSearchAndSwitchToList: NO];
}

- (void) showNavigationBarAndSortView
{
  [UIView animateWithDuration: 0.25f animations: ^{
    CGFloat contentOffsetY = sortView.frame.origin.y - 44.0f;
    _listView.contentOffset = CGPointMake(_listView.contentOffset.x,
      _listView.contentOffset.y + contentOffsetY);
  }];
  [self showNavigationBarAnimated: YES];
  [self showSortViewAnimated: YES];
}

- (void) showNavigationBarAnimated: (BOOL) animated
{
  UINavigationBar *bar = self.navigationController.navigationBar;
  CGRect barRect = CGRectMake(bar.frame.origin.x, 20.0f,
    bar.frame.size.width, bar.frame.size.height);
  CGRect coverRect = CGRectMake(navigationBarCover.frame.origin.x,
    bar.frame.origin.y - 20.0f, navigationBarCover.frame.size.width,
      navigationBarCover.frame.size.height);
  if (animated) {
    [UIView animateWithDuration: 0.25f animations: ^{
      bar.alpha = 1.0f;
      bar.frame = barRect;
      navigationBarCover.alpha = 0.0f;
      navigationBarCover.frame =  coverRect;
    }];
  }
  else {
    bar.alpha = 1.0f;
    bar.frame = barRect;
    navigationBarCover.alpha = 0.0f;
    navigationBarCover.frame =  coverRect;
  }
}

- (void) showPropertyInfoViewWithResidence: (OMBResidence *) residence
{
  CGRect screen = [[UIScreen mainScreen] bounds];
  CGRect frame = propertyInfoView.frame;
  [propertyInfoView loadResidenceData: residence];
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
  // NSLog(@"SHOW RESIDENCE VIEW CONTROLLER");
}

- (void) showResidentListAnnotation
{
  CGRect screen = [UIScreen mainScreen].bounds;
  CGRect frame = _residentListMap.frame;
  CGFloat originY = screen.size.height * 0.5f;
  CGFloat height = screen.size.height * 0.5f;

  if([residentAnnotations count] < 3){
    CGFloat adjusment =  (3 - [residentAnnotations count]) *
      _residentListMap.frame.size.height / 3.0f ;
    originY += adjusment;
    height -= adjusment;
  }
  void (^animations) (void) = ^(void) {
    _residentListMap.frame = CGRectMake(frame.origin.x,
      originY, frame.size.width, height);
  };
  [UIView animateWithDuration: 0.15 delay: 0
     options: UIViewAnimationOptionCurveLinear
       animations: animations completion: nil];
}

- (void) showSortButtons
{
  CGFloat slowestDuration = 0.5;
  CGFloat fastestDuration = slowestDuration -
    (0.1 * ([sortButtonArray count] - 1));
  CGFloat degrees = 0.0f;
  if (isShowingSortButtons) {
    degrees = -90.0f;
  }
  // Show all the buttons
  else {
    [self makeSortButtonsVisible: YES];
  }
  [UIView animateWithDuration: fastestDuration animations: ^{
    sortArrow.transform = CGAffineTransformMakeRotation(
      degrees * M_PI / 180.0f);
  }];
  for (UIButton *button in sortButtonArray) {
    CGFloat index    = [sortButtonArray indexOfObject: button];
    CGFloat duration = slowestDuration - (0.1 * index);
    CGFloat originY  = sortView.frame.size.height + 1 +
      ((1.0f + 37.0f) * index);
    if (isShowingSortButtons)
      originY = 20.0f;
    [UIView animateWithDuration: duration animations: ^{
      button.frame = CGRectMake(button.frame.origin.x, originY,
        button.frame.size.width, button.frame.size.height);
    } completion: ^(BOOL finished) {
      if (index == [sortButtonArray count] - 1) {
        if (isShowingSortButtons) {
          [UIView animateWithDuration: 0.0f delay: slowestDuration
            options: UIViewAnimationOptionCurveLinear
              animations: ^{}
                completion: ^(BOOL finished) {
                  [self makeSortButtonsVisible: NO];
                }];
        }
        isShowingSortButtons = !isShowingSortButtons;
      }
    }];
  }
  // NSLog(@"SHOW SORT BUTTONS");
}

- (void) showSortViewAnimated: (BOOL) animated
{
  CGRect rect = CGRectMake(sortView.frame.origin.x, 44.0f,
    sortView.frame.size.width, sortView.frame.size.height);
  if (animated)
    [UIView animateWithDuration: 0.25f animations: ^{
      sortView.frame = rect;
    }];
  else
    sortView.frame = rect;
}

- (void) sortButtonSelected: (UIButton *) button
{
  if (currentSortKey != button.tag) {
    currentSortKey = button.tag;
    [self resetCurrentResidencesForList];
    [_listView reloadData];
  }

  CGFloat slowestDuration = 0.5;
  CGFloat originalY = sortView.frame.origin.y + sortLabel.frame.origin.y +
    ((sortLabel.frame.size.height - sortArrow.frame.size.height) * 0.5);
  NSInteger index = [sortButtonArray indexOfObject: button];
  CGFloat originY = originalY + ((1 + 37.0f) * (index + 1));
  sortArrow.frame = CGRectMake(sortArrow.frame.origin.x, originalY,
    sortArrow.frame.size.width, sortArrow.frame.size.height);
  sortArrow.image = [UIImage imageNamed: @"arrow_left.png"];
  [sortArrow removeFromSuperview];
  [_listViewContainer addSubview: sortArrow];
  [UIView animateWithDuration: 0.1 animations: ^{
    sortArrow.frame = CGRectMake(sortArrow.frame.origin.x, originY,
      sortArrow.frame.size.width, sortArrow.frame.size.height);
  } completion: ^(BOOL finished) {
    // Animate the arrow up and the text for sorting
    CGFloat arrowDistance = originY - originalY;
    CGFloat buttonDistance = button.frame.origin.y - 20.0f;
    CGFloat distanceRatio = arrowDistance / buttonDistance;
    CGFloat arrowDuration = slowestDuration - (0.1 * index);
    arrowDuration *= distanceRatio;
    // NSLog(@"Arrow Distance: %f", arrowDistance);
    // NSLog(@"Button Distance: %f", buttonDistance);
    // NSLog(@"Distance Ratio: %f", distanceRatio);
    // NSLog(@"Arrow Duration: %f", arrowDuration);
    [UIView animateWithDuration: arrowDuration animations: ^{
      sortArrow.frame = CGRectMake(sortArrow.frame.origin.x, originalY,
        sortArrow.frame.size.width, sortArrow.frame.size.height);
    } completion: ^(BOOL finished) {
      sortArrow.frame = CGRectMake(sortArrow.frame.origin.x,
        originalY - sortView.frame.origin.y, sortArrow.frame.size.width,
          sortArrow.frame.size.height);
      sortArrow.image = [UIImage changeColorForImage: [UIImage imageNamed: @"arrow_left_white.png"] toColor:[UIColor blue]];
      [sortArrow removeFromSuperview];
      [sortView addSubview: sortArrow];
      sortSelectionLabel.text = [@"Sorted by " stringByAppendingString:button.currentTitle];
      [UIView animateWithDuration: 0.1 animations: ^{
        sortArrow.transform = CGAffineTransformMakeRotation(
          -90.0f * M_PI / 180.0f);
      }];
    }];
    // Hide the buttons
    for (UIButton *button2 in sortButtonArray) {
      CGFloat index2 = [sortButtonArray indexOfObject: button2];
      CGFloat duration = slowestDuration - (0.1 * index2);
      // NSLog(@"%f : %f", index2, duration);
      [UIView animateWithDuration: duration animations: ^{
        button2.frame = CGRectMake(button2.frame.origin.x, 20.0f,
          button2.frame.size.width, button2.frame.size.height);
      } completion: ^(BOOL finished) {
        isShowingSortButtons = NO;
        if (index2 == [sortButtonArray count] - 1) {
          [UIView animateWithDuration: 0.0f delay: slowestDuration
            options: UIViewAnimationOptionCurveLinear
              animations: ^{}
                completion: ^(BOOL finished) {
                  [self makeSortButtonsVisible: NO];
                }];
        }
      }];
    }
  }];
  // NSLog(@"SORT BUTTON SELECTED");
}

- (void) switchToListView
{
  segmentedControl.selectedSegmentIndex = 1;
  [self switchViews: segmentedControl];
}

- (void) switchViews: (UISegmentedControl *) control
{
  switch (control.selectedSegmentIndex) {
    // Show map
    case 0: {
      if (self.listViewContainer.alpha) {
        self.listViewContainer.alpha = 0.0f;
        self.mapView.alpha           = 1.0f;
        if ([self.mapView.annotations count] == 0) {
          [self mapView: _mapView regionDidChangeAnimated: NO];
          [UIView animateWithDuration: 0.5f animations: ^{
            filterView.transform = CGAffineTransformIdentity;
          }];
        }
      }
      break;
    }
    // Show list
    case 1: {
      if (self.mapView.alpha) {
        self.listViewContainer.alpha = 1.0f;
        self.mapView.alpha           = 0.0f;
        [self fetchResidencesForList];
        [UIView animateWithDuration: 0.5f animations: ^{
          filterView.transform = CGAffineTransformMakeTranslation(
            0.0f, self.view.bounds.size.height - 20.0f - 64.0f);
        }];
      }
      break;
    }
    default:
      break;
  }
}

- (void) updateFilterLabel
{
  NSDictionary *dictionary =
    [self appDelegate].container.mapFilterViewController.valuesDictionary;

  filterLabel.text = @"";
  NSMutableArray *strings = [NSMutableArray array];

  // Rent
  id maxRent = [dictionary objectForKey: @"maxRent"];
  id minRent = [dictionary objectForKey: @"minRent"];
  NSString *maxRentString = @"";
  NSString *minRentString = @"";
  NSString *rentString    = @"";
  // Max rent
  if (maxRent != [NSNull null])
    maxRentString = [NSString numberToCurrencyString: [maxRent intValue]];
  // Min rent
  if (minRent != [NSNull null])
    minRentString = [NSString numberToCurrencyString: [minRent intValue]];

  // $1,234 - $5,678
  if (maxRent != [NSNull null] && [maxRent intValue] > 0 &&
    minRent != [NSNull null] && [minRent intValue] > 0)
    rentString = [NSString stringWithFormat: @"%@ - %@",
      minRentString, maxRentString];
  // Below $5,678
  else if ((maxRent != [NSNull null] && [maxRent intValue] > 0) &&
    (minRent == [NSNull null] || [minRent intValue] == 0))
    rentString = [NSString stringWithFormat: @"Below %@", maxRentString];
  // Above $1,234
  else if ((minRent != [NSNull null] && [minRent intValue] > 0) &&
    (maxRent == [NSNull null] || [maxRent intValue] == 0))
    rentString = [NSString stringWithFormat: @"Above %@", minRentString];
  if ([rentString length] > 0)
    [strings addObject: rentString];

  // Bedrooms
  NSString *bedString = @"";
  NSString *lastBed   = @"";
  NSArray *bedroomsArray =
    [[dictionary objectForKey: @"bedrooms"] sortedArrayUsingComparator:
      ^(id obj1, id obj2) {
        if ([obj1 intValue] > [obj2 intValue])
          return (NSComparisonResult) NSOrderedDescending;
        if ([obj1 intValue] < [obj2 intValue])
          return (NSComparisonResult) NSOrderedAscending;
        return (NSComparisonResult) NSOrderedSame;
      }
    ];
  for (NSNumber *number in bedroomsArray) {
    // Only add the comma if there is a string started already
    if ([lastBed length] > 0)
      bedString = [bedString stringByAppendingString: @", "];
    NSString *s = [number stringValue];
    if ([number intValue] == 0)
      s = @"Studio";
    bedString = [bedString stringByAppendingString: s];
    lastBed   = s;
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

  // Bathrooms
  if ([dictionary objectForKey: @"bathrooms"] != [NSNull null])
    [strings addObject: [NSString stringWithFormat: @"%i+ baths",
      [[dictionary objectForKey: @"bathrooms"] intValue]]];

  // Put everything together
  if ([strings count] > 0)
    filterLabel.text = [strings componentsJoinedByString: @", "];
  // Figure out if the filter label needs to be hidden or not
  if ([filterLabel.text length] > 0)
    filterView.hidden = NO;
  else
    filterView.hidden = YES;

  [self switchViews: segmentedControl];
}

- (void) zoomAtAnnotation: (id <MKAnnotation>) annotation
{
  MKMapRect zoomRect = MKMapRectNull;
  if ([annotation isKindOfClass: [QVClusterAnnotation class]]) {
    QVClusterAnnotation *ann = (QVClusterAnnotation *) annotation;
    for (NSDictionary *dict in ann.coordinates) {
      CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(
        [dict[@"latitude"] doubleValue], [dict[@"longitude"] doubleValue]);
      MKMapPoint annotationPoint = MKMapPointForCoordinate(coord);
      MKMapRect pointRect = MKMapRectMake(annotationPoint.x,
        annotationPoint.y, 0, 0);
      if (MKMapRectIsNull(zoomRect))
        zoomRect = pointRect;
      else
        zoomRect = MKMapRectUnion(zoomRect, pointRect);
    }
    [self.mapView setVisibleMapRect: zoomRect animated: YES];
  }
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

- (NSUInteger) zoomLevelForMapRect: (MKMapRect) mRect
withMapViewSizeInPixels: (CGSize) viewSizeInPixels
{
  NSUInteger MAXIMUM_ZOOM = 20;
  NSUInteger zoomLevel = MAXIMUM_ZOOM;
  // MKZoomScale is just a CGFloat typedef
  MKZoomScale zoomScale = mRect.size.width / viewSizeInPixels.width;
  double zoomExponent = log2(zoomScale);
  zoomLevel = (NSUInteger)(MAXIMUM_ZOOM - ceil(zoomExponent));
  return zoomLevel;
}

- (void) updateMapViewAnnotationsWithAnnotations: (NSArray *) annotations
{
  // The annotations in the snapshot are exactly the mapView's
  // current annotations. We call this the before set
  // The snapshot of the map immediately after the region changes
  // is exactly what we get back from this method; the after set.

  // We want to keep all the annotations which both sets have in common
  // (set intersection). Get rid of the ones which are not in the
  // after set and add the ones which are left.

  NSMutableSet *before = [NSMutableSet setWithArray: self.mapView.annotations];
  NSSet *after = [NSSet setWithArray: annotations];

  // Annotations circled in blue shared by both sets
  NSMutableSet *toKeep = [NSMutableSet setWithSet: before];
  [toKeep intersectSet: after];

  // Annotations circled in green
  NSMutableSet *toAdd = [NSMutableSet setWithSet: after];
  [toAdd minusSet: toKeep];

  // Annotations circled in red; to be removed
  NSMutableSet *toRemove = [NSMutableSet setWithSet: before];
  [toRemove minusSet: after];

  // These two methods must be called on the main thread
  [[NSOperationQueue mainQueue] addOperationWithBlock: ^{
    [self.mapView addAnnotations: [toAdd allObjects]];
    [self.mapView removeAnnotations: [toRemove allObjects]];
  }];
}

@end
