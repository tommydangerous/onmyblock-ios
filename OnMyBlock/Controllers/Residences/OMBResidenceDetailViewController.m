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
#import "OMBApplyResidenceViewController.h"
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
#import "OMBUserDetailViewController.h"
#import "OMBOffer.h"
#import "OMBRenterApplication.h"
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
#import "OMBResidenceImagesConnection.h"
#import "OMBResidenceBookItConfirmDetailsViewController.h"
#import "OMBResidenceImageSlideViewController.h"
#import "OMBResidenceTitleView.h"
#import "OMBTemporaryResidence.h"
#import "OMBViewControllerContainer.h"
#import "UIColor+Extensions.h"
#import "UIFont+OnMyBlock.h"
#import "UIImage+Color.h"
#import "UIImage+Resize.h"
#import "UIImageView+WebCache.h"

float kResidenceDetailCellSpacingHeight = 40.0f;
float kResidenceDetailImagePercentage   = 0.5f;

@interface OMBResidenceDetailViewController ()
{
  OMBBlurView *backgroundBlurView;
  CGFloat backgroundImageViewHeight;
  CGFloat favoritesButtonOriginY;
  UIScrollView *hiddenScrollView;
  UICollectionViewFlowLayout *imageCollectionViewLayout;
  UIPanGestureRecognizer *imagePanGestureRecognizer;
  UITapGestureRecognizer *imageTapGestureRecognizer;
  CGFloat previousOriginX;
  CGFloat previousOriginY;
}

@end

@implementation OMBResidenceDetailViewController

#pragma mark - Initializer

