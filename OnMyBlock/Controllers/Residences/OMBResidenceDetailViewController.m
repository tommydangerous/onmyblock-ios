//
//  OMBResidenceDetailViewController.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 10/21/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "OMBResidenceDetailViewController.h"

#import "OMBAnnotation.h"
#import "OMBAnnotationView.h"
#import "OMBBlurView.h"
#import "OMBCenteredImageView.h"
#import "OMBCloseButtonView.h"
#import "OMBCollectionView.h"
#import "OMBExtendedHitAreaViewContainer.h"
#import "OMBFavoriteResidence.h"
#import "OMBFavoriteResidenceConnection.h"
#import "OMBGradientView.h"
#import "OMBImageScrollView.h"
#import "OMBLoginViewController.h"
#import "OMBMapViewViewController.h"
#import "OMBMessageDetailViewController.h"
#import "OMBMessageNewViewController.h"
#import "OMBNavigationController.h"
#import "OMBResidence.h"
#import "OMBResidenceBookItViewController.h"
#import "OMBResidenceCell.h"
#import "OMBResidenceDetailActivityCell.h"
#import "OMBResidenceDetailAddressCell.h"
#import "OMBResidenceDetailAmenitiesCell.h"
#import "OMBResidenceDetailImageCollectionViewCell.h"
#import "OMBResidenceDetailDescriptionCell.h"
#import "OMBResidenceDetailMapCell.h"
#import "OMBResidenceDetailSellerCell.h"
#import "OMBResidenceImage.h"
#import "OMBResidenceBookItConfirmDetailsViewController.h"
#import "OMBResidenceImageSlideViewController.h"
#import "OMBTemporaryResidence.h"
#import "OMBViewControllerContainer.h"
#import "UIColor+Extensions.h"
#import "UIFont+OnMyBlock.h"
#import "UIImage+Color.h"
#import "UIImage+Resize.h"

float kResidenceDetailCellSpacingHeight = 40.0f;
float kResidenceDetailImagePercentage   = 0.5f;

@implementation OMBResidenceDetailViewController

#pragma mark - Initializer

- (id) initWithResidence: (OMBResidence *) object
{
  if (!(self = [super init])) return nil;

  residence = object;

  _imageSlideViewController = 
    [[OMBResidenceImageSlideViewController alloc] initWithResidence: residence];
  _imageSlideViewController.modalTransitionStyle = 
    UIModalTransitionStyleCrossDissolve;
  _imageSlideViewController.residenceDetailViewController = self;

  self.screenName = [NSString stringWithFormat:
    @"Residence Detail View Controller - Residence ID: %i", residence.uid];

  if ([residence.title length])
    self.title = residence.title;
  else
    self.title = [residence.address capitalizedString];

  [[NSNotificationCenter defaultCenter] addObserver: self
    selector: @selector(currentUserLogout) name: OMBUserLoggedOutNotification 
      object: nil];

  return self;
}

#pragma mark - Override

#pragma mark - NSObject

- (void) dealloc
{
  // Must dealloc or notifications get sent to zombies
  [[NSNotificationCenter defaultCenter] removeObserver: self];
}

#pragma mark - Override UIViewController

