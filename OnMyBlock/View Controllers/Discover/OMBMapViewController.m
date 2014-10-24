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
#import "NSString+OnMyBlock.h"
#import "NSUserDefaults+OnMyBlock.h"
#import "OCMapView.h"
#import "OMBActivityViewFullScreen.h"
#import "OMBActivityView.h"
#import "OMBAnnotation.h"
#import "OMBAnnotationCity.h"
#import "OMBAnnotationView.h"
#import "OMBEmptyBackgroundWithImageAndLabel.h"
#import "OMBEmptyResultsOverlayView.h"
#import "OMBMapFilterViewController.h"
#import "OMBMapResidenceDetailCell.h"
#import "OMBNavigationController.h"
#import "OMBNeedHelpCell.h"
#import "OMBNeedHelpViewController.h"
#import "OMBNeighborhood.h"
#import "OMBPropertyInfoView.h"
#import "OMBResidenceBookItConfirmDetailsViewController.h"
#import "OMBResidence.h"
#import "OMBResidenceCell.h"
#import "OMBResidenceCollectionViewCell.h"
#import "OMBResidenceDetailViewController.h"
#import "OMBResidencePartialView.h"
#import "OMBSchool.h"
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
// Stores
#import "OMBAllResidenceStore.h"
#import "OMBNeighborhoodStore.h"
#import "OMBResidenceListStore.h"
#import "OMBResidenceMapStore.h"
#import "OMBSchoolStore.h"

#define CLCOORDINATE_EPSILON 0.005f
#define CLCOORDINATES_EQUAL2(coord1, coord2) (fabs(coord1.latitude - coord2.latitude) < CLCOORDINATE_EPSILON && fabs(coord1.longitude - coord2.longitude) < CLCOORDINATE_EPSILON)

float const PropertyInfoViewImageHeightPercentage = 0.4;

int kMaxRadiusInMiles = 100;

const CGFloat DEFAULT_MILE_RADIUS        = 4.0f;
const NSUInteger MINIMUM_SPINNER_COUNTER = 3;
const NSUInteger MINIMUM_ZOOM_LEVEL      = 12;

static NSString *CollectionCellIdentifier = @"CollectionCellIdentifier";

@interface OMBMapViewController ()
<
  CLLocationManagerDelegate, MKMapViewDelegate, 
  OMBResidenceListStoreDelegate, OMBResidenceMapStoreDelegate,
  UIAlertViewDelegate,
  UIGestureRecognizerDelegate, UIScrollViewDelegate, UITableViewDataSource,
  UITableViewDelegate
>
{
  UIActivityIndicatorView *activityIndicatorView;
  OMBActivityView *activityView;
  OMBActivityViewFullScreen *activityViewFullScreen;
  CLLocationCoordinate2D centerCoordinate;
  CGFloat currentDistanceOfScrolling;
  NSArray *currentResidencesForList;
  UIButton *currentLocationButton;
  OMBMapViewListSortKey currentSortKey;
  OMBEmptyBackgroundWithImageAndLabel *emptyBackground;
  OMBEmptyResultsOverlayView *emptyOverlayView;
  BOOL fetching;
  UILabel *filterLabel;
  UIView *filterView;
  BOOL firstLoad;
  BOOL isCurrentLocation;
  BOOL isDraggingListView;
  BOOL isFetchingResidencesForMap;
  BOOL isScrollingFast;
  BOOL isScrollingListViewDown;
  BOOL isShowingSortButtons;
  BOOL isSpinning;
  CGPoint lastOffset;
  NSTimeInterval lastOffsetCapture;
  CLLocationManager *locationManager;
  BOOL manageEmpty;
  AMBlurView *navigationBarCover;
  NSMutableArray *neighborhoodAnnotationArray;
  int pagination;
  NSDictionary *previousMapFilterParameters;
  CGFloat previousOffsetY;
  NSUInteger previousZoomLevel;
  OMBPropertyInfoView *propertyInfoView;
  CGFloat radiusIncrementInMiles;
  OMBAnnotationCity *sanDiegoAnnotationCity;
  NSString *schoolName;
  UISegmentedControl *segmentedControl;
  BOOL showHelpView;
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
  NSUInteger residenceListStoreCurrentCount;
  NSMutableArray *residentAnnotations;
  QVClusterAnnotation *recentResidence;
  NSTimer *timer;
  NSUInteger timerCounter;

  // Controllers
  MapController *mapController;
}

