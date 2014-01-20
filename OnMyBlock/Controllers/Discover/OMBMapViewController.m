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
#import "OCMapView.h"
#import "OMBAnnotation.h"
#import "OMBAnnotationCity.h"
#import "OMBAnnotationView.h"
#import "OMBMapFilterViewController.h"
#import "OMBNavigationController.h"
#import "OMBNeighborhood.h"
#import "OMBPropertyInfoView.h"
#import "OMBResidenceBookItConfirmDetailsViewController.h"
#import "OMBResidenceCell.h"
#import "OMBResidenceCollectionViewCell.h"
#import "OMBResidenceListStore.h"
#import "OMBResidencePartialView.h"
#import "OMBResidenceStore.h"
#import "OMBResidence.h"
#import "OMBResidenceDetailViewController.h"
#import "OMBSpringFlowLayout.h"
#import "OMBUser.h"
#import "OMBViewControllerContainer.h"
#import "UIColor+Extensions.h"
#import "UIImage+Color.h"
#import "UIImage+Resize.h"

float const PropertyInfoViewImageHeightPercentage = 0.4;

static NSString *CollectionCellIdentifier = @"CollectionCellIdentifier";

@implementation OMBMapViewController

#pragma mark Initializer

- (id) init
{
  if (!(self = [super init])) return nil;

  centerCoordinate = CLLocationCoordinate2DMake(32.78166389765503,
    -117.16957478041991);
  fetching = NO;
  _radiusInMiles = 0;
  
  // Location manager
  locationManager                 = [[CLLocationManager alloc] init];
  locationManager.delegate        = self;
  locationManager.desiredAccuracy = kCLLocationAccuracyBest;
  locationManager.distanceFilter  = 50;
  [OMBResidenceStore sharedStore].mapViewController = self;

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
  CGFloat padding = 20.0f;

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
  sortView.blurTintColor = [UIColor blue];
  sortView.frame = CGRectMake(0.0f, 44.0f, 
    _listViewContainer.frame.size.width, 20.0f + 44.0f);
  // [_listViewContainer addSubview: sortView];
  UITapGestureRecognizer *sortViewTap = 
    [[UITapGestureRecognizer alloc] initWithTarget: self 
      action: @selector(showSortButtons)];
  [sortView.toolbar addGestureRecognizer: sortViewTap];
  // Sort label
  sortLabel = [[UILabel alloc] init];
  sortLabel.font = [UIFont fontWithName: @"HelveticaNeue-Light" size: 15];
  sortLabel.frame = CGRectMake(padding, sortView.frame.size.height - 44.0f,
    0.0f, 44.0f);
  sortLabel.text = @"Sort";
  sortLabel.textColor = [UIColor whiteColor];
  CGRect sortRect = [sortLabel.text boundingRectWithSize: 
    CGSizeMake(screenWidth, sortLabel.frame.size.height) 
      options: NSStringDrawingUsesLineFragmentOrigin
        attributes: @{ NSFontAttributeName: sortLabel.font }
          context: nil];
  sortLabel.frame = CGRectMake(sortLabel.frame.origin.x, 
    sortLabel.frame.origin.y, sortRect.size.width, sortLabel.frame.size.height);
  [sortView addSubview: sortLabel];
  // Sort selection label
  sortSelectionLabel = [[UILabel alloc] init];
  sortSelectionLabel.font = sortLabel.font;
  sortSelectionLabel.frame = CGRectMake(0.0f, sortLabel.frame.origin.y, 
    screenWidth, sortLabel.frame.size.height);
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
  sortArrow.image = [UIImage imageNamed: @"arrow_left_white.png"];
  sortArrow.transform = CGAffineTransformMakeRotation(-90 * M_PI / 180.0f);
  [sortView addSubview: sortArrow];

  // Sort button array
  sortButtonHighestPrice = [[UIButton alloc] init];
  sortButtonLowestPrice  = [[UIButton alloc] init];
  sortButtonPopular      = [[UIButton alloc] init];
  sortButtonMostRecent   = [[UIButton alloc] init];
  sortButtonArray = @[
    sortButtonPopular,
    sortButtonMostRecent,
    sortButtonHighestPrice,
    sortButtonLowestPrice
  ];
  CGFloat sortButtonViewHeight = sortView.frame.size.height + 
    ((1 + 44) * [sortButtonArray count]);
  sortButtonsView = [[UIView alloc] init];
  sortButtonsView.frame = CGRectMake(0.0f, sortView.frame.origin.y, 
    sortView.frame.size.width, sortButtonViewHeight);
  sortButtonsView.hidden = YES;
  for (UIButton *button in sortButtonArray) {
    button.backgroundColor = [UIColor colorWithWhite: 255/255.0 alpha: 0.95];
    button.frame = CGRectMake(0.0f, 20.0f,
      sortButtonsView.frame.size.width, 44.0f);
    button.hidden = YES;
    NSString *string = @"";
    if (button == sortButtonHighestPrice) {
      string = @"Highest Price";
    }
    else if (button == sortButtonLowestPrice) {
      string = @"Lowest Price";
    }
    else if (button == sortButtonPopular) {
      string = @"Student Popularity";
    }
    else if (button == sortButtonMostRecent) {
      string = @"Most Recent";
    }
    button.titleLabel.font = sortLabel.font;
    [button addTarget: self action: @selector(sortButtonSelected:)
      forControlEvents: UIControlEventTouchUpInside];
    [button setBackgroundImage: [UIImage imageWithColor: [UIColor blue]]
      forState: UIControlStateHighlighted];
    [button setTitle: string forState: UIControlStateNormal];
    [button setTitleColor: [UIColor textColor] forState: UIControlStateNormal];
    [button setTitleColor: [UIColor whiteColor] 
      forState: UIControlStateHighlighted];
    [sortButtonsView addSubview: button];
  }
  // [_listViewContainer insertSubview: sortButtonsView belowSubview: sortView];

  // List view
  _listView = [[UITableView alloc] init];
  _listView.backgroundColor              = [UIColor blackColor];
  _listView.canCancelContentTouches      = YES;
  _listView.dataSource                   = self;
  _listView.delegate                     = self;
  _listView.frame                        = screen;
  _listView.separatorColor               = [UIColor clearColor];
  _listView.separatorStyle               = UITableViewCellSeparatorStyleNone;
  // _listView.showsVerticalScrollIndicator = NO;
  // _listView.tableHeaderView = [[UIView alloc] initWithFrame: 
  //   CGRectMake(0.0f, 0.0f, _listView.frame.size.width, 44.0f)];
  [_listViewContainer insertSubview: _listView atIndex: 0];

  // Map view
  _mapView          = [[OCMapView alloc] init];
  _mapView.alpha    = 0.0f;
  _mapView.delegate = self;
  _mapView.frame    = screen;
  _mapView.mapType  = MKMapTypeStandard;
  // mapView.rotateEnabled = NO;
  _mapView.showsPointsOfInterest = NO;
  UITapGestureRecognizer *mapViewTap = 
    [[UITapGestureRecognizer alloc] initWithTarget: self 
      action: @selector(mapViewTapped)];
  [_mapView addGestureRecognizer: mapViewTap];
  [self.view addSubview: _mapView];

  // Filter
  // View
  filterView = [[UIView alloc] init];
  filterView.backgroundColor = [UIColor colorWithWhite: 1.0f alpha: 0.8f];
  filterView.frame = CGRectMake(0.0f, screenHeight - 20.0f, screenWidth, 20.0f);
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
  currentLocationButton.frame = CGRectMake(10, (screen.size.height - (10 + 40)),
    40, 40);
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
  [_mapView addSubview: currentLocationButton];

  // Property info view
  propertyInfoView = [[OMBPropertyInfoView alloc] init];
  [_mapView addSubview: propertyInfoView];
  // Add a tap gesture to property info view
  UITapGestureRecognizer *tap = 
    [[UITapGestureRecognizer alloc] initWithTarget:
      self action: @selector(showResidenceDetailViewController)];
  [propertyInfoView addGestureRecognizer: tap];

  // Activity indicator view
  // activityIndicatorView = 
  //   [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: 
  //     UIActivityIndicatorViewStyleWhite];
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
  _mapView.showsUserLocation = YES;
  // Load default latitude and longitude
  CLLocationCoordinate2D coordinate;
  coordinate.latitude  = 32.78166389765503;
  coordinate.longitude = -117.16957478041991;

  [self setMapViewRegion: coordinate withMiles: 4 animated: YES];

  // Find user's location
  [locationManager startUpdatingLocation];
}