- (void) loadView
{
  [super loadView];

  self.navigationItem.rightBarButtonItem =
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:
      UIBarButtonSystemItemAction target: self
        action: @selector(shareButtonSelected)];

  CGRect screen = [[UIScreen mainScreen] bounds];
  self.view     = [[OMBBlurView alloc] initWithFrame: screen];

  CGFloat padding      = 20.0f;
  CGFloat headerViewPadding = padding * 0.5f;
  CGFloat screenHeight = screen.size.height;
  CGFloat screenWidth  = screen.size.width;
  CGFloat standardHeight = 44.0f; // Height of navigation bar
  backViewOffsetY = padding + standardHeight;

  // Images collection view
  // Layout
  CGSize imageCollectionSize = CGSizeMake(screenWidth,
    screenHeight * kResidenceDetailImagePercentage);
  UICollectionViewFlowLayout *imageCollectionViewLayout =
    [UICollectionViewFlowLayout new];
  imageCollectionViewLayout.itemSize = imageCollectionSize;
  imageCollectionViewLayout.headerReferenceSize = CGSizeZero;
  imageCollectionViewLayout.minimumInteritemSpacing = 0.0f;
  imageCollectionViewLayout.minimumLineSpacing = 0.0f;
  imageCollectionViewLayout.scrollDirection = 
    UICollectionViewScrollDirectionHorizontal;
  imageCollectionViewLayout.sectionInset = UIEdgeInsetsMake(0.0f, 0.0f,
    0.0f, 0.0f);
  // Collection view
  imageCollectionView = [[OMBCollectionView alloc] initWithFrame:
    CGRectMake(0.0f, backViewOffsetY,
      imageCollectionSize.width, imageCollectionSize.height) 
        collectionViewLayout: imageCollectionViewLayout];
  imageCollectionView.alwaysBounceHorizontal = YES;
  imageCollectionView.bounces       = YES;
  imageCollectionView.dataSource    = self;
  imageCollectionView.delegate      = self;
  imageCollectionView.pagingEnabled = YES;
  [self.view addSubview: imageCollectionView];
  // Tap gesture when user clicks the images
  UITapGestureRecognizer *tapGesture = 
    [[UITapGestureRecognizer alloc] initWithTarget: self 
      action: @selector(showImageSlides)];
  [imageCollectionView addGestureRecognizer: tapGesture];

  // The table to hold most of the data
  _table = [[UITableView alloc] initWithFrame: screen
    style: UITableViewStylePlain];
  _table.alwaysBounceVertical    = YES;
  _table.backgroundColor         = [UIColor clearColor];
  _table.canCancelContentTouches = YES;
  _table.dataSource              = self;
  _table.delegate                = self;
  _table.separatorColor          = [UIColor clearColor];
  _table.separatorInset = UIEdgeInsetsMake(0.0f, padding, 0.0f, 0.0f);
  _table.separatorStyle               = UITableViewCellSeparatorStyleNone;
  _table.showsVerticalScrollIndicator = NO;
  // Table header view
  _table.tableHeaderView = [[UIView alloc] initWithFrame: 
    CGRectMake(0.0f, 0.0f, screenWidth, 
      imageCollectionView.frame.origin.y + 
      imageCollectionView.frame.size.height)];
  [self.view addSubview: _table];

  // Gradient; this goes behind the table, but in front of the image
  // collection view
  gradientView = [[OMBGradientView alloc] init];
  gradientView.colors = @[
    [UIColor colorWithRed: 0.0f green: 0.0f blue: 0.0f alpha: 0.0f],
    [UIColor colorWithRed: 0.0f green: 0.0f blue: 0.0f alpha: 0.3f]
  ];
  gradientView.frame = imageCollectionView.frame;
  [self.view insertSubview: gradientView belowSubview: _table];

  // This goes in front of the table
  headerView = [[OMBExtendedHitAreaViewContainer alloc] init];
  headerView.frame = gradientView.frame;
  headerView.scrollView = imageCollectionView;
  [self.view addSubview: headerView];

  // Activity indicator view
  activityIndicatorView = 
    [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: 
      UIActivityIndicatorViewStyleWhiteLarge];
  activityIndicatorView.color = [UIColor whiteColor];
  CGRect activityFrame = activityIndicatorView.frame;
  activityFrame.origin.x = (imageCollectionView.frame.size.width - 
    activityFrame.size.width) * 0.5f;
  activityFrame.origin.y = (imageCollectionView.frame.size.height - 
    activityFrame.size.height) * 0.5f;
  activityIndicatorView.frame = activityFrame;
  activityIndicatorView.layer.zPosition = 9999;
  [headerView addSubview: activityIndicatorView];

  // Page of images
  _pageOfImagesLabel = [[UILabel alloc] init];
  _pageOfImagesLabel.backgroundColor = [UIColor colorWithWhite: 0.0f 
    alpha: 0.5f];
  _pageOfImagesLabel.font = [UIFont smallTextFont];
  _pageOfImagesLabel.frame = CGRectMake(
    imageCollectionView.frame.size.width - (50 + headerViewPadding), 
      headerViewPadding, 50.0f, 30.0f);
  _pageOfImagesLabel.layer.cornerRadius = 2.0f;
  _pageOfImagesLabel.textAlignment = NSTextAlignmentCenter;
  _pageOfImagesLabel.textColor = [UIColor whiteColor];
  [headerView addSubview: _pageOfImagesLabel];

  // Favorites Button
  _favoritesButton = [[UIButton alloc] init];
  _favoritesButton.frame = CGRectMake(5.0f, 5.0f, 40.0f, 40.0f);
  [_favoritesButton addTarget: self action: @selector(favoritesButtonSelected)
    forControlEvents: UIControlEventTouchUpInside];
  [headerView addSubview: _favoritesButton];
  // When favorited
  favoritedImage = [UIImage image: 
    [UIImage imageNamed: @"favorite_filled_white.png"] 
      size: _favoritesButton.frame.size];
  // When not favorited
  notFavoritedImage = [UIImage image: 
    [UIImage imageNamed: @"favorite_outline_white.png"] 
      size: _favoritesButton.frame.size];

  // Number of offers
  // _numberOfOffersLabel = [[UILabel alloc] init];
  // _numberOfOffersLabel.font = fontMedium18;
  // _numberOfOffersLabel.text = @"5 offers";
  // _numberOfOffersLabel.textAlignment = NSTextAlignmentRight;
  // _numberOfOffersLabel.textColor = [UIColor whiteColor];
  // [_imagesView addSubview: _numberOfOffersLabel];

  // Current offer
  currentOfferOriginY = (imageCollectionView.frame.origin.y + 
    imageCollectionView.frame.size.height) - (36.0f + (headerViewPadding * 2));
  _currentOfferLabel = [UILabel new];
  _currentOfferLabel.font = [UIFont fontWithName: @"HelveticaNeue-Medium"
    size: 27];
  _currentOfferLabel.frame = CGRectMake(headerViewPadding, currentOfferOriginY,
      screenWidth - (headerViewPadding * 2), 36.0f);
  _currentOfferLabel.textAlignment = NSTextAlignmentRight;
  _currentOfferLabel.textColor = [UIColor whiteColor];;
  [self.view insertSubview: _currentOfferLabel belowSubview: _table];

  // Bottom view
  _bottomButtonView = [[UIView alloc] init];
  _bottomButtonView.backgroundColor = [UIColor colorWithWhite: 1.0f
    alpha: 0.8f];
  // 27 = count down timer label height
  // 58 = contact me / book it button height
  float bottomButtonViewHeight = 23.0f + 44.0f + 1.0f;
  bottomButtonViewHeight = 44.0f;
  _bottomButtonView.frame = CGRectMake(0.0f, 
    screenHeight - bottomButtonViewHeight, screenWidth, bottomButtonViewHeight);
  [self.view addSubview: _bottomButtonView];

  // Count down timer
  _countDownTimerLabel = [[UILabel alloc] init];
  _countDownTimerLabel.backgroundColor = [UIColor greenAlpha: 0.8f];
  _countDownTimerLabel.font = [UIFont fontWithName: @"HelveticaNeue-Medium"
    size: 15];
  _countDownTimerLabel.frame = CGRectMake(0.0f, 0.0f, 
    _bottomButtonView.frame.size.width, 23.0f);
  _countDownTimerLabel.textColor = [UIColor whiteColor];
  _countDownTimerLabel.textAlignment = NSTextAlignmentCenter;
  // [_bottomButtonView addSubview: _countDownTimerLabel];

  // Contact me button
  _contactMeButton = [[UIButton alloc] init];
  _contactMeButton.backgroundColor = [UIColor blueAlpha: 0.8f];
  // _contactMeButton.frame = CGRectMake(0.0f, 
  //   _countDownTimerLabel.frame.origin.y + 
  //   _countDownTimerLabel.frame.size.height + 1.0f, 
  //     (_bottomButtonView.frame.size.width - 1.0f) * 0.5, 44.0f);
  _contactMeButton.frame = CGRectMake(0.0f, 0.0f, 
    (_bottomButtonView.frame.size.width - 1.0f) * 0.5, 44.0f);
  // _contactMeButton.frame = CGRectMake(0.0f, 0.0f, 
  //   _bottomButtonView.frame.size.width, 44.0f);
  _contactMeButton.titleLabel.font = [UIFont fontWithName: 
    @"HelveticaNeue-Light" size: 18];
  [_contactMeButton addTarget: self action: @selector(contactMeButtonSelected)
    forControlEvents: UIControlEventTouchUpInside];
  [_contactMeButton setBackgroundImage: 
    [UIImage imageWithColor: [UIColor blueHighlighted]]
      forState: UIControlStateHighlighted];
  [_contactMeButton setTitle: @"Contact Me" forState: UIControlStateNormal];
  [_contactMeButton setTitleColor: [UIColor whiteColor]
    forState: UIControlStateNormal];
  [_bottomButtonView addSubview: _contactMeButton];

  // Book it button
  _bookItButton = [[UIButton alloc] init];
  _bookItButton.backgroundColor = _contactMeButton.backgroundColor;
  _bookItButton.frame = CGRectMake(
    _bottomButtonView.frame.size.width - _contactMeButton.frame.size.width, 
      _contactMeButton.frame.origin.y, _contactMeButton.frame.size.width, 
        _contactMeButton.frame.size.height);
  _bookItButton.titleLabel.font = _contactMeButton.titleLabel.font;
  [_bookItButton addTarget: self action: @selector(showPlaceOffer)
    forControlEvents: UIControlEventTouchUpInside];
  [_bookItButton setTitle: @"Place Offer" // @"Book It!" 
    forState: UIControlStateNormal];
  [_bookItButton setTitleColor: [UIColor whiteColor]
    forState: UIControlStateNormal];
  [_bottomButtonView addSubview: _bookItButton];

  // The scroll view when users view images full screen
  imageScrollView = [UIScrollView new];
  imageScrollView.bounces = NO;
  imageScrollView.delegate = self;
  imageScrollView.frame = screen;
  imageScrollView.pagingEnabled = YES;
  imageScrollView.showsHorizontalScrollIndicator = NO;

  // Close button for image scroll view
  CGFloat closeButtonPadding = padding * 0.5f;
  CGFloat closeButtonViewHeight = 26.0f;
  CGFloat closeButtonViewWidth  = closeButtonViewHeight;
  CGRect closeButtonRect = CGRectMake(imageScrollView.frame.size.width - 
    (closeButtonViewWidth + closeButtonPadding), 
      padding + closeButtonPadding, closeButtonViewWidth, 
        closeButtonViewHeight);
  imageScrollViewCloseButton = [[OMBCloseButtonView alloc] initWithFrame:
    closeButtonRect color: [UIColor whiteColor]];
  [imageScrollViewCloseButton.closeButton addTarget: self 
    action: @selector(closeImageSlides)
      forControlEvents: UIControlEventTouchUpInside];
  [imageScrollView addSubview: imageScrollViewCloseButton];

  blurView = [[OMBBlurView alloc] initWithFrame: screen];
  blurView.blurRadius = 20.0f;
  blurView.tintColor = [UIColor colorWithWhite: 0.0f alpha: 0.5f];

  // Map
  map = [[MKMapView alloc] init];
  map.delegate = self;
  map.frame = [OMBResidenceDetailMapCell frameForMapView];
  map.hidden = NO;
  map.rotateEnabled = NO;
  map.scrollEnabled = NO;
  map.showsPointsOfInterest = NO;
  map.zoomEnabled = NO;
  UITapGestureRecognizer *tap = 
    [[UITapGestureRecognizer alloc] initWithTarget: self 
      action: @selector(showMap)];
  [map addGestureRecognizer: tap];
}