@property (strong, nonatomic) QVCoordinateQuadTree *coordinateQuadTree;

@end

@implementation OMBMapViewController

#pragma mark Initializer

- (id)init
{
  if (!(self = [super init])) return nil;

  fetching               = NO;
  firstLoad              = YES;
  mapController          = [[MapController alloc] init];
  pagination             = 0;
  radiusIncrementInMiles = 0.25f;
  self.radiusInMiles     = 0;
  showHelpView           = YES;

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

      [neighborhoodAnnotationArray addObject:annotationCity];
    }
  }

  previousZoomLevel = 0;
  timer = [NSTimer timerWithTimeInterval:1 target:self 
    selector:@selector(timerFired:) userInfo:nil repeats:YES];
  timerCounter = MINIMUM_SPINNER_COUNTER;
  [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];

  [[NSNotificationCenter defaultCenter] addObserver: self
    selector: @selector(refreshProperties)
      name: OMBUserLoggedInNotification object: nil];

  return self;
}

#pragma mark - Override

#pragma mark - Override UIViewController

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  [self resetListViewResidences];
}

- (void)viewDidDisappear:(BOOL)animated
{
  [super viewDidDisappear:animated];
  [self showSortViewAnimated:NO];
}

- (void)viewDidLoad
{
  [super viewDidLoad];

  [self configureViews];
  
  [self setDefaultCenterCoordinate];
  [self setMapViewRegion:centerCoordinate withMiles:DEFAULT_MILE_RADIUS 
    animated:YES];

  self.mapView.delegate = self;

  [self setupInfiniteScrolling];
}

- (void)viewWillDisappear:(BOOL)animated
{
  [super viewWillDisappear:animated];
  [self showNavigationBarAnimated:NO];
  [[OMBResidenceListStore sharedStore] cancelConnection];
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];

  timerCounter = MINIMUM_SPINNER_COUNTER;

  [self resetMap];

  // This is so that the spinner doesn't freeze and just stay there
  if (fetching) {
    fetching = NO;
  }
  // Only stop the spinner if it is spinning and there is at least 1 residence
  if (activityView.isSpinning && [[self residencesForList] count]) {
    [activityView stopSpinning];
  }

  // This reloads the list view if it is visible
  [self reloadTable];

  [self determineShouldSearch];

  // Check any filter values and display them
  [self updateFilterLabel];
  [self updateRecentResidence];
}

#pragma mark - Protocol

#pragma mark - Protocol OMBResidenceListStoreDelegate

- (void)fetchResidencesForListFailed:(NSError *)error
{
  [self showAlertViewWithError:error];
}

- (void)fetchResidencesForListSucceeded:(id)responseObject
{
  [[OMBResidenceListStore sharedStore] readFromDictionary:responseObject];
  if (firstLoad) {
    [self stopSpinning];
    firstLoad  = NO;
  }

  // _listView.showsPullToRefresh = YES;

  fetching = NO;
  [self resetCurrentResidencesForList];
  [self reloadTable];

  if (residenceListStoreCurrentCount == 0) {
    [self downloadResidenceImagesForVisibleCells];
  }

  if (self.radiusInMiles < kMaxRadiusInMiles) {
    NSInteger newCount =
      [[OMBResidenceListStore sharedStore].residences count];
    // NSLog(@"NEW COUNT:     %i", newCount);

    // If the count never changed
    if (newCount == residenceListStoreCurrentCount) {
      // Fetch again
      [self fetchResidencesForList];
    }
    // If new residences were found and added
    else {
      [self stopSpinning];
      if ([[self residencesForList] count]) {
        emptyBackground.alpha = 0.0f;
        if ([[self residencesForList] count] < 2) {
          [self fetchResidencesForList];
        }
      }
    }
  }
  else {
    // Stop fetching residences after 100 mile radius
    [self stopSpinning];
    if ([[self residencesForList] count] == 0) {
      [UIView animateWithDuration: OMBStandardDuration animations: ^{
        emptyBackground.alpha = 1.0f;
      }];
    }
  }
  [self reloadTable];
}