- (id) initWithResidence: (OMBResidence *) object
{
  if (!(self = [super init])) return nil;

  residence = object;
  previousOriginX = previousOriginY = 0.0f;

  // Title
  if ([residence.address length]) {
    self.navigationItem.titleView = 
      [[OMBResidenceTitleView alloc] initWithResidence: residence];
  }
  else {
    self.title = residence.title;
  }

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

  self.navigationItem.rightBarButtonItem = shareBarButtonItem;

  CGRect screen = [[UIScreen mainScreen] bounds];
  self.view     = [[OMBBlurView alloc] initWithFrame: screen];
  self.view.backgroundColor = [UIColor whiteColor];

  CGFloat padding      = 20.0f;
  CGFloat headerViewPadding = padding * 0.5f;
  CGFloat screenHeight = screen.size.height;
  CGFloat screenWidth  = screen.size.width;
  CGFloat standardHeight = 44.0f; // Height of navigation bar
  backViewOffsetY = padding + standardHeight;

  // Images collection view
  backgroundImageViewHeight = screenHeight * kResidenceDetailImagePercentage;
  // Layout
  CGSize imageCollectionSize = CGSizeMake(screenWidth,
    backgroundImageViewHeight);
  imageCollectionViewLayout =
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
  imageCollectionView.showsHorizontalScrollIndicator = NO;
  [self.view addSubview: imageCollectionView];
  // Tap gesture when user clicks the images
  imageTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:
    self action: @selector(showImageSlides)];
  [imageCollectionView addGestureRecognizer: imageTapGestureRecognizer];
  // When a user pans left and right to scroll the image collection view
  // imagePanGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:
  //   self action: @selector(drag:)];
  // imagePanGestureRecognizer.cancelsTouchesInView = YES;
  // imagePanGestureRecognizer.delegate = self;
  // imagePanGestureRecognizer.maximumNumberOfTouches = 1;
  // [imageCollectionView addGestureRecognizer: imagePanGestureRecognizer];

  // Show when there aren't images
  placeholderImageView = [[UIImageView alloc] initWithFrame:
    imageCollectionView.frame];
  placeholderImageView.hidden = NO;
  placeholderImageView.image = [OMBResidence placeholderImage];
  [self.view addSubview: placeholderImageView];

  // The table to hold most of the data
  self.table = [[UITableView alloc] initWithFrame: screen
    style: UITableViewStylePlain];
  self.table.alwaysBounceVertical    = YES;
  self.table.backgroundColor         = [UIColor clearColor];
  self.table.canCancelContentTouches = YES;
  self.table.dataSource              = self;
  self.table.delegate                = self;
  self.table.separatorColor          = [UIColor clearColor];
  self.table.separatorInset = UIEdgeInsetsMake(0.0f, padding, 0.0f, 0.0f);
  self.table.separatorStyle               = UITableViewCellSeparatorStyleNone;
  self.table.showsVerticalScrollIndicator = NO;
  [self.view addSubview: self.table];
  // Table header view
  UIView *tableHeaderView = [UIView new];
  tableHeaderView.frame = CGRectMake(0.0f, 0.0f, screenWidth,
    imageCollectionView.frame.origin.y + imageCollectionView.frame.size.height);
  self.table.tableHeaderView = tableHeaderView;

  hiddenScrollView = [[UIScrollView alloc] init];
  hiddenScrollView.frame = CGRectMake(0.0f, 0.0f,
    self.table.frame.size.width, self.table.frame.size.height);
  hiddenScrollView.delegate = self;
  hiddenScrollView.hidden = YES;
  // hiddenScrollView.pagingEnabled = YES;
  [self.view addSubview: hiddenScrollView];
  [imageCollectionView addGestureRecognizer:
    hiddenScrollView.panGestureRecognizer];
  // imageCollectionView.panGestureRecognizer.enabled = NO;

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
  // headerView = [UIView new];
  headerView.frame = gradientView.frame;
  headerView.scrollView = imageCollectionView;
  // [self.view insertSubview: headerView belowSubview: self.table];
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
  _pageOfImagesLabel.clipsToBounds = YES;
  _pageOfImagesLabel.font = [UIFont smallTextFont];
  _pageOfImagesLabel.frame = CGRectMake(
    imageCollectionView.frame.size.width - (50 + headerViewPadding),
      headerViewPadding, 50.0f, 30.0f);
  _pageOfImagesLabel.layer.cornerRadius = OMBCornerRadius;
  _pageOfImagesLabel.textAlignment = NSTextAlignmentCenter;
  _pageOfImagesLabel.textColor = [UIColor whiteColor];
  [headerView addSubview: _pageOfImagesLabel];

  // Favorites Button
  favoritesButtonOriginY = 5.0f + OMBPadding + OMBStandardHeight;
  self.favoritesButton = [[UIButton alloc] init];
  self.favoritesButton.frame = CGRectMake(5.0f,
    favoritesButtonOriginY, 40.0f, 40.0f);
  [self.favoritesButton addTarget: self
    action: @selector(favoritesButtonSelected)
      forControlEvents: UIControlEventTouchUpInside];
  [self.view addSubview: self.favoritesButton];
  // When favorited
  favoritedImage = [UIImage image:
    [UIImage imageNamed: @"favorite_filled_white.png"]
      size: self.favoritesButton.bounds.size];
  // When not favorited
  notFavoritedImage = [UIImage image:
    [UIImage imageNamed: @"favorite_outline_white.png"]
      size: self.favoritesButton.bounds.size];

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
  // bottomButtonViewHeight = 44.0f;
  bottomButtonViewHeight = OMBStandardButtonHeight;
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
    (_bottomButtonView.frame.size.width - 1.0f) * 0.5,
      bottomButtonViewHeight);
  // _contactMeButton.frame = CGRectMake(0.0f, 0.0f,
  //   _bottomButtonView.frame.size.width, 44.0f);
  _contactMeButton.titleLabel.font = [UIFont mediumTextFontBold];
  // _contactMeButton.titleLabel.font = [UIFont mediumTextFontBold];
  [_contactMeButton addTarget: self action: @selector(contactMeButtonSelected)
    forControlEvents: UIControlEventTouchUpInside];
  [_contactMeButton setBackgroundImage:
    [UIImage imageWithColor: [UIColor blueHighlighted]]
      forState: UIControlStateHighlighted];
  [_contactMeButton setTitle: @"Contact"
    forState: UIControlStateNormal];
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
  [_bookItButton setBackgroundImage:
    [UIImage imageWithColor: [UIColor blueHighlighted]]
      forState: UIControlStateHighlighted];
  [_bookItButton setTitleColor: [UIColor whiteColor]
    forState: UIControlStateNormal];
  [_bottomButtonView addSubview: _bookItButton];

  // The scroll view when users view images full screen
  imageScrollView = [UIScrollView new];
  imageScrollView.bounces = YES;
  imageScrollView.delegate = self;
  imageScrollView.frame = screen;
  imageScrollView.pagingEnabled = YES;
  imageScrollView.showsHorizontalScrollIndicator = NO;

  // Close button for image scroll view
  CGFloat closeButtonPadding = padding * 0.5f;
  CGFloat closeButtonViewHeight = 30.0f;
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

  backgroundBlurView = [[OMBBlurView alloc] initWithFrame: screen];
  backgroundBlurView.blurRadius = 20.0f;
  backgroundBlurView.clipsToBounds = YES;
  backgroundBlurView.tintColor = [UIColor colorWithWhite: 1.0f alpha: 0.8f];
  [self.view insertSubview: backgroundBlurView atIndex: 0];
}