- (void) viewDidDisappear: (BOOL) animated
{
  [super viewDidDisappear: animated];
  // Need to do this or an error occurs
  _table.delegate = nil;
}

- (void) viewDidLoad
{
  [super viewDidLoad];

  // Do this or else there will be extra spacing at the
  // top of the image collection view
  self.automaticallyAdjustsScrollViewInsets = NO;

  // Register collection view cell for the collection view
  [imageCollectionView registerClass: 
    [OMBResidenceDetailImageCollectionViewCell class] 
      forCellWithReuseIdentifier:
        [OMBResidenceDetailImageCollectionViewCell reuseIdentifierString]];
}

- (void) viewWillAppear: (BOOL) animated
{
  [super viewWillAppear: animated];

  // Need to set this again because when the view disappears, 
  // the _table.delegate is set to nil
  if (!_table.delegate)
    _table.delegate = self;

  // Fetch residence detail data
  [residence fetchDetailsWithCompletion: ^(NSError *error) {
    [self refreshResidenceData];
  }];

  // Download images
  [residence downloadImagesWithCompletion: ^(NSError *error) {
    [self reloadImageData];
    // [activityIndicatorView stopAnimating];
  }];
  // [activityIndicatorView startAnimating];
  [self reloadImageData];

  // Set the rent
  _currentOfferLabel.text = [residence rentToCurrencyString];

  // Adjust the favorites button if user already favorited
  [self adjustFavoriteButton];

  // If temporary residence, make the favorite button hidden
  if ([residence isKindOfClass: [OMBTemporaryResidence class]]) {
    _favoritesButton.hidden = YES;
    [self.navigationItem setRightBarButtonItem: nil animated: NO];
  }

  // Table footer view
  CGFloat footerHeight = _bottomButtonView.frame.size.height;
  // If this residence belongs to the current user
  if ([[OMBUser currentUser] loggedIn] && 
    residence.user.uid == [OMBUser currentUser].uid) {
    // Hide the table footer view and buttons at the bottom
    footerHeight = 0.0f;
    _bottomButtonView.hidden = YES;
  }
  _table.tableFooterView = [[UIView alloc] initWithFrame: 
    CGRectMake(0.0f, 0.0f, _table.frame.size.width, footerHeight)];

  // Fetch the offers (Do this in another phase, we aren't showing offers)
  // [residence fetchOffersWithCompletion: nil];

  // Map
  if ([[map annotations] count] == 0) {
    CGFloat distanceInMiles = 1609 * 0.5; // 1609 meters = 1 mile
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(
      residence.latitude, residence.longitude);
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(
      coordinate, distanceInMiles, distanceInMiles);
    [map setRegion: region animated: NO];
    // Add annotation
    OMBAnnotation *annotation = [[OMBAnnotation alloc] init];
    annotation.coordinate     = coordinate;
    [map addAnnotation: annotation];
  }
}