#pragma mark - Protocol OMBResidenceMapStoreDelegate

- (void)fetchResidencesForMapFailed:(NSError *)error
{
  [self showAlertViewWithError:error];
}

- (void)fetchResidencesForMapSucceeded:(id)responseObject
{
  if (previousZoomLevel >= MINIMUM_ZOOM_LEVEL) {
    [[OMBResidenceMapStore sharedStore] readFromDictionary:responseObject];
    [self.coordinateQuadTree buildTreeWithResidences:
      [[OMBResidenceMapStore sharedStore] residences]];
  }
  isFetchingResidencesForMap = NO;
  [[NSOperationQueue new] addOperationWithBlock:^{
    double zoomScale = self.mapView.bounds.size.width /
      self.mapView.visibleMapRect.size.width;
    NSArray *annotations =
      [self.coordinateQuadTree clusteredAnnotationsWithinMapRect:
        self.mapView.visibleMapRect withZoomScale:zoomScale];
    [self updateMapViewAnnotationsWithAnnotations:annotations];
  }];
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
  if (tableView == _listView){
    if (indexPath.row == 0 && [self shouldShowHelpView]) {
      static NSString *NeedHelpID = @"NeedHelpID";
      OMBNeedHelpCell *cell = [tableView
        dequeueReusableCellWithIdentifier:NeedHelpID];
      
      if (!cell) {
        cell = [[OMBNeedHelpCell alloc] initWithStyle:
          UITableViewCellStyleDefault reuseIdentifier:NeedHelpID];
        cell.secondLabel.text = @"Contact us";
        cell.titleLabel.text  = @"Need a place now?";
        [cell setBackgroundImage:@"background_blue_texture" withBlur:NO];
        [cell addLogoImage];
        [cell disableTintView];
      }
      return cell;
    }
    else{
      NSInteger originalRow;
      if ([self shouldShowHelpView]) {
        originalRow = indexPath.row - 1;
      }
      else {
        originalRow = indexPath.row;
      }
      
      static NSString *CellIdentifier = @"CellIdentifier";
      OMBResidenceCell *cell = [tableView dequeueReusableCellWithIdentifier:
        CellIdentifier];
      if (!cell) {
        cell = [[OMBResidenceCell alloc] initWithStyle:
          UITableViewCellStyleDefault reuseIdentifier: CellIdentifier];
      }
      OMBResidence *residence = [[self residencesForList] objectAtIndex:
        originalRow];
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
    cell.clipsToBounds = YES;
    return cell;
  }

  return emptyCell;
}

- (NSInteger) tableView: (UITableView *) tableView
numberOfRowsInSection: (NSInteger) section
{
  // Resident list
  if(tableView == _listView){
    NSInteger rows;
    
    if([currentResidencesForList count] < (pagination + 1) * 10)
      rows = [currentResidencesForList count];
    else
      rows = (pagination + 1) * 10;
    
    return [self shouldShowHelpView] ? rows + 1 : rows;
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
  // List Annotations
  if (tableView == _residentListMap &&
     [residentAnnotations count] > indexPath.row) {
    OMBResidence *residence = [residentAnnotations objectAtIndex:
      indexPath.row];
    [self.navigationController pushViewController:
      [[OMBResidenceDetailViewController alloc] initWithResidence:
        residence] animated: YES];
  }
  // Need help row
  else if (tableView == _listView &&
          [[tableView cellForRowAtIndexPath:indexPath]
            isKindOfClass:[OMBNeedHelpCell class]]) {
    [self showHelp];
  }

  [tableView deselectRowAtIndexPath: indexPath animated: YES];
}

- (CGFloat) tableView: (UITableView *) tableView
heightForRowAtIndexPath: (NSIndexPath *) indexPath
{
  CGRect screen = [[UIScreen mainScreen] bounds];
  // Resident list
  if (tableView == _listView) {
    return screen.size.height * PropertyInfoViewImageHeightPercentage;
  }
  // Resident annotation
  else if (tableView == _residentListMap) {
    NSInteger factor = [residentAnnotations count];
    if (factor > 3) {
      factor = 3;
    }
    return _residentListMap.frame.size.height / factor;
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

- (void)fetchResidencesForList
{
  // Fetch residences for list

  // One degree of latitude is always approximately 111 kilometers (69 miles)
  // One degree of longitude is approximately 111 kilometers (69 miles)

  if (fetching || _radiusInMiles > kMaxRadiusInMiles) {
    return;
  }
  else if ([[self residencesForList] count] == 0 && !isSpinning) {
    [self startSpinning];
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

  residenceListStoreCurrentCount =
    [[OMBResidenceListStore sharedStore].residences count];
  // NSLog(@"CURRENT COUNT: %i", currentCount);

  [[OMBResidenceListStore sharedStore] fetchResidencesWithParameters:params
    delegate:self];
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
    
    [self manageEmptyWithSchoolName:@""];
    
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
    sortSelectionLabel.text = @"Listings near Current Location";
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

- (BOOL) hasSentHelpForm
{
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  if ([defaults objectForKey:OMBUserDefaultsSentFormHelp]) {
    NSNumber *value = [defaults objectForKey:OMBUserDefaultsSentFormHelp];
    return [value boolValue];
  }
  
  return NO;
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
  
  NSString *userSchool = [OMBUser currentUser].school;
  
  if([userSchool length]) // avoid none "" in schools
  {
    // Search for neightborhood if there is one that is equal to user's school
    for (NSString *cityName in [[OMBNeighborhoodStore sharedStore] cities]) {
      for (OMBNeighborhood *neighborhood in
           [[OMBNeighborhoodStore sharedStore] sortedNeighborhoodsForCity:
            cityName]) {
             
        // Compare name places
        if([[neighborhood.name lowercaseString] isEqualToString:
            [userSchool lowercaseString]]){
          
          [self manageEmptyWithSchoolName:neighborhood.name];
          centerCoordinate = neighborhood.coordinate;
          sortSelectionLabel.text = [NSString
            stringWithFormat:@"Listings near %@",neighborhood.name];
          [self reloadRegion];
          return;
        }
      }
    }
    
    // Search for schools
    for(OMBSchool *school in [[OMBSchoolStore sharedStore] schools]){
      
      if([school.realName isEqualToString:userSchool]){
  
        if ([school.realName isEqualToString:@"Other"]) {
          [self goToCurrentLocation];
          return;
        }
        
        [self manageEmptyWithSchoolName:school.displayName];
        centerCoordinate = school.coordinate;
        sortSelectionLabel.text = [NSString
          stringWithFormat:@"Listings near %@",school.displayName];
        [self reloadRegion];
        return;
      }
    }
  }
  
}

- (void) reloadRegion
{
  if ([self isOnList]) {
    [self resetAndFetchResidencesForList];
  }
  else {
    [self setMapViewRegion: centerCoordinate
      withMiles: DEFAULT_MILE_RADIUS animated: NO];
    [self resetListViewResidences];
  }
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

- (void) setDefaultCenterCoordinate
{
  sortSelectionLabel.text = @"Listings in San Diego";
  centerCoordinate = CLLocationCoordinate2DMake(32.78166389765503,
    -117.16957478041991);
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

- (BOOL) shouldShowHelpView
{
  return showHelpView && ![self hasSentHelpForm];
}
                               
- (void) showHelp
{
  [self.navigationController pushViewController:
    [[OMBNeedHelpViewController alloc] init] animated:YES];
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
  if ([[_mapView selectedAnnotations] count] && 
    [[OMBUser currentUser] loggedIn]) {
    for (id<MKAnnotation> annotation in [_mapView selectedAnnotations]) {
      if ([annotation isKindOfClass:[QVClusterAnnotation class]]) {
        recentResidence = annotation;
      }
    }
  }
  [self.navigationController pushViewController:
    [[OMBResidenceDetailViewController alloc] initWithResidence:
      propertyInfoView.residence] animated: YES];
}

- (void) showResidentListAnnotation
{
  CGRect screen = [UIScreen mainScreen].bounds;
  CGRect frame = _residentListMap.frame;
  CGFloat originY = screen.size.height * 0.5f;
  CGFloat height = screen.size.height * 0.5f;

  if ([residentAnnotations count] < 3){
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

- (void)startSpinning
{
  if (timerCounter >= MINIMUM_SPINNER_COUNTER) {
    isSpinning = YES;
    [activityViewFullScreen startSpinning];
  }
}

- (void)stopSpinning
{
  isSpinning = NO;
  [activityViewFullScreen stopSpinning];
  timerCounter = 0;
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
          // [UIView animateWithDuration: 0.5f animations: ^{
          //   filterView.transform = CGAffineTransformIdentity;
          // }];
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
        // [UIView animateWithDuration: 0.5f animations: ^{
        //   filterView.transform = CGAffineTransformMakeTranslation(
        //     0.0f, self.view.bounds.size.height - 20.0f - 64.0f);
        // }];
      }
      break;
    }
    default:
      break;
  }
}

- (void)timerFired:(NSTimer *)aTimer
{
  timerCounter += 1;
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

- (void)updateRecentResidence
{
  if (recentResidence) {
    QVClusterAnnotationView *annotationView =
      (QVClusterAnnotationView *)[_mapView viewForAnnotation:recentResidence];
    annotationView.visited = YES;
  }
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

- (void)updateMapViewAnnotationsWithAnnotations:(NSArray *)annotations
{
  // The annotations in the snapshot are exactly the mapView's
  // current annotations. We call this the before set
  // The snapshot of the map immediately after the region changes
  // is exactly what we get back from this method; the after set.

  // We want to keep all the annotations which both sets have in common
  // (set intersection). Get rid of the ones which are not in the
  // after set and add the ones which are left.

  NSMutableSet *before = [NSMutableSet setWithArray:self.mapView.annotations];
  NSSet *after         = [NSSet setWithArray:annotations];

  // Annotations circled in blue shared by both sets
  NSMutableSet *toKeep = [NSMutableSet setWithSet:before];
  [toKeep intersectSet:after];

  // Annotations circled in green
  NSMutableSet *toAdd = [NSMutableSet setWithSet:after];
  [toAdd minusSet:toKeep];

  // Annotations circled in red; to be removed
  NSMutableSet *toRemove = [NSMutableSet setWithSet:before];
  [toRemove minusSet:after];

  // These two methods must be called on the main thread
  __weak OMBMapViewController *weakSelf = self;
  [[NSOperationQueue mainQueue] addOperationWithBlock:^{
    [weakSelf determineShouldShowEmptyOverlayView:
      [toAdd count] + [toKeep count]];
    [weakSelf.mapView addAnnotations:[toAdd allObjects]];
    [weakSelf.mapView removeAnnotations:[toRemove allObjects]];
  }];
}

#pragma mark - Private Methods

- (void)determineShouldSearch
{
  NSDictionary *dictionary = (NSDictionary *)
    [self appDelegate].container.mapFilterViewController.valuesDictionary;

  BOOL shouldSearch = 
    [self appDelegate].container.mapFilterViewController.shouldSearch;
  showHelpView = !shouldSearch;

  // If there is a chosen OMBNeighborhood in the filter, then try to re-fetch
  id dictionaryObject = [dictionary objectForKey:@"neighborhood"];
  if (dictionaryObject != [NSNull null] && 
    [dictionaryObject isKindOfClass:[OMBNeighborhood class]]) {

    OMBNeighborhood *neighborhood = (OMBNeighborhood *)dictionaryObject;
    // If the curent center coordinate is not equal to the
    // neighborhood's and it should search
    if (!CLCOORDINATES_EQUAL2(centerCoordinate, neighborhood.coordinate) &&
      shouldSearch) {
      // Go to current location
      if ([[neighborhood.name lowercaseString] isEqualToString:
        @"my current location"]) {
        [self goToCurrentLocation];
      }
      else {
        [self manageEmptyWithSchoolName:neighborhood.name];
        centerCoordinate = neighborhood.coordinate;
        sortSelectionLabel.text = 
          [NSString stringWithFormat:@"Listings near %@", neighborhood.name];
        // If it is on the list, then re-fetch residences on the list
        if ([self isOnList]) {
          [self resetAndFetchResidencesForList];
        }
        else {
          // Move the map so it re-fetches residences for the map
          [self setMapViewRegion:centerCoordinate withMiles:DEFAULT_MILE_RADIUS
            animated:NO];
          [self resetListViewResidences];
        }
      }
    }
    // If there are filter values, apply and search
    else if (shouldSearch) {
      if ([self isOnList]) {
        [self resetAndFetchResidencesForList];
        firstLoad = YES;
      }
      else {
        [self setMapViewRegion:centerCoordinate withMiles:DEFAULT_MILE_RADIUS
          animated:NO];
        [self resetListViewResidences];
      }
    }
  }
  // If the view controller should search, then set it back to no
  // so it doesn't always keep changing the center location
  if (shouldSearch) {
    [self appDelegate].container.mapFilterViewController.shouldSearch = NO;
  }
}

- (void)determineShouldShowEmptyOverlayView:(CGFloat)totalCount
{
  if (manageEmpty) {
    if (totalCount == 0) {
      NSString *title = @"";
      if (isCurrentLocation) {
        title = @"We're not live in your area.";
        
      }
      else {
        title = [NSString stringWithFormat:@"We're not live at %@", 
          schoolName];
      }
      [emptyOverlayView setTitle:title];
      emptyOverlayView.hidden = NO;
    }
    else {
      emptyOverlayView.hidden = YES;
    }
    manageEmpty = NO;
  }
  else {
    emptyOverlayView.hidden = YES;
  }
}

- (void)manageEmptyWithSchoolName:(NSString *)name
{
  manageEmpty       = YES;
  isCurrentLocation = !name.length;
  schoolName        = name;
}

- (void)resetMap
{
  if (centerCoordinate.latitude == 0.0f && centerCoordinate.longitude == 0.0f) {
    [self setDefaultCenterCoordinate];
    [self setMapViewRegion:centerCoordinate withMiles:DEFAULT_MILE_RADIUS 
      animated:YES];
  }
}

#pragma mark - Setup

- (void)setupInfiniteScrolling
{
  __weak OMBMapViewController *weakSelf = self;
  [self.listView addInfiniteScrollingWithActionHandler:^{
    [weakSelf reloadWithPagination];
  }];
}

#pragma mark - Views

- (void)configureActivityIndicatorViewForListViewContainer:(CGFloat)screenHeight
screenWidth:(CGFloat)screenWidth padding:(CGFloat)padding
{
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
}

- (void)configureEmptyBackground:(CGFloat)screenHeight 
screenWidth:(CGFloat)screenWidth padding:(CGFloat)padding
{
  CGFloat emptyBackgroundHeight = screenHeight - sortView.frame.size.height;
  CGRect emptyBackgroundRect = CGRectMake(0.0f,
    screenHeight - emptyBackgroundHeight,
      screenWidth, emptyBackgroundHeight);
  emptyBackground = [[OMBEmptyBackgroundWithImageAndLabel alloc] initWithFrame:
    emptyBackgroundRect];
  emptyBackground.alpha = 0;
  emptyBackground.imageView.image = [UIImage imageNamed: @"search.png"];
  NSString *text = @"Sorry but we found no results near you. Please choose "
    @"another location or change filters.";
  [emptyBackground setLabelText: text];
  [_listViewContainer addSubview: emptyBackground];
}

- (void)configureEmptyResultsOverlayView
{
  emptyOverlayView        = [[OMBEmptyResultsOverlayView alloc] init];
  emptyOverlayView.hidden = YES;
  [self.mapView addSubview:emptyOverlayView];
}

- (void)configureListContainer:(CGFloat)screenHeight 
screenWidth:(CGFloat)screenWidth padding:(CGFloat)padding
{
  // List view container
  self.listViewContainer       = [[UIView alloc] init];
  self.listViewContainer.frame = [self screen];
  [self.view addSubview:self.listViewContainer];

  navigationBarCover               = [[AMBlurView alloc] init];
  navigationBarCover.alpha         = 0;
  navigationBarCover.blurTintColor = [UIColor whiteColor];
  navigationBarCover.frame = CGRectMake(0.0f, -padding,
    screenWidth, padding + OMBStandardHeight);
  [self.view addSubview:navigationBarCover];
}

- (void)configureListView
{
  // List view
  self.listView                         = [[UITableView alloc] init];
  self.listView.backgroundColor         = [UIColor grayUltraLight];
  self.listView.canCancelContentTouches = YES;
  self.listView.dataSource              = self;
  self.listView.delegate                = self;
  self.listView.frame                   = [self screen];
  self.listView.separatorColor          = nil;
  self.listView.separatorStyle          = UITableViewCellSeparatorStyleNone;
  self.listView.tableHeaderView         = [[UIView alloc] initWithFrame:
    CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.listView.frame),
      CGRectGetHeight(sortLabel.frame))];
  [self.listViewContainer insertSubview:self.listView atIndex:0];
}

- (void)configureMapView:(CGFloat)screenHeight 
screenWidth:(CGFloat)screenWidth padding:(CGFloat)padding
{
  self.mapView                       = [[MKMapView alloc] init];
  self.mapView.alpha                 = 0.0f;
  self.mapView.frame                 = [self screen];
  self.mapView.mapType               = MKMapTypeStandard;
  self.mapView.showsPointsOfInterest = NO;
  self.mapView.showsUserLocation     = NO;
  [self.view addSubview:self.mapView];
  UITapGestureRecognizer *mapViewTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
      action:@selector(mapViewTapped)];
  mapViewTap.delegate = self;
  [self.mapView addGestureRecognizer:mapViewTap];

  self.coordinateQuadTree = [[QVCoordinateQuadTree alloc] init];
  self.coordinateQuadTree.mapView = self.mapView;
  [self.coordinateQuadTree buildTreeWithResidences:
    [[OMBResidenceMapStore sharedStore] residences]];

  // Filter
  // View
  filterView = [[UIView alloc] init];
  filterView.backgroundColor = [UIColor colorWithWhite: 1.0f alpha: 0.8f];
  filterView.frame = CGRectMake(0.0f, screenHeight - padding, 
    screenWidth, padding);
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

  // Resident list on MapView(when cluster <= 5)
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
}

- (void)configureNavigationItem
{
  // Left bar button item
  [self setMenuBarButtonItem];
  // Right bar button item
  self.navigationItem.rightBarButtonItem =
    [[UIBarButtonItem alloc] initWithImage:
      [UIImage imageNamed:@"map_search_icon"] style:UIBarButtonItemStylePlain 
        target:self action:@selector(showSearch)];

  // Title view
  segmentedControl = [[UISegmentedControl alloc] initWithItems:
    @[@"Map", @"List"]];
  CGRect segmentedFrame                 = segmentedControl.frame;
  segmentedFrame.size.width             = CGRectGetWidth(self.view.frame) * 0.4;
  segmentedControl.frame                = segmentedFrame;
  segmentedControl.selectedSegmentIndex = 1;
  [segmentedControl addTarget:self action:@selector(switchViews:)
    forControlEvents:UIControlEventValueChanged];
  self.navigationItem.titleView = segmentedControl;
}

- (void)configureSortView:(CGFloat)screenHeight screenWidth:(CGFloat)screenWidth
padding:(CGFloat)padding
{
  // Sort
  sortView = [[AMBlurView alloc] init];
  sortView.blurTintColor = [UIColor grayVeryLight];
  sortView.frame = CGRectMake(0.0f, 44.0f,
    self.listViewContainer.frame.size.width, 20.0f + 37.0f);
  [self.listViewContainer addSubview: sortView];

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
  sortButtonsView = [[UIView alloc] init]; 
}

- (void)configureViews
{
  CGRect screen        = [self screen];
  self.view            = [[UIView alloc] initWithFrame:screen];
  CGFloat screenHeight = CGRectGetHeight(screen);
  CGFloat screenWidth  = CGRectGetWidth(screen);
  CGFloat padding      = OMBPadding;
  
  [self configureNavigationItem];
  [self configureListContainer:screenHeight screenWidth:screenWidth 
    padding:padding];
  [self configureSortView:screenHeight screenWidth:screenWidth padding:padding];
  [self configureListView];
  [self configureMapView:screenHeight screenWidth:screenWidth padding:padding];
  [self configureActivityIndicatorViewForListViewContainer:screenHeight 
    screenWidth:screenWidth padding:padding];
  [self configureEmptyBackground:screenHeight screenWidth:screenWidth 
    padding:padding];
  [self configureEmptyResultsOverlayView];
}

#pragma mark - Protocol

#pragma mark - Protocol CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager
didFailWithError:(NSError *)error
{
  NSLog(@"Location manager did fail with error: %@",
    error.localizedDescription);
}

- (void)locationManager:(CLLocationManager *)manager
didUpdateLocations:(NSArray *)locations
{
  [self foundLocations:locations];
}

#pragma mark - Protocol MKMapViewDelegate

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
  for (UIView *view in views) {
    [self addBounceAnimationToView:view];
  }
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
  NSUInteger currentZoomLevel = 
    [self zoomLevelForMapRect:mapView.visibleMapRect 
      withMapViewSizeInPixels:mapView.bounds.size];

  NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:@{
    @"bounds": [mapController boundsString:mapView]
  }];

  if ([self mapFilterParameters] != nil) {
    if (![previousMapFilterParameters isEqual:[self mapFilterParameters]]) {
      [mapView removeAnnotations:mapView.annotations];
      previousMapFilterParameters = 
        [NSDictionary dictionaryWithDictionary:[self mapFilterParameters]];
    }
    [params addEntriesFromDictionary:[self mapFilterParameters]];
  }

  if (!isFetchingResidencesForMap) {
    isFetchingResidencesForMap = YES;
    [[OMBResidenceMapStore sharedStore] fetchResidencesWithParameters:params
      delegate:self];
  }
  [self deselectAnnotations];
  [self hidePropertyInfoView];
  [self hideResidentListAnnotation];

  if (![self isOnList]) {
    // If the center coordinate changed
    if (!CLCOORDINATES_EQUAL2(mapView.centerCoordinate, centerCoordinate)) {
      [self resetListViewResidences];
    }
  }
  previousZoomLevel = currentZoomLevel;
}

- (void)mapView:(MKMapView *)map
didDeselectAnnotationView:(MKAnnotationView *)annotationView
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

- (void)mapView:(MKMapView *)map
didSelectAnnotationView:(MKAnnotationView *)annotationView
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

- (MKAnnotationView *)mapView:(MKMapView *)mapView
viewForAnnotation:(id <MKAnnotation>)annotation
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

  annotationView.count    = [(QVClusterAnnotation *) annotation count];
  annotationView.isRented = ((QVClusterAnnotation *) annotation).rented;
  
  int residenceId = ((QVClusterAnnotation *) annotation).residenceId;
  annotationView.visited = NO;
  if(residenceId && [[OMBUser currentUser] loggedIn]){
    // Check if user has visited residence in residence detail controller
    annotationView.visited = [[OMBUser currentUser] visited:residenceId];
  }
  
  return annotationView;
}

@end