- (void) viewDidDisappear: (BOOL) animated
{
  [super viewDidDisappear: animated];
  // Need to do this or an error occurs
  // _table.delegate = nil;
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
  // if (!_table.delegate)
  //   _table.delegate = self;

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

  CGFloat footerHeight = _bottomButtonView.frame.size.height;
  // If temporary residence, make the favorite button hidden
  if ([residence isKindOfClass: [OMBTemporaryResidence class]]) {
    _favoritesButton.hidden = YES;
    [self.navigationItem setRightBarButtonItem: nil animated: NO];
    // Hide the bottom bar
    footerHeight = 0.0f;
    self.bottomButtonView.hidden = YES;
  }

  // Table footer view
  // If this residence belongs to the current user
  if ([[OMBUser currentUser] loggedIn] &&
    residence.landlordUserID == [OMBUser currentUser].uid) {
    // Hide the table footer view and buttons at the bottom
    footerHeight = 0.0f;
    self.bottomButtonView.hidden = YES;
  }
  // Inactive
  else if (residence.inactive) {
    // Hide the table footer view and buttons at the bottom
    footerHeight = 0.0f;
    self.bottomButtonView.hidden = YES;
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

  [self updateBackgroundImage];
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
  // Next cell
  if (indexPath.row < [[residence imagesArray] count] - 1) {
    NSIndexPath *nextIndexPath = [NSIndexPath indexPathForRow: indexPath.row + 1
      inSection: indexPath.section];
    OMBResidenceDetailImageCollectionViewCell *nextCell =
      [collectionView dequeueReusableCellWithReuseIdentifier:
        [OMBResidenceDetailImageCollectionViewCell reuseIdentifierString]
          forIndexPath: nextIndexPath];
    [nextCell loadResidenceImage:
      [[residence imagesArray] objectAtIndex: nextIndexPath.row]];
  }
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

#pragma mark - Protocol UIGestureRecognizerDelegate

- (BOOL) gestureRecognizerShouldBegin: (UIGestureRecognizer *) recognizer
{
  if ([recognizer isKindOfClass: [UIPanGestureRecognizer class]]) {
    if (recognizer == imagePanGestureRecognizer) {
      UIPanGestureRecognizer *panRecognizer =
        (UIPanGestureRecognizer *) recognizer;
      CGPoint velocity = [panRecognizer velocityInView: self.view];
      // Horizontal panning
      // return ABS(velocity.x) > ABS(velocity.y);
      // Vertical panning
      return ABS(velocity.x) < ABS(velocity.y);
    }
  }
  return YES;
}

#pragma mark - Protocol UIScrollViewDelegate

- (void) scrollViewWillBeginDragging: (UIScrollView *) scrollView
{
  if (scrollView == self.table) {
    [self killScrollView: hiddenScrollView];
  }
}

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
  CGFloat padding      = OMBPadding;
  CGFloat scrollFactor = 3.5f;
  CGFloat x            = scrollView.contentOffset.x;
  CGFloat y            = scrollView.contentOffset.y;
  // If the table is scrolling
  if (scrollView == _table) {
    CGFloat adjustment = y / scrollFactor;

    // Adjust the image collection view
    CGRect backRect = imageCollectionView.frame;
    backRect.origin.y = backViewOffsetY - adjustment;
    // Adjust height for scrolling because of transparent cell background
    CGRect backRectWithHeight  = backRect;
    backRectWithHeight.size.height = backgroundImageViewHeight -
      (y - adjustment);
    if (backRectWithHeight.size.height > backgroundImageViewHeight)
      backRectWithHeight.size.height = backgroundImageViewHeight;
    // Image collection view layout
    imageCollectionViewLayout.itemSize = CGSizeMake(
      imageCollectionView.frame.size.width,
        backRectWithHeight.size.height);
    // Image collection view
    imageCollectionView.collectionViewLayout = imageCollectionViewLayout;
    imageCollectionView.frame = backRectWithHeight;

    // Adjust the gradient
    gradientView.frame         = backRectWithHeight;
    // Adjust the placeholder image
    placeholderImageView.frame = backRectWithHeight;

    // Header view
    backRect.size.height = imageCollectionView.frame.size.height -
      (y + adjustment);
    headerView.frame = backRect;

    // Adjust the current offer label
    CGRect currentOfferRect   = _currentOfferLabel.frame;
    currentOfferRect.origin.y = currentOfferOriginY - adjustment;
    _currentOfferLabel.frame  = currentOfferRect;
    _currentOfferLabel.alpha  = 1 -
      ((y * scrollFactor) / self.view.frame.size.height);

    // Adjust the favorites button
    CGRect favoritesRect       = self.favoritesButton.frame;
    favoritesRect.origin.y     = favoritesButtonOriginY - adjustment;
    self.favoritesButton.frame = favoritesRect;

    // If the user is all the way at the bottom, have a background color
    // if (y > backViewOffsetY + imageCollectionView.frame.size.height)
    //   self.table.backgroundColor = [UIColor grayUltraLight];
    // else
    //   self.table.backgroundColor = [UIColor clearColor];

    hiddenScrollView.contentOffset = scrollView.contentOffset;
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
  // Scrolling up and down on the image collection view
  else if (scrollView == hiddenScrollView) {
    self.table.contentOffset = scrollView.contentOffset;
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
  emptyCell.backgroundColor = [UIColor colorWithWhite: 1.0f alpha: 0.3f];
  emptyCell.selectionStyle  = UITableViewCellSelectionStyleNone;
  // Top border
  CALayer *topBorder = [CALayer layer];
  topBorder.backgroundColor = [UIColor grayLight].CGColor;
  topBorder.frame = CGRectMake(0.0f, 0.0f, tableView.frame.size.width, 0.5f);
  [emptyCell.contentView.layer addSublayer: topBorder];

  // Colors for the cell and selected cell
  UIColor *cellBackgroundColor = [UIColor colorWithWhite: 1.0f alpha: 0.5f];

  // Address, bed, bath, lease month, property type, date available
  if (indexPath.section == 0) {
    if (indexPath.row == 0) {
      static NSString *AddressCellIdentifier = @"AddressCellIdentifier";
      OMBResidenceDetailAddressCell *cell =
        [tableView dequeueReusableCellWithIdentifier: AddressCellIdentifier];
      if (!cell) {
        cell = [[OMBResidenceDetailAddressCell alloc] initWithStyle:
          UITableViewCellStyleDefault reuseIdentifier: AddressCellIdentifier];
        cell.backgroundColor = cellBackgroundColor;
      }
      // Main Label
      if ([[residence.title stripWhiteSpace] length])
        cell.mainLabel.text = residence.title;
      else{
        [cell.mainLabel removeFromSuperview];
        [cell resize];
      }
      // Address
      if ([residence.address length])
        cell.addressLabel.text = [residence.address capitalizedString];
      else
        cell.addressLabel.text = [NSString stringWithFormat: @"%@, %@",
          [residence.city capitalizedString], residence.state];
      // Bed / Bath/ Lease Months
      cell.bedBathLeaseMonthLabel.text = [NSString stringWithFormat:
        @"%.0f bd  /  %.0f ba  /  %@",
          residence.bedrooms, residence.bathrooms,
            [residence leaseMonthsStringShort]];
      // Property Type - Move in Date
      NSString *propertyType = @"";
      if ([[residence.propertyType stripWhiteSpace] length])
        propertyType = [residence.propertyType capitalizedString];
      NSString *availableDateString = @"";
      if (residence.moveInDate) {
        if (residence.moveInDate > [[NSDate date] timeIntervalSince1970]) {
          NSDateFormatter *dateFormatter = [NSDateFormatter new];
          dateFormatter.dateFormat = @"MMM d, yyyy";
          availableDateString = [NSString stringWithFormat: @"- available %@",
            [dateFormatter stringFromDate:
              [NSDate dateWithTimeIntervalSince1970: residence.moveInDate]]];
        }
        else {
          availableDateString = @"- available immediately";
        }
      }
      cell.propertyTypeLabel.text = [NSString stringWithFormat:
        @"%@ %@", propertyType, availableDateString];
      return cell;
    }
  }

  // Activity
  else if (indexPath.section == 1) {
    // Offer Activity, not being used
    if (indexPath.row == 999) {
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
        cell.backgroundColor = cellBackgroundColor;
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
        cell.backgroundColor = cellBackgroundColor;
        [cell loadData: residence.description];
      }
      return cell;
    }
  }

  // Seller
  else if (indexPath.section == 4) {
    if (indexPath.row == 1) {
      if (residence.user && residence.user.uid) {
        static NSString *SellerCellIdentifier = @"SellerCellIdentifier";
        OMBResidenceDetailSellerCell *cell =
          [tableView dequeueReusableCellWithIdentifier: SellerCellIdentifier];
        if (!cell) {
          cell = [[OMBResidenceDetailSellerCell alloc] initWithStyle:
            UITableViewCellStyleDefault reuseIdentifier: SellerCellIdentifier];
        }
        cell.backgroundColor = cellBackgroundColor;
        [cell loadResidenceData: residence];
        return cell;
      }
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
        cell.backgroundColor = cellBackgroundColor;
        [map removeFromSuperview];
        [cell.contentView addSubview: map];

        // Add street view
        if (!cell.streetView.image) {
          cell.imageView.image = nil;
          dispatch_queue_t queue = dispatch_get_global_queue(
            DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
          dispatch_async(queue, ^{
            NSData *data = [NSData dataWithContentsOfURL:
              [residence googleStaticStreetViewImageURL]];
            if([data length] > 6000){
              UIImage *image = [UIImage imageWithData:data];
              dispatch_async(dispatch_get_main_queue(), ^{
                [cell.segmentedControl setHidden:NO];
                cell.streetView.image = image;
              });
            }
          });
        }
        [cell.segmentedControl addTarget: self
          action: @selector(changeStateSegmented:)
            forControlEvents: UIControlEventValueChanged];
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
  // Seller
  if (indexPath.section == 4) {
    if (indexPath.row == 1) {
      if (residence.user) {
        OMBUserDetailViewController *vc =
          [[OMBUserDetailViewController alloc] initWithUser:
            residence.user];
        [self.navigationController pushViewController: vc animated: YES];
      }
    }
  }
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
      if([[residence.title stripWhiteSpace] length])
        return [OMBResidenceDetailAddressCell heightForCell];
      else
        return [OMBResidenceDetailAddressCell heightForCell] - 23.0f;
    }
  }

  // Offer activity
  else if (indexPath.section == 1) {
    if (indexPath.row == 0) {
      return 0.0f;
      // return kResidenceDetailCellSpacingHeight;
    }
  }

  // Amenities
  else if (indexPath.section == 2) {
    if (indexPath.row == 0) {
      return kResidenceDetailCellSpacingHeight;
    }
    else if (indexPath.row == 1) {
      if ([[residence availableAmenities] count]) {
        NSInteger count = [[residence availableAmenities] count];
        NSInteger rows  = count * 0.5f;
        if (count % 2) {
          rows += 1;
        }
        return kResidenceDetailCellSpacingHeight +
          padding + (23.0f * rows) + padding;
      }
    }
  }

  // Description
  else if (indexPath.section == 3) {
    if (indexPath.row == 0) {
      return kResidenceDetailCellSpacingHeight;
    }
    else if (indexPath.row == 1) {
      if (residence.description && [residence.description length]) {
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
  }

  // Seller
  else if (indexPath.section == 4) {
    if (indexPath.row == 0) {
      if (residence.user && residence.user.uid) {
        return kResidenceDetailCellSpacingHeight;
      }
    }
    else if (indexPath.row == 1) {
      // Only show this if there is a user for that residence
      if (residence.user && residence.user.uid) {
        return [OMBResidenceDetailSellerCell heightForCell];
      }
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
  [self.table cellForRowAtIndexPath:
    [NSIndexPath indexPathForRow:1 inSection:5]];

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
  [[UIApplication sharedApplication] setStatusBarHidden:NO];
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
    if (residence.user) {
      OMBMessageDetailViewController *vc =
        [[OMBMessageDetailViewController alloc] initWithUser: residence.user];
      [self.navigationController pushViewController: vc animated: YES];
    }
    else {
      OMBMessageDetailViewController *vc =
        [[OMBMessageDetailViewController alloc] initWithResidence: residence];
      [self.navigationController pushViewController: vc animated: YES];
    }
  }
  else {
    [[self appDelegate].container showSignUp];
  }
}

- (void) criteriaApplyNow
{
  // Show the 
  BOOL showApplyNow = YES;
  BOOL hasSentApp = NO;
  
  // If user has sent an application
  if ([[OMBUser currentUser] loggedIn] && residence.sentApplication) {
    hasSentApp   = YES;
    showApplyNow = NO;
  }
  // Is a sublet
  else if ([residence isSublet]) {
    showApplyNow = NO;
  }
  // If rent it now is true
  else if (residence.rentItNow) {
    showApplyNow = NO;
  }
  // If minRent is less than or equal to Offer price threshold
  else if (![residence isAboveThreshold]) {
    showApplyNow = NO;
  }
  
  if (hasSentApp) {
    [_bookItButton setTitle: @"Applied" forState: UIControlStateNormal];
    _bookItButton.enabled = NO;
  } 
  else {
    SEL selector;
    NSString *title;
    
    if (showApplyNow) {
      title = @"Apply Now";
      selector = @selector(showApplyNow);
    } 
    else {
      title = @"Book It";
      selector = @selector(showPlaceOffer);
    }
    [_bookItButton setTitle: title forState: UIControlStateNormal];
    [_bookItButton addTarget: self action: selector
      forControlEvents: UIControlEventTouchUpInside];
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

- (void) drag: (UIPanGestureRecognizer *) gesture
{
  CGPoint translation = [gesture translationInView: self.view];
  CGPoint offset      = self.table.contentOffset;
  // Began
  if (gesture.state == UIGestureRecognizerStateBegan) {
    previousOriginY = offset.y;
  }
  // Changed
  else if (gesture.state == UIGestureRecognizerStateChanged) {
    CGFloat finalOffsetY = previousOriginY - translation.y;
    if (finalOffsetY < 0)
      finalOffsetY = 0;
    offset.y = finalOffsetY;
    self.table.contentOffset = offset;
  }
  // Ended
  else if (gesture.state == UIGestureRecognizerStateEnded) {

  }
  NSLog(@"Translation: %f, %f", translation.x, translation.y);
}

- (void) drag2: (UIPanGestureRecognizer *) gesture
{
  CGPoint translation = [gesture translationInView: self.view];
  CGPoint velocity    = [gesture velocityInView: self.view];
  CGPoint offset      = imageCollectionView.contentOffset;
  CGSize contentSize  = imageCollectionView.contentSize;
  CGFloat width       = imageCollectionView.frame.size.width;
  // Began
  if (gesture.state == UIGestureRecognizerStateBegan) {
    previousOriginX = offset.x;
  }
  // Changed
  else if (gesture.state == UIGestureRecognizerStateChanged) {
    CGFloat finalOffsetX = previousOriginX - translation.x;
    CGFloat resistance;
    if (finalOffsetX < 0) {
      previousOriginX = 0;
      resistance   = ((width - translation.x) / width) * translation.x;
      finalOffsetX = previousOriginX - resistance;
      NSLog(@"%f", resistance);
    }
    else if (finalOffsetX > contentSize.width - width) {
      previousOriginX = contentSize.width - width;
      resistance   = ((width + translation.x) / width) * translation.x;
      finalOffsetX = previousOriginX - resistance;
      NSLog(@"%f, %f", translation.x, resistance);
    }
    offset.x = finalOffsetX;
    imageCollectionView.contentOffset = offset;
  }
  // Ended
  else if (gesture.state == UIGestureRecognizerStateEnded) {
    CGPoint finalOffset = imageCollectionView.contentOffset;
    // Paging
    NSInteger maxPage = (contentSize.width / width) - 1;
    NSInteger minPage = 0;
    CGFloat page      = finalOffset.x / width;

    BOOL velocityThreshold = abs(velocity.x) > 500;
    // Swiping left, increasing page
    if (velocity.x < 0) {
      if (velocityThreshold) {
        page = ceil(page);
      }
      else {
        page = roundf(page);
      }
    }
    else {
      if (velocityThreshold) {
        page = floor(page);
      }
      else {
        page = roundf(page);
      }
    }

    if (page < minPage)
      page = minPage;
    else if (page > maxPage)
      page = maxPage;
    finalOffset.x = width * page;
    // CGFloat duration = OMBStandardDuration;
    // if (velocityThreshold)
    //   duration *= 1 - (abs(velocity.x) / 5000);
    // [UIView animateWithDuration: duration delay: 0.0f
    //   options: UIViewAnimationOptionBeginFromCurrentState animations: ^{
    //     [imageCollectionView setContentOffset: finalOffset animated: NO];
    //   } completion: nil];
    [imageCollectionView setContentOffset: finalOffset animated: YES];
  }
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

- (void) killScrollView: (UIScrollView *) scrollView
{
  CGPoint offset = scrollView.contentOffset;
  offset.x -= 1.0f;
  offset.y -= 1.0f;
  [scrollView setContentOffset: offset animated: NO];
  offset.x += 1.0f;
  offset.y += 1.0f;
  [scrollView setContentOffset: offset animated: NO];
}

- (void) reloadImageData
{
  [imageCollectionView reloadData];

  // Set the pages text 1/2
  _pageOfImagesLabel.text = [NSString stringWithFormat: @"%i/%i",
    [self currentPageOfImages], (int) [[residence imagesArray] count]];
  if([residence imagesArray].count)
    placeholderImageView.hidden = YES;
  else
    placeholderImageView.hidden = NO;

  [self adjustPageOfImagesLabelFrame];
}

- (void) refreshResidenceData
{
  // If there is a user associated with the residence
  if (residence.user) {
    // Download the seller's image if it doesn't exist
    if (!residence.user.image)
      [residence.user downloadImageFromImageURLWithCompletion: nil];
  }

  // Criteria to show "Book It" or "Apply Now"
  [self criteriaApplyNow];

  // Inactive
  if (residence.inactive) {
    // Hide the table footer view and buttons at the bottom
    _bottomButtonView.hidden = YES;
    _table.tableFooterView = [[UIView alloc] initWithFrame: CGRectZero];
  }

  // [self timerFireMethod: nil];
  // countdownTimer = [NSTimer timerWithTimeInterval: 1 target: self
  //   selector: @selector(timerFireMethod:) userInfo: nil repeats: YES];
  // // NSRunLoopCommonModes, mode used for tracking events
  // [[NSRunLoop currentRunLoop] addTimer: countdownTimer
  //   forMode: NSRunLoopCommonModes];

  [self.table reloadData];
  hiddenScrollView.contentSize = self.table.contentSize;
}

- (void) shareButtonSelected
{
  NSArray *dataToShare = @[[residence shareString]];
  UIActivityViewController *activityViewController =
    [[UIActivityViewController alloc] initWithActivityItems: dataToShare
      applicationActivities: nil];
  [activityViewController setValue: @"Check out this listing on OnMyBlock!"
     forKey: @"subject"];
  [[self appDelegate].container.currentDetailViewController
    presentViewController: activityViewController
      animated: YES completion: nil];
}

- (void) showApplyNow
{
  if ([[OMBUser currentUser] loggedIn]) {
    [self.navigationController pushViewController:
      [[OMBApplyResidenceViewController alloc] initWithResidenceUID:
        residence.uid] animated: YES];
  }
  else {
    [[self appDelegate].container showSignUp];
  }
}

- (void) showBookItNow
{
  if ([[OMBUser currentUser] loggedIn]) {
    [self.navigationController pushViewController:
      [[OMBResidenceBookItViewController alloc] initWithResidence: residence]
        animated: YES];
  }
  else {
    [[self appDelegate].container showSignUp];
  }
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

    // UIImage *image         = residenceImage.image;
    // imageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    // imageView.image = image;

    __weak typeof(scroll) weakScroll = scroll;
    [scroll.imageView setImageWithURL: residenceImage.imageURL
      placeholderImage: nil options: SDWebImageRetryFailed
        completed:
          ^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
            if (error) {
              weakScroll.imageView.image = [OMBResidence placeholderImage];
              NSLog(@"Error: %@, For: %@", error, residenceImage.imageURL);
            }
            else {
              // Image view
              weakScroll.imageView.frame = CGRectMake(0.0f, 0.0f,
                image.size.width, image.size.height);
              // Scroll
              weakScroll.minimumZoomScale =
                rect.size.width / weakScroll.imageView.image.size.width;
              weakScroll.maximumZoomScale = 1.0;
              weakScroll.showsHorizontalScrollIndicator = NO;
              weakScroll.showsVerticalScrollIndicator   = NO;
              weakScroll.zoomScale = weakScroll.minimumZoomScale;
            }
          }
        ];
    // [scroll addSubview: imageView];

    // scroll.minimumZoomScale = rect.size.width / imageView.image.size.width;
    // scroll.maximumZoomScale = 1.0;
    // scroll.showsHorizontalScrollIndicator = NO;
    // scroll.showsVerticalScrollIndicator   = NO;
    // scroll.zoomScale = scroll.minimumZoomScale;
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

  [UIView animateWithDuration: OMBStandardDuration animations: ^{
    blurView.alpha = 1.0f;
    imageScrollView.alpha = 1.0f;
    imageScrollView.transform = CGAffineTransformIdentity;
  } completion: ^(BOOL finished) {
    if (finished) {
      [[UIApplication sharedApplication] setStatusBarHidden:YES];
    }
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

- (void) updateBackgroundImage
{
  // Download the residence's images
  OMBResidenceImagesConnection *conn =
    [[OMBResidenceImagesConnection alloc] initWithResidence: residence];
  conn.completionBlock = ^(NSError *error) {
    // Add the cover photo
    __weak typeof(backgroundBlurView) weakBlurView   = backgroundBlurView;
    OMBCenteredImageView *iv = [[OMBCenteredImageView alloc] initWithFrame:
      self.view.frame];
    __weak typeof(iv) weakImageView = iv;
    [residence setImageForCenteredImageView: iv
      withURL: residence.coverPhotoURL completion: ^{
        [weakBlurView refreshWithImage: weakImageView.image];
      }];
  };
  [conn start];
}

@end