- (void) viewWillDisappear: (BOOL) animated
{
  [super viewWillDisappear: animated];

  // _table.delegate = nil;
  [countdownTimer invalidate];
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

#pragma mark - Protocol UICollectionViewDataSource

- (UICollectionViewCell *) collectionView: (UICollectionView *) collectionView 
cellForItemAtIndexPath: (NSIndexPath *) indexPath
{
  OMBResidenceDetailImageCollectionViewCell *cell =
    [collectionView dequeueReusableCellWithReuseIdentifier:
      [OMBResidenceDetailImageCollectionViewCell reuseIdentifierString]
        forIndexPath: indexPath];
  [cell loadResidenceImage: 
    [[residence imagesArray] objectAtIndex: indexPath.row]];
  return cell;
}

- (NSInteger) collectionView: (UICollectionView *) collectionView 
numberOfItemsInSection: (NSInteger) section
{
  return [[residence imagesArray] count];
}

- (NSInteger) numberOfSectionsInCollectionView: 
(UICollectionView *) collectionView
{
  return 1;
}

#pragma mark - Protocol UICollectionViewDelegate

- (void) collectionView: (UICollectionView *) collectionView 
didSelectItemAtIndexPath: (NSIndexPath *) indexPath
{
  NSLog(@"COLLECTION VIEW DID SELECT ITEM");
}

#pragma mark - Protocol UIScrollViewDelegate

- (void) scrollViewDidEndDecelerating: (UIScrollView *) scrollView
{
  if (scrollView == imageScrollView) {
    NSInteger page = scrollView.contentOffset.x / scrollView.frame.size.width;
    imageCollectionView.contentOffset = CGPointMake(
      imageCollectionView.frame.size.width * page, 0.0f); 
  }
}

- (void) scrollViewDidScroll: (UIScrollView *) scrollView
{
  CGFloat x = scrollView.contentOffset.x;
  CGFloat y = scrollView.contentOffset.y;
  CGFloat padding = 20.0f;
  // If the table is scrolling
  if (scrollView == _table) {
    CGFloat adjustment = y / 3.0f;

    // Adjust the image collection view
    CGRect backRect = imageCollectionView.frame;
    backRect.origin.y = backViewOffsetY - adjustment;
    imageCollectionView.frame = backRect;

    // Adjust the gradient
    gradientView.frame = backRect;

    // Header view
    headerView.frame = backRect;

    // Adjust the current offer label
    CGRect currentOfferRect = _currentOfferLabel.frame;
    currentOfferRect.origin.y = currentOfferOriginY - adjustment;
    _currentOfferLabel.frame = currentOfferRect;
  }
  // When changing the image in the image collection view
  else if (scrollView == imageCollectionView) {
    if ([self currentPageOfImages]) {
      _pageOfImagesLabel.text = [NSString stringWithFormat: @"%i/%i",
        [self currentPageOfImages], (int) [[residence imagesArray] count]];
    }
  }
  // If the image scroll view is scrolling, move the close button
  else if (scrollView == imageScrollView) {
    CGRect rect = imageScrollViewCloseButton.frame;
    rect.origin.x = 
      (scrollView.frame.size.width - (rect.size.width + (padding * 0.5f))) + x;
    imageScrollViewCloseButton.frame = rect;
  }
}

- (void) scrollViewDidZoom: (UIScrollView *) scrollView
{
  if ([scrollView isKindOfClass: [OMBImageScrollView class]]) {
    NSUInteger index = [scrollView.subviews indexOfObjectPassingTest:
      ^(id obj, NSUInteger idx, BOOL *stop) {
        return [obj isKindOfClass: [UIImageView class]];
      }
    ];
    if (index != NSNotFound) {
      UIImageView *imageView = [scrollView.subviews objectAtIndex: index];
      // Center the image as it becomes smaller than the size of the screen
      CGSize boundsSize    = scrollView.bounds.size;
      CGRect frameToCenter = imageView.frame;
      // Center horizontally
      if (frameToCenter.size.width < boundsSize.width) {
        frameToCenter.origin.x = 
          (boundsSize.width - frameToCenter.size.width) / 2.0;
      }
      else
        frameToCenter.origin.x = 0;
      // Center vertically
      if (frameToCenter.size.height < boundsSize.height)
        frameToCenter.origin.y = 
          (boundsSize.height - frameToCenter.size.height) / 2.0;
      else
        frameToCenter.origin.y = 0;
      imageView.frame = frameToCenter;
    }
  }
}

- (UIView *) viewForZoomingInScrollView: (UIScrollView *) scrollView
{
  if ([scrollView isKindOfClass: [OMBImageScrollView class]]) {
    NSUInteger index = [scrollView.subviews indexOfObjectPassingTest:
      ^(id obj, NSUInteger idx, BOOL *stop) {
        return [obj isKindOfClass: [UIImageView class]];
      }
    ];
    if (index != NSNotFound)
      return [scrollView.subviews objectAtIndex: index]; 
  }
  return nil;
}

#pragma mark - Protocol UITableViewDataSource

- (NSInteger) numberOfSectionsInTableView: (UITableView *) tableView
{
  return 6;
}

- (UITableViewCell *) tableView: (UITableView *) tableView 
cellForRowAtIndexPath: (NSIndexPath *) indexPath
{
  static NSString *CellIdentifier = @"CellIdentifier";
  UITableViewCell *emptyCell = [tableView dequeueReusableCellWithIdentifier:
    CellIdentifier];
  if (!emptyCell)
    emptyCell = [[UITableViewCell alloc] initWithStyle:
      UITableViewCellStyleValue1 reuseIdentifier: CellIdentifier];
  emptyCell.backgroundColor = [UIColor grayUltraLight];
  emptyCell.selectionStyle = UITableViewCellSelectionStyleNone;
  CALayer *topBorder = [CALayer layer];
  topBorder.backgroundColor = [UIColor grayLight].CGColor;
  topBorder.frame = CGRectMake(0.0f, 0.0f, tableView.frame.size.width, 0.5f);
  [emptyCell.contentView.layer addSublayer: topBorder];

  // Address, bed, bath, lease month, property type, date available
  if (indexPath.section == 0) {
    if (indexPath.row == 0) {
      static NSString *AddressCellIdentifier = @"AddressCellIdentifier";
      OMBResidenceDetailAddressCell *cell =
        [tableView dequeueReusableCellWithIdentifier: AddressCellIdentifier];
      if (!cell)
        cell = [[OMBResidenceDetailAddressCell alloc] initWithStyle: 
          UITableViewCellStyleDefault reuseIdentifier: AddressCellIdentifier];
      // Address
      if ([residence.address length])
        cell.addressLabel.text = [residence.address capitalizedString];
      else
        cell.addressLabel.text = [NSString stringWithFormat: @"%@, %@",
          [residence.city capitalizedString], residence.state];
      // Bed / Bath/ Lease Months
      cell.bedBathLeaseMonthLabel.text = [NSString stringWithFormat:
        @"%.0f bd  /  %.0f ba  /  %i mo lease", 
          residence.bedrooms, residence.bathrooms, residence.leaseMonths];
      // Property Type - Move in Date
      NSString *propertyType = @"Property type";
      if ([[residence.propertyType stripWhiteSpace] length])
        propertyType = [residence.propertyType capitalizedString];
      NSString *availableDateString = @"immediately";
      if (residence.moveInDate) {
        if (residence.moveInDate > [[NSDate date] timeIntervalSince1970]) {
          NSDateFormatter *dateFormatter = [NSDateFormatter new];
          dateFormatter.dateFormat = @"MMM d, yy";
          availableDateString = [NSString stringWithFormat: @"%@",
            [dateFormatter stringFromDate: 
              [NSDate dateWithTimeIntervalSince1970: residence.moveInDate]]];
        }
      }
      cell.propertyTypeLabel.text = [NSString stringWithFormat: 
        @"%@ - available %@", propertyType, availableDateString];
      return cell;
    }
  }

  // Activity
  else if (indexPath.section == 1) {
    if (indexPath.row == 0) {
      static NSString *ActivityCellIdentifier = @"ActivityCellIdentifier";
      UITableViewCell *cell =
        [tableView dequeueReusableCellWithIdentifier: ActivityCellIdentifier];
      if (!cell)
        cell = [[UITableViewCell alloc] initWithStyle:
          UITableViewCellStyleValue1 reuseIdentifier: ActivityCellIdentifier];
      cell.accessoryType  = UITableViewCellAccessoryDisclosureIndicator;
      cell.detailTextLabel.text = @"5";
      cell.detailTextLabel.textColor = [UIColor blue];
      cell.textLabel.font = [UIFont fontWithName: @"HelveticaNeue-Light"
        size: 15];
      cell.textLabel.text = @"Offer Activity";
      cell.textLabel.textColor = [UIColor textColor];
      CALayer *topBorder1 = [CALayer layer];
      topBorder1.backgroundColor = topBorder.backgroundColor;
      topBorder1.frame = topBorder.frame;
      [cell.contentView.layer addSublayer: topBorder1];
      return cell;
    }
  }

  // Amenities
  else if (indexPath.section == 2) {
    if (indexPath.row == 1) {
      static NSString *AmentiesCellIdentifier = @"AmentiesCellIdentifier";
      OMBResidenceDetailAmenitiesCell *cell = 
        [tableView dequeueReusableCellWithIdentifier: AmentiesCellIdentifier];
      if (!cell) {
        cell = [[OMBResidenceDetailAmenitiesCell alloc] initWithStyle:
          UITableViewCellStyleDefault reuseIdentifier: AmentiesCellIdentifier];
        [cell loadAmenitiesData: [residence availableAmenities]];
      }
      return cell;
    }
  }

  // Description
  else if (indexPath.section == 3) {
    if (indexPath.row == 1) {
      static NSString *DescriptionCellIdentifier = @"DescriptionCellIdentifier";
      OMBResidenceDetailDescriptionCell *cell = 
        [tableView dequeueReusableCellWithIdentifier: 
          DescriptionCellIdentifier];
      if (!cell) {
        cell = [[OMBResidenceDetailDescriptionCell alloc] initWithStyle:
          UITableViewCellStyleDefault reuseIdentifier: 
            DescriptionCellIdentifier];
        [cell loadData: residence.description];
      }
      return cell;
    }
  }

  // Seller
  else if (indexPath.section == 4) {
    if (indexPath.row == 1) {
      static NSString *SellerCellIdentifier = @"SellerCellIdentifier";
      OMBResidenceDetailSellerCell *cell = 
        [tableView dequeueReusableCellWithIdentifier: SellerCellIdentifier];
      if (!cell)
        cell = [[OMBResidenceDetailSellerCell alloc] initWithStyle:
          UITableViewCellStyleDefault reuseIdentifier: SellerCellIdentifier];
      OMBUser *user = residence.user;
      if (!user || [user.firstName length] == 0)
        user = [OMBUser landlordUser];
      [cell loadUserData: user];
      return cell;
    }
  }

  // Map
  else if (indexPath.section == 5) {
    if (indexPath.row == 1) {
      static NSString *MapCellIdentifier = @"MapCellIdentifier";
      OMBResidenceDetailMapCell *cell = 
        [tableView dequeueReusableCellWithIdentifier: MapCellIdentifier];
      if (!cell) {
        cell = [[OMBResidenceDetailMapCell alloc] initWithStyle:
          UITableViewCellStyleDefault reuseIdentifier: MapCellIdentifier];

        // cell.mapView.delegate = self;
        // // Set the region of the mini map
        // CGFloat distanceInMiles = 1609 * 0.5; // 1609 meters = 1 mile
        // CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(
        //   residence.latitude, residence.longitude);
        // MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(
        //   coordinate, distanceInMiles, distanceInMiles);
        // [cell.mapView setRegion: region animated: NO];
        // // Add annotation
        // OMBAnnotation *annotation = [[OMBAnnotation alloc] init];
        // annotation.coordinate     = coordinate;
        // [cell.mapView addAnnotation: annotation];
        [map removeFromSuperview];
        [cell.contentView addSubview: map];
        
        // Add street view
        if(!cell.streetView.image){
          NSLog(@"download street view");
          
          cell.imageView.image = nil;
          dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
          dispatch_async(queue, ^{
            NSData *data = [NSData dataWithContentsOfURL:[residence googleStaticStreetViewImageURL]];
            UIImage *image = [UIImage imageWithData:data];
            dispatch_async(dispatch_get_main_queue(), ^{
              cell.streetView.image = image;
            });
          });
        }
        // Tap
        // UITapGestureRecognizer *tap = 
        //   [[UITapGestureRecognizer alloc] initWithTarget: self 
        //     action: @selector(showMap)];
        // [cell.mapView addGestureRecognizer: tap];
        
        [cell.segmentedControl addTarget:self action:@selector(changeStateSegmented:) forControlEvents:UIControlEventValueChanged];
      }
      if ([residence.city length] && [residence.state length])
        cell.titleLabel.text = [NSString stringWithFormat: @"%@, %@",
          [[residence.city capitalizedString] stripWhiteSpace], 
            [residence.state stripWhiteSpace]];
      return cell;
    }
  }

  return emptyCell;
}

- (NSInteger) tableView: (UITableView *) tableView
numberOfRowsInSection: (NSInteger) section
{
  // Address
  if (section == 0) {
    return 1;
  }

  // Activity
  else if (section == 1) {
    return 1;
  }

  // Amenities
  else if (section == 2) {
    if ([[residence availableAmenities] count])
      return 2; // 2 is for the spacing above
  }

  // Description
  else if (section == 3) {
    if ([[residence.description stripWhiteSpace] length])
      return 2;
  }

  // Seller
  else if (section == 4) {
    return 2;
  }

  // Map
  else if (section == 5) {
    return 2;
  }

  return 0;
}

#pragma mark - Protocol UITableViewDelegate

- (void) tableView: (UITableView *) tableView
didSelectRowAtIndexPath: (NSIndexPath *) indexPath
{
  [tableView deselectRowAtIndexPath: indexPath animated: YES];
}

- (CGFloat) tableView: (UITableView *) tableView
heightForRowAtIndexPath: (NSIndexPath *) indexPath
{
  CGFloat padding = 20.0f;

  // Address
  if (indexPath.section == 0) {
    // Address
    if (indexPath.row == 0) {
      return [OMBResidenceDetailAddressCell heightForCell];
    }
  }

  // Offer activity
  else if (indexPath.section == 1) {
    if (indexPath.row == 0) {
      return 0.0f;
      return kResidenceDetailCellSpacingHeight;
    }
  }

  // Amenities
  else if (indexPath.section == 2) {
    if (indexPath.row == 0) {
      return kResidenceDetailCellSpacingHeight;
    }
    else if (indexPath.row == 1) {
      NSInteger count = [[residence availableAmenities] count];
      NSInteger rows  = count * 0.5f;
      if (count % 2) {
        rows += 1;
      }
      return kResidenceDetailCellSpacingHeight + 
        padding + (23.0f * rows) + padding;
    }
  }

  // Description
  else if (indexPath.section == 3) {
    if (indexPath.row == 0) {
      return kResidenceDetailCellSpacingHeight;
    }
    else if (indexPath.row == 1) {
      NSAttributedString *aString = 
        [residence.description attributedStringWithFont: 
          [UIFont fontWithName: @"HelveticaNeue-Light" size: 15] 
            lineHeight: 23.0f];
      CGRect rect = [aString boundingRectWithSize:
        CGSizeMake(tableView.frame.size.width - (padding * 2), 9999.0f)
          options: NSStringDrawingUsesLineFragmentOrigin context: nil];
      return kResidenceDetailCellSpacingHeight +
        padding + rect.size.height + padding;
    }
  }

  // Seller
  else if (indexPath.section == 4) {
    if (indexPath.row == 0) {
      return kResidenceDetailCellSpacingHeight;
    }
    else if (indexPath.row == 1) {
      return [OMBResidenceDetailSellerCell heightForCell];
    }
  }

  // Map
  else if (indexPath.section == 5) {
    if (indexPath.row == 0) {
      return kResidenceDetailCellSpacingHeight;
    }
    else if (indexPath.row == 1) {
      return [OMBResidenceDetailMapCell heightForCell];
    }
  }

  return 0;
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) adjustFavoriteButton
{
  UIImage *image = notFavoritedImage;
  // If logged in
  if ([[OMBUser currentUser] loggedIn]) {
    // If already favorited
    if ([[OMBUser currentUser] alreadyFavoritedResidence: residence])
      image = favoritedImage;
  }
  [_favoritesButton setImage: image forState: UIControlStateNormal];
}

- (void) adjustPageOfImagesLabelFrame
{
  CGRect pageRect = [_pageOfImagesLabel.text boundingRectWithSize:
    CGSizeMake(9999.0f, _pageOfImagesLabel.frame.size.height)
      options: NSStringDrawingUsesLineFragmentOrigin
        attributes: @{ NSFontAttributeName: _pageOfImagesLabel.font }
          context: nil];
  // Padding on each side
  CGFloat pageWidth = (_pageOfImagesLabel.frame.origin.y * 2.0f) +
    pageRect.size.width;
  _pageOfImagesLabel.frame = CGRectMake(imageCollectionView.frame.size.width - 
    (pageWidth + _pageOfImagesLabel.frame.origin.y), 
      _pageOfImagesLabel.frame.origin.y, pageWidth,
        _pageOfImagesLabel.frame.size.height);
}

- (void)changeStateSegmented:(UISegmentedControl *) control{
  
  OMBResidenceDetailMapCell *cell = (OMBResidenceDetailMapCell *)
  [self.table cellForRowAtIndexPath: [NSIndexPath indexPathForRow:1 inSection:5]];
  
  switch (control.selectedSegmentIndex) {
      // Show map
    case 0: {
      // cell.mapView.hidden = NO;
      map.hidden = NO;
      cell.streetView.hidden = YES;
      
      break;
    }
      // Show street
    case 1: {
      // cell.mapView.hidden = YES;
      map.hidden = YES;
      cell.streetView.hidden = NO;
      break;
    }
    default:
      break;
  }
  
}

- (void) closeImageSlides
{
  [UIView animateWithDuration: 0.25f animations: ^{
    blurView.alpha = 0.0f;
    imageScrollView.alpha = 0.0f;
    imageScrollView.transform = CGAffineTransformScale(
      CGAffineTransformIdentity, 0.0f, 0.0f);
  } completion: ^(BOOL finished) {
    imageScrollView.transform = CGAffineTransformIdentity;
    // Remove from superview
    [blurView removeFromSuperview];
    [imageScrollView removeFromSuperview];
    // Remove all subviews
    [imageScrollView.subviews enumerateObjectsUsingBlock: 
      ^(UIView *v, NSUInteger idx, BOOL *stop) {
        // Don't remove the X close button
        if (![v isKindOfClass: [OMBCloseButtonView class]])
          [v removeFromSuperview];
      }
    ];
  }];
}

- (void) contactMeButtonSelected
{
  if ([[OMBUser currentUser] loggedIn]) {
    // messageDetailViewController = 
    //   [[OMBMessageDetailViewController alloc] initWithUser: residence.user];
    // [self.navigationController pushViewController: 
    //   messageDetailViewController
    //     animated: YES];
    OMBUser *user = residence.user;
    if (!user || [user.firstName length] == 0)
      user = [OMBUser landlordUser];
    [[self appDelegate].container presentViewController: 
      [[OMBNavigationController alloc] initWithRootViewController: 
        [[OMBMessageNewViewController alloc] initWithUser: user]]
          animated: YES completion: nil];
  }
  else {
    [[self appDelegate].container showSignUp];
  }
}

- (int) currentPageOfImages
{
  return (1 + 
    imageCollectionView.contentOffset.x / imageCollectionView.frame.size.width);
}

- (void) currentUserLogout
{
  NSLog(@"Residence Detail Current User Logout");
}

- (void) favoritesButtonSelected
{
  if ([[OMBUser currentUser] loggedIn]) {
    if ([[OMBUser currentUser] alreadyFavoritedResidence: residence]) {
      [[OMBUser currentUser] removeResidenceFromFavorite: residence];
      [UIView animateWithDuration: 0.5f animations: ^{
        [_favoritesButton setImage: notFavoritedImage
          forState: UIControlStateNormal];
      }];
    }
    else {
      OMBFavoriteResidence *favoriteResidence = 
        [[OMBFavoriteResidence alloc] init];
      favoriteResidence.createdAt = [[NSDate date] timeIntervalSince1970];
      favoriteResidence.residence = residence;
      favoriteResidence.user      = [OMBUser currentUser];
      [[OMBUser currentUser] addFavoriteResidence: favoriteResidence];
      UIImageView *imageView = _favoritesButton.imageView;
      [UIView animateWithDuration: 0.5f delay:0
        options: UIViewAnimationOptionBeginFromCurrentState
          animations: ^{
            imageView.transform = CGAffineTransformMakeScale(0.8f, 0.8f);
            [_favoritesButton setImage: favoritedImage
              forState: UIControlStateNormal];
          }
          completion: ^(BOOL finished){
            imageView.transform = CGAffineTransformIdentity;
          }
        ];
    }
    OMBFavoriteResidenceConnection *connection = 
      [[OMBFavoriteResidenceConnection alloc] initWithResidence: residence];
    [connection start];
  }
  else {
    OMBAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate showSignUp];
  }
}