- (void) viewWillDisappear: (BOOL) animated
{
  [super viewWillDisappear: animated];
  [self showNavigationBarAnimated: NO];
}

- (void) viewWillAppear: (BOOL) animated
{
  [super viewWillAppear: animated];

  [self reloadTable];

  NSDictionary *dictionary = (NSDictionary *)
    [self appDelegate].container.mapFilterViewController.valuesDictionary;
  // Filter
  // Neighborhood
  if ([dictionary objectForKey: @"neighborhood"] != [NSNull null]) {
    OMBNeighborhood *neighborhood = [dictionary objectForKey: 
      @"neighborhood"];
    centerCoordinate = neighborhood.coordinate;
    [self setMapViewRegion: centerCoordinate withMiles: 4 animated: NO];
    if ([self isOnList]) {
      [self resetListViewResidences];
      [self fetchResidencesForList];
    }
  }
  // If there are filter values, apply and search
  if ([self appDelegate].container.mapFilterViewController.shouldSearch) {
    if ([self isOnList]) {
      [self resetListViewResidences];
      [self fetchResidencesForList];
    }
    else {
      [self setMapViewRegion: centerCoordinate withMiles: 4 animated: NO];
    }
    [self appDelegate].container.mapFilterViewController.shouldSearch = NO;
  }

  // Check any filter values and display them
  [self updateFilterLabel];
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
  if ([self mapFilterParameters] != nil)
    [params addEntriesFromDictionary: [self mapFilterParameters]];

  [[OMBResidenceStore sharedStore] fetchPropertiesWithParameters: params
    completion: nil];

  [self deselectAnnotations];
  [self hidePropertyInfoView];

  if (![self isOnList])
    [self resetListViewResidences];
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
  else if ([annotationView.annotation isKindOfClass: [OMBAnnotationCity class]])
    [self setMapViewRegion: annotationView.annotation.coordinate
      withMiles: 20 animated: YES];
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
  // MKAnnotationView *av = [map dequeueReusableAnnotationViewWithIdentifier:
  //   ReuseIdentifier];
  // if (!av)
  //   av = [[MKAnnotationView alloc] init];
  // return av;
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

#pragma mark - Protocol UIScrollViewDelegate

- (void) scrollViewDidEndDragging: (UIScrollView *) scrollView 
willDecelerate: (BOOL) decelerate
{
  isDraggingListView = NO;
  [self hideOrShowNavigationBarAndSortView];
}

- (void) scrollViewWillBeginDragging: (UIScrollView *) scrollView
{
  isDraggingListView = YES;
  previousOffsetY = scrollView.contentOffset.y;
  currentDistanceOfScrolling = 0.0f;
  if (isShowingSortButtons) {
    [UIView animateWithDuration: 0.1 animations: ^{
      sortArrow.transform = CGAffineTransformMakeRotation(-90 * M_PI / 180.0f);
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

  // Fetch more residences when scrolling down
  if (scrollView == _listView) {
    CGFloat scrollViewHeight = scrollView.frame.size.height;
    CGFloat contentHeight    = scrollView.contentSize.height;
    CGFloat totalContentOffset = contentHeight - scrollViewHeight;
    CGFloat limit = totalContentOffset - (scrollViewHeight / 1.0f);
    if (!fetching && y > limit) {
      fetching = YES;
      [self fetchResidencesForList];
    }
  }
}

#pragma mark - Protocol UITableViewDataSource

- (UITableViewCell *) tableView: (UITableView *) tableView
cellForRowAtIndexPath: (NSIndexPath *) indexPath
{
  static NSString *CellIdentifier = @"CellIdentifier";
  OMBResidenceCell *cell = [tableView dequeueReusableCellWithIdentifier:
    CellIdentifier];
  if (!cell) {
    cell = [[OMBResidenceCell alloc] initWithStyle: 
      UITableViewCellStyleDefault reuseIdentifier: CellIdentifier];
  }
  return cell;
}

- (NSInteger) tableView: (UITableView *) tableView
numberOfRowsInSection: (NSInteger) section
{
  return [[OMBResidenceListStore sharedStore].residences count];
  return [[self propertiesSortedBy: @"" ascending: NO] count];
}

#pragma mark - Protocol UITableViewDelegate

- (void) tableView: (UITableView *) tableView 
didEndDisplayingCell: (UITableViewCell *) cell 
forRowAtIndexPath: (NSIndexPath *) indexPath
{
  // if (tableView == _listView) {
  //   if ([[self residencesForList] count] > indexPath.row) {
  //     OMBResidence *residence = [[self residencesForList] objectAtIndex: 
  //       indexPath.row];
  //     if (!residence.coverPhotoForCell) {
  //       OMBResidenceCell *c = (OMBResidenceCell *) cell;
  //       c.imageView.image   = nil;
  //       NSLog(@"DID END DISPLAY: %i", residence.uid);
  //     }
  //   }
  // }
}

- (void) tableView: (UITableView *) tableView
didSelectRowAtIndexPath: (NSIndexPath *) indexPath
{
  // OMBResidence *residence = [[self propertiesSortedBy: @"" 
  //   ascending: NO] objectAtIndex: indexPath.row];

  if (tableView == _listView && 
    [[self residencesForList] count] > indexPath.row) {

    OMBResidence *residence = [[self residencesForList] objectAtIndex: 
      indexPath.row];
    [self.navigationController pushViewController:
      [[OMBResidenceDetailViewController alloc] initWithResidence: 
        residence] animated: YES];
  }
}

- (CGFloat) tableView: (UITableView *) tableView
heightForRowAtIndexPath: (NSIndexPath *) indexPath
{
  CGRect screen = [[UIScreen mainScreen] bounds];
  return screen.size.height * PropertyInfoViewImageHeightPercentage;
}

- (void) tableView: (UITableView *) tableView 
willDisplayCell: (UITableViewCell *) cell 
forRowAtIndexPath: (NSIndexPath *) indexPath
{
  if (tableView == _listView) {
    if ([[self residencesForList] count] > 0) {
      OMBResidence *residence = [[self residencesForList] objectAtIndex: 
        indexPath.row];
      [(OMBResidenceCell *) cell loadResidenceData: residence];
    }
  }
  // NSArray *properties = [self propertiesSortedBy: @"" ascending: NO];
  // if ([properties count] > 0)
  //   [(OMBResidenceCell *) cell loadResidenceData: 
  //     [properties objectAtIndex: indexPath.row]];
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
  int count = (int) [annotations count];
  [_mapView removeAnnotations: _mapView.annotations];
  if (count < 700)
    [_mapView addAnnotations: annotations];
  else {
    // Create annotation
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(
      32.7150, -117.1625);
    OMBAnnotationCity *annotation = [[OMBAnnotationCity alloc] init];
    annotation.cityName   = @"San Diego";
    annotation.coordinate = coordinate;
    annotation.title      = [NSString stringWithFormat: @"%i", count];
    [_mapView addAnnotation: annotation];
  }
}

- (void) deselectAnnotations
{
  for (OMBAnnotation *annotation in _mapView.selectedAnnotations) {
    if ([annotation class] != [MKUserLocation class] &&
      [annotation class] != [OCAnnotation class])
      
      [annotation.annotationView deselect];
    [_mapView deselectAnnotation: annotation animated: NO];
  }
}

- (void) fetchResidencesForList
{
  // Fetch residences for list
  
  // One degree of latitude is always approximately 111 kilometers (69 miles)
  // One degree of longitude is approximately 111 kilometers (69 miles)

  _radiusInMiles += 4;

  CGFloat maxLatitude, maxLongitude, minLatitude, minLongitude;

  CGFloat degrees = _radiusInMiles / 69.0f;

  // Northwest = maxLatitude, minLongitude
  maxLatitude  = centerCoordinate.latitude + (degrees * 0.5f);
  minLongitude = centerCoordinate.longitude - (degrees * 0.5f);

  // Southeast = minLatitude, maxLongitude
  minLatitude  = centerCoordinate.latitude - (degrees * 0.5f);
  maxLongitude = centerCoordinate.longitude + (degrees * 0.5f);

  // Bounds
  NSString *bounds = [NSString stringWithFormat: @"[%f,%f,%f,%f]",
    minLongitude, maxLatitude, maxLongitude, minLatitude];

  NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:
    [self mapFilterParameters]];
  [params setObject: bounds forKey: @"bounds"];

  CGFloat currentCount = [[OMBResidenceListStore sharedStore].residences count];
  
  [[OMBResidenceListStore sharedStore] fetchResidencesWithParameters: params 
    completion: ^(NSError *error) {
      [self reloadTable];
      fetching = NO;
      // Stop fetching residences after 100 mile radius
      if (_radiusInMiles < 100) {
        CGFloat newCount = 
          [[OMBResidenceListStore sharedStore].residences count];
        // If the count never changed
        if (newCount == currentCount || 
          _listView.contentSize.height <= _listView.frame.size.height)
          [self fetchResidencesForList];
      }
    }
  ];
}

- (void) foundLocations: (NSArray *) locations
{
  CLLocationCoordinate2D coordinate;
  if ([locations count]) {
    for (CLLocation *location in locations) {
      coordinate = location.coordinate;
    }
    [self setMapViewRegion: coordinate withMiles: 2 animated: YES];
  }
  [locationManager stopUpdatingLocation];
}

- (void) goToCurrentLocation
{
  [self goToCurrentLocationAnimated: YES];
}

- (void) goToCurrentLocationAnimated: (BOOL) animated
{
  [_mapView setCenterCoordinate: [_mapView userLocation].coordinate
    animated: animated];
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
          propertyInfoView.imageView.image = nil;
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

  NSMutableDictionary *params = (NSMutableDictionary *) @{
    @"bathrooms": bathrooms,
    @"bedrooms":  bedrooms,
    @"max_rent":  maxRent,
    @"min_rent":  minRent
  };

  return params;
}

- (void) mapViewTapped
{
  [self deselectAnnotations];
  [self hidePropertyInfoView];
}

- (NSArray *) propertiesSortedBy: (NSString *) key ascending: (BOOL) ascending
{
  NSSet *visibleAnnotations = [_mapView annotationsInMapRect: 
    _mapView.visibleMapRect];
  return [[OMBResidenceStore sharedStore] propertiesFromAnnotations: 
      visibleAnnotations sortedBy: key ascending: ascending];
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

- (void) removeAllAnnotations
{
  for (id annotation in _mapView.annotations) {
    if (![annotation isKindOfClass: [MKUserLocation class]])
      [_mapView removeAnnotation: annotation];
  }
}

- (void) resetListViewResidences
{
  [[OMBResidenceListStore sharedStore].residences removeAllObjects];

  centerCoordinate = _mapView.centerCoordinate;
  
  _radiusInMiles = 0.0f;
}

- (NSArray *) residencesForList
{
  return [OMBResidenceListStore sharedStore].residences;
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
  NSLog(@"SHOW RESIDENCE VIEW CONTROLLER");
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
      ((1.0f + 44.0f) * index);
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
  NSLog(@"SHOW SORT BUTTONS");
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
  CGFloat slowestDuration = 0.5;
  CGFloat originalY = sortView.frame.origin.y + sortLabel.frame.origin.y + 
    ((sortLabel.frame.size.height - sortArrow.frame.size.height) * 0.5);
  NSInteger index = [sortButtonArray indexOfObject: button];
  CGFloat originY = originalY + ((1 + 44.0f) * (index + 1));
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
    NSLog(@"Arrow Distance: %f", arrowDistance);
    NSLog(@"Button Distance: %f", buttonDistance);
    NSLog(@"Distance Ratio: %f", distanceRatio);
    NSLog(@"Arrow Duration: %f", arrowDuration);
    [UIView animateWithDuration: arrowDuration animations: ^{
      sortArrow.frame = CGRectMake(sortArrow.frame.origin.x, originalY,
        sortArrow.frame.size.width, sortArrow.frame.size.height);
    } completion: ^(BOOL finished) {
      sortArrow.frame = CGRectMake(sortArrow.frame.origin.x,
        originalY - sortView.frame.origin.y, sortArrow.frame.size.width,
          sortArrow.frame.size.height);
      sortArrow.image = [UIImage imageNamed: @"arrow_left_white.png"];
      [sortArrow removeFromSuperview];
      [sortView addSubview: sortArrow];
      sortSelectionLabel.text = button.currentTitle;
      [UIView animateWithDuration: 0.1 animations: ^{
        sortArrow.transform = CGAffineTransformMakeRotation(
          -90.0f * M_PI / 180.0f);
      }];
    }];
    // Hide the buttons
    for (UIButton *button2 in sortButtonArray) {
      CGFloat index2 = [sortButtonArray indexOfObject: button2];
      CGFloat duration = slowestDuration - (0.1 * index2);
      NSLog(@"%f : %f", index2, duration);
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
   NSLog(@"SORT BUTTON SELECTED");
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
      _listViewContainer.alpha = 0.0;
      _mapView.alpha           = 1.0;
      [self mapView: _mapView regionDidChangeAnimated: NO];
      break;
    }
    // Show list
    case 1: {
      _listViewContainer.alpha = 1.0;
      _mapView.alpha           = 0.0;     
      [self fetchResidencesForList];
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