- (void) reloadImageData
{
  [imageCollectionView reloadData];

  // Set the pages text 1/2
  _pageOfImagesLabel.text = [NSString stringWithFormat: @"%i/%i",
    [self currentPageOfImages], (int) [[residence imagesArray] count]];

  [self adjustPageOfImagesLabelFrame];
}

- (void) refreshResidenceData
{
  [self.table reloadData];

  if (residence.user) {
    // Download the seller's image if it doesn't exist
    if (!residence.user.image)
      [residence.user downloadImageFromImageURLWithCompletion: nil];
  }

  // [self timerFireMethod: nil];
  // countdownTimer = [NSTimer timerWithTimeInterval: 1 target: self
  //   selector: @selector(timerFireMethod:) userInfo: nil repeats: YES];
  // // NSRunLoopCommonModes, mode used for tracking events
  // [[NSRunLoop currentRunLoop] addTimer: countdownTimer
  //   forMode: NSRunLoopCommonModes];
}

- (void) shareButtonSelected
{
  NSArray *dataToShare = @[[residence shareString]];
  UIActivityViewController *activityViewController = 
    [[UIActivityViewController alloc] initWithActivityItems: dataToShare
      applicationActivities: nil];
  [[self appDelegate].container.currentDetailViewController 
    presentViewController: activityViewController 
      animated: YES completion: nil];
}

- (void) showBookItNow
{
  if ([[OMBUser currentUser] loggedIn])
    [self.navigationController pushViewController: 
      [[OMBResidenceBookItViewController alloc] initWithResidence: residence] 
        animated: YES];
  else
    [[self appDelegate].container showSignUp];
}

- (void) showImageSlides
{
  CGRect rect = imageScrollView.frame;

  NSArray *array = [residence imagesArray];
  for (OMBResidenceImage *residenceImage in array) {
    OMBImageScrollView *scroll = [[OMBImageScrollView alloc] init];
    scroll.backgroundColor     = [UIColor clearColor];
    scroll.delegate            = self;
    scroll.frame = CGRectMake(
      [array indexOfObject: residenceImage] * rect.size.width, 0.0f,
        rect.size.width, rect.size.height);
    [imageScrollView insertSubview: scroll belowSubview: 
      imageScrollViewCloseButton];

    UIImage *image         = residenceImage.image;
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    imageView.image = image;
    [scroll addSubview: imageView];

    scroll.minimumZoomScale = rect.size.width / image.size.width;
    scroll.maximumZoomScale = 1.0;
    scroll.showsHorizontalScrollIndicator = NO;
    scroll.showsVerticalScrollIndicator   = NO;
    scroll.zoomScale = scroll.minimumZoomScale;
  }
  // Set content size
  imageScrollView.contentSize = CGSizeMake(rect.size.width * [array count],
    rect.size.height);

  // Adjust the content offset depending on the residence detail current page
  CGPoint point = CGPointMake(
    rect.size.width * ([self currentPageOfImages] - 1), 0.0f);
  [imageScrollView setContentOffset: point animated: NO];


  // Blur
  blurView.alpha = 0.0f;
  [blurView refreshWithView: self.view];
  [[[UIApplication sharedApplication] keyWindow] addSubview: blurView];

  imageScrollView.alpha = 0.0f;
  imageScrollView.transform = CGAffineTransformScale(CGAffineTransformIdentity,
    0.0f, 0.0f);
  // Add the image scroll view
  [[[UIApplication sharedApplication] keyWindow] addSubview: 
    imageScrollView];

  [UIView animateWithDuration: 0.25f animations: ^{
    blurView.alpha = 1.0f;
    imageScrollView.alpha = 1.0f;
    imageScrollView.transform = CGAffineTransformIdentity;
  }];
}

- (void) showMap
{
  CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(
    residence.latitude, residence.longitude);
  [self.navigationController pushViewController:
    [[OMBMapViewViewController alloc] initWithCoordinate: coordinate 
      title: [residence.address capitalizedString]] animated: YES];
}

- (void) showPlaceOffer
{
  if ([[OMBUser currentUser] loggedIn])
    [self.navigationController pushViewController:
      [[OMBResidenceBookItConfirmDetailsViewController alloc] initWithResidence:
        residence] animated: YES];
  else
    [[self appDelegate].container showSignUp];
}

- (void) timerFireMethod: (NSTimer *) timer
{
  // Countdown timer
  NSInteger secondsRemaining = 0;
  if ([[NSDate date] timeIntervalSince1970] < residence.auctionStartDate) {
    secondsRemaining = residence.auctionStartDate - 
      [[NSDate date] timeIntervalSince1970];
  }
  else {
    secondsRemaining = (residence.auctionStartDate + 
      (residence.auctionDuration * 24 * 60 * 60)) -
        [[NSDate date] timeIntervalSince1970];
  }
  NSInteger days = secondsRemaining / (60 * 60 * 24);
  secondsRemaining -= days * 60 * 60 * 24;
  NSString *daysString = [NSString stringWithFormat: @"%i", days];
  if (days < 10)
    daysString = [@"0" stringByAppendingString: daysString];
  NSInteger hours = secondsRemaining / (60 * 60);
  secondsRemaining -= hours * 60 * 60;
  NSString *hoursString = [NSString stringWithFormat: @"%i", hours];
  if (hours < 10)
    hoursString = [@"0" stringByAppendingString: hoursString];
  NSInteger minutes = secondsRemaining / 60;
  secondsRemaining -= minutes * 60;
  NSString *minutesString = [NSString stringWithFormat: @"%i", minutes];
  if (minutes < 10)
    minutesString = [@"0" stringByAppendingString: minutesString];
  NSInteger seconds = secondsRemaining;
  NSString *secondsString = [NSString stringWithFormat: @"%i", seconds];
  if (seconds < 10)
    secondsString = [@"0" stringByAppendingString: secondsString];

  NSString *timeString = [NSString stringWithFormat: @"%@:%@:%@:%@",
    daysString, hoursString, minutesString, secondsString];

  // Auction hasn't started yet
  if ([[NSDate date] timeIntervalSince1970] < residence.auctionStartDate) {
    _countDownTimerLabel.text = [NSString stringWithFormat: 
      @"Auction starts in: %@", timeString];
  }
  // Ongoing
  else
    _countDownTimerLabel.text = [NSString stringWithFormat: 
      @"Time left in auction: %@", timeString];
}

@end
