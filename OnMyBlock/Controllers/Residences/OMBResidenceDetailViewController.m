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
#import "OMBCenteredImageView.h"
#import "OMBFavoriteResidence.h"
#import "OMBFavoriteResidenceConnection.h"
#import "OMBGradientView.h"
#import "OMBLoginViewController.h"
#import "OMBMapViewController.h"
#import "OMBMessageDetailViewController.h"
#import "OMBMessageNewViewController.h"
#import "OMBResidence.h"
#import "OMBResidenceBookItViewController.h"
#import "OMBResidenceCell.h"
#import "OMBResidenceDetailActivityCell.h"
#import "OMBResidenceDetailAddressCell.h"
#import "OMBResidenceDetailAmenitiesCell.h"
#import "OMBResidenceDetailDescriptionCell.h"
#import "OMBResidenceDetailMapCell.h"
#import "OMBResidenceDetailSellerCell.h"
#import "OMBResidenceImage.h"
#import "OMBResidenceDetailConnection.h"
#import "OMBResidenceImagesConnection.h"
#import "OMBResidenceImageSlideViewController.h"
#import "OMBTemporaryResidence.h"
#import "OMBViewControllerContainer.h"
#import "UIColor+Extensions.h"
#import "UIImage+Color.h"
#import "UIImage+Resize.h"

float kResidenceDetailCellSpacingHeight = 40.0f;

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

#pragma mark - Override UIViewController

- (void) loadView
{
  [super loadView];

  _imageViewArray = [NSMutableArray array];

  self.navigationItem.rightBarButtonItem =
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:
      UIBarButtonSystemItemAction target: self
        action: @selector(shareButtonSelected)];

  CGRect screen = [[UIScreen mainScreen] bounds];
  self.view     = [[UIView alloc] initWithFrame: screen];

  float padding      = 20.0f;
  float screenHeight = screen.size.height;
  float screenWidth  = screen.size.width;

  UIFont *fontLight18  = [UIFont fontWithName: @"HelveticaNeue-Light" size: 18];
  UIFont *fontMedium18 = [UIFont fontWithName: @"HelveticaNeue-Medium" 
    size: 18];

  _table = [[UITableView alloc] initWithFrame: screen
    style: UITableViewStylePlain];
  _table.alwaysBounceVertical         = YES;
  _table.backgroundColor              = [UIColor grayUltraLight];
  _table.canCancelContentTouches      = YES;
  // _table.contentInset                 = UIEdgeInsetsMake(0, 0, -49, 0);
  _table.dataSource                   = self;
  _table.delegate                     = self;
  _table.separatorColor               = [UIColor clearColor];
  _table.separatorInset = UIEdgeInsetsMake(0.0f, 20.0f, 0.0f, 0.0f);
  _table.separatorStyle               = UITableViewCellSeparatorStyleNone;
  _table.showsVerticalScrollIndicator = NO;
  [self.view addSubview: _table];

  // Images
  _imagesView = [[UIView alloc] init];
  _imagesView.frame = CGRectMake(0.0f, 0.0f, screenWidth, screenHeight * 0.5f);
  _table.tableHeaderView = _imagesView;
  // Images scrolling view; image slides
  _imagesScrollView = [[UIScrollView alloc] init];
  _imagesScrollView.alwaysBounceHorizontal = YES;
  _imagesScrollView.backgroundColor = [UIColor blackColor];
  _imagesScrollView.bounces  = YES;
  _imagesScrollView.delegate = self;
  _imagesScrollView.frame    = _imagesView.frame;
  _imagesScrollView.pagingEnabled                  = YES;
  _imagesScrollView.showsHorizontalScrollIndicator = NO;
  [_imagesView addSubview: _imagesScrollView];
  // Tap gesture when user clicks the images
  UITapGestureRecognizer *tapGesture = 
    [[UITapGestureRecognizer alloc] initWithTarget: self 
      action: @selector(showImageSlideViewController)];
  [_imagesScrollView addGestureRecognizer: tapGesture];
  // Gradient
  _gradientView = [[OMBGradientView alloc] init];
  _gradientView.colors = @[
    [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 0.0],
    [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 0.5]
  ];
  _gradientView.frame      = _imagesView.frame;
  _gradientView.scrollView = _imagesScrollView;
  [_imagesView addSubview: _gradientView];
  // Activity indicator view
  activityIndicatorView = 
    [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: 
      UIActivityIndicatorViewStyleWhiteLarge];
  activityIndicatorView.color = [UIColor whiteColor];
  CGRect activityFrame = activityIndicatorView.frame;
  activityFrame.origin.x = (_imagesScrollView.frame.size.width - 
    activityFrame.size.width) / 2.0;
  activityFrame.origin.y = (_imagesScrollView.frame.size.height - 
    activityFrame.size.height) / 2.0;
  activityIndicatorView.frame = activityFrame;
  activityIndicatorView.layer.zPosition = 9999;
  [_imagesScrollView addSubview: activityIndicatorView];
  // Page of images
  _pageOfImagesLabel = [[UILabel alloc] init];
  _pageOfImagesLabel.backgroundColor = [UIColor colorWithWhite: 0.0f 
    alpha: 0.5f];
  _pageOfImagesLabel.font = [UIFont fontWithName: @"HelveticaNeue-Light"
    size: 13];
  _pageOfImagesLabel.frame = CGRectMake(
    (_imagesScrollView.frame.size.width - (50 + (padding * 0.5))), 
      (padding * 0.5), 50.0f, 30.0f);
  _pageOfImagesLabel.layer.cornerRadius = 2.0f;
  _pageOfImagesLabel.textAlignment = NSTextAlignmentCenter;
  _pageOfImagesLabel.textColor = [UIColor whiteColor];
  [_imagesView addSubview: _pageOfImagesLabel];

  // Favorites Button
  _favoritesButton = [[UIButton alloc] init];
  _favoritesButton.frame = CGRectMake(5.0f, 5.0f, 40.0f, 40.0f);
  [_favoritesButton addTarget: self action: @selector(favoritesButtonSelected)
    forControlEvents: UIControlEventTouchUpInside];
  [_imagesView addSubview: _favoritesButton];
  // When favorited
  favoritedImage = [UIImage image: 
    [UIImage imageNamed: @"favorite_filled_white.png"] 
      size: _favoritesButton.frame.size];
  // When not favorited
  notFavoritedImage = [UIImage image: 
    [UIImage imageNamed: @"favorite_outline_white.png"] 
      size: _favoritesButton.frame.size];

  // Number of offers
  _numberOfOffersLabel = [[UILabel alloc] init];
  _numberOfOffersLabel.font = fontMedium18;
  _numberOfOffersLabel.frame = CGRectMake(padding * 0.5, 
    _imagesView.frame.size.height - (27.0f + (padding * 0.5)), 
      _imagesView.frame.size.width - padding, 27.0f);
  _numberOfOffersLabel.text = @"5 offers";
  _numberOfOffersLabel.textAlignment = NSTextAlignmentRight;
  _numberOfOffersLabel.textColor = [UIColor whiteColor];
  // [_imagesView addSubview: _numberOfOffersLabel];

  // Current offer
  _currentOfferLabel = [[UILabel alloc] init];
  _currentOfferLabel.font = [UIFont fontWithName: @"HelveticaNeue-Medium"
    size: 27];
  _currentOfferLabel.frame = CGRectMake(_numberOfOffersLabel.frame.origin.x,
    _numberOfOffersLabel.frame.origin.y - 36.0f, 
      _numberOfOffersLabel.frame.size.width, 36.0f);
  _currentOfferLabel.textAlignment = _numberOfOffersLabel.textAlignment;
  _currentOfferLabel.textColor = _numberOfOffersLabel.textColor;
  [_imagesView addSubview: _currentOfferLabel];

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
  _contactMeButton.titleLabel.font = fontLight18;
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
  [_bookItButton addTarget: self action: @selector(showBookItNow)
    forControlEvents: UIControlEventTouchUpInside];
  [_bookItButton setTitle: @"Book It!" forState: UIControlStateNormal];
  [_bookItButton setTitleColor: [UIColor whiteColor]
    forState: UIControlStateNormal];
  [_bottomButtonView addSubview: _bookItButton];

  // Mini map
  // _miniMap          = [[MKMapView alloc] init];
  // _miniMap.delegate = self;
  // _miniMap.frame    = CGRectMake(padding, 
  //   kResidenceDetailCellSpacingHeight + padding,
  //     screenWidth - (padding * 2), screenWidth * 0.5);
  // _miniMap.mapType       = MKMapTypeStandard;
  // _miniMap.rotateEnabled = NO;
  // _miniMap.scrollEnabled = NO;
  // _miniMap.showsPointsOfInterest = NO;
  // _miniMap.zoomEnabled   = NO;
}

- (void) viewDidAppear: (BOOL) animated
{
  [super viewDidAppear: animated];
  [self resetImageViews];
  // If images were already downloaded for the residence,
  // create image views and set the residence images to them
  if ([[residence imagesArray] count] > 1) {
    for (OMBResidenceImage *residenceImage in [residence imagesArray]) {
      OMBCenteredImageView *imageView = [[OMBCenteredImageView alloc] init];
      [imageView setImage: residenceImage.image];

      // UIImageView *imageView    = [[UIImageView alloc] init];
      // imageView.backgroundColor = [UIColor clearColor];
      // imageView.clipsToBounds   = YES;
      // imageView.contentMode     = UIViewContentModeTopLeft;
      // imageView.image = [UIImage image: residenceImage.image 
      //   sizeToFitVertical: CGSizeMake(_imagesScrollView.frame.size.width,
      //     _imagesScrollView.frame.size.height)];

      [_imageViewArray addObject: imageView];
    }
    [self addImageViewsToImageScrollView];

    _pageOfImagesLabel.text = [NSString stringWithFormat: @"%i/%i",
      [self currentPageOfImages], (int) [[residence imagesArray] count]];

    [self adjustPageOfImagesLabelFrame];
  }
  // If images were not downloaded for the residence,
  // download the images and add the image view and image to images scroll view
  else {
    OMBResidenceImagesConnection *connection = 
      [[OMBResidenceImagesConnection alloc] initWithResidence: residence];
    connection.completionBlock = ^(NSError *error) {
      [activityIndicatorView stopAnimating];
    };
    connection.delegate = self;
    [connection start];
    [activityIndicatorView startAnimating];
  }
}

- (void) viewDidDisappear: (BOOL) animated
{
  [super viewDidDisappear: animated];
  // Need to do this or an error occurs
  _table.delegate = nil;
}

- (void) viewWillAppear: (BOOL) animated
{
  [super viewWillAppear: animated];

  // Need to set this again because when the view disappears, 
  // the _table.delegate is set to nil
  if (!_table.delegate)
    _table.delegate = self;

  // Fetch residence detail data
  OMBResidenceDetailConnection *connection =
    [[OMBResidenceDetailConnection alloc] initWithResidence: residence];
  connection.completionBlock = ^(NSError *error) {
    [self refreshResidenceData];
  };
  [connection start];

  _currentOfferLabel.text = [residence rentToCurrencyString];

  [self adjustFavoriteButton];

  if ([residence isKindOfClass: [OMBTemporaryResidence class]]) {
    _favoritesButton.hidden = YES;
    [self.navigationItem setRightBarButtonItem: nil animated: NO];
  }

  // Fetch the offers (Do this in another phase, we aren't showing offers)
  // [residence fetchOffersWithCompletion: nil];

  // Table footer view
  CGFloat footerHeight = _bottomButtonView.frame.size.height;
  if (residence.user.uid == [OMBUser currentUser].uid) {
    footerHeight = 0.0f;
    _bottomButtonView.hidden = YES;
  }
  _table.tableFooterView = [[UIView alloc] initWithFrame: 
    CGRectMake(0.0f, 0.0f, _table.frame.size.width, footerHeight)];
}

- (void) viewWillDisappear: (BOOL) animated
{
  [super viewWillDisappear: animated];

  // _table.delegate = nil;
  [countdownTimer invalidate];
}

#pragma mark - Protocol

#pragma mark - Protocol MKMapViewDelegate

- (MKAnnotationView *) mapView: (MKMapView *) map 
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

#pragma mark - Protocol UIScrollViewDelegate

- (void) scrollViewDidScroll: (UIScrollView *) scrollView
{
  // Change the page numbers when scrolling
  if (scrollView == _imagesScrollView) {
    if ([self currentPageOfImages]) {
      _pageOfImagesLabel.text = [NSString stringWithFormat: @"%i/%i",
        [self currentPageOfImages], (int) [[residence imagesArray] count]];
    }
  }
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
  emptyCell.backgroundColor =
    emptyCell.contentView.backgroundColor = [UIColor clearColor];
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
        @"%@ - available %@",
          [residence.propertyType capitalizedString], availableDateString];
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
      if (!cell)
        cell = [[OMBResidenceDetailAmenitiesCell alloc] initWithStyle:
          UITableViewCellStyleDefault reuseIdentifier: AmentiesCellIdentifier];
      [cell loadAmenitiesData: [residence availableAmenities]];
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
      if (!cell)
        cell = [[OMBResidenceDetailDescriptionCell alloc] initWithStyle:
          UITableViewCellStyleDefault reuseIdentifier: 
            DescriptionCellIdentifier];
      [cell loadData: residence.description];
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
        cell.mapView.delegate = self;

        // Set the region of the mini map
        CGFloat distanceInMiles = 1609 * 0.5; // 1609 meters = 1 mile
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(
          residence.latitude, residence.longitude);
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(
          coordinate, distanceInMiles, distanceInMiles);
        [cell.mapView setRegion: region animated: NO];
        // Add annotation
        OMBAnnotation *annotation = [[OMBAnnotation alloc] init];
        annotation.coordinate     = coordinate;
        [cell.mapView addAnnotation: annotation];
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

- (void) addImageViewsToImageScrollView
{
  // Add imageViews to _imagesScrollView from _imagesViewArray
  // and then set the _imagesScrollView content size
  for (OMBCenteredImageView *imageView in _imageViewArray) {
    imageView.frame = CGRectMake((_imagesScrollView.frame.size.width * 
      [_imageViewArray indexOfObject: imageView]), 0, 
        _imagesScrollView.frame.size.width, 
          _imagesScrollView.frame.size.height);
    [_imagesScrollView addSubview: imageView];
  }
  _imagesScrollView.contentSize = CGSizeMake(
    (_imagesScrollView.frame.size.width * [_imageViewArray count]), 
      _imagesScrollView.frame.size.height);
}

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
    CGSizeMake(50.0f, _pageOfImagesLabel.frame.size.height)
      options: NSStringDrawingUsesLineFragmentOrigin
        attributes: @{ NSFontAttributeName: _pageOfImagesLabel.font }
          context: nil];
  // Padding on each side
  CGFloat pageWidth = (_pageOfImagesLabel.frame.origin.y * 2.0f) +
    pageRect.size.width;
  _pageOfImagesLabel.frame = CGRectMake(_imagesScrollView.frame.size.width - 
    (pageWidth + _pageOfImagesLabel.frame.origin.y), 
      _pageOfImagesLabel.frame.origin.y, pageWidth,
        _pageOfImagesLabel.frame.size.height);
}

- (void) contactMeButtonSelected
{
  if ([OMBUser currentUser].accessToken) {
    // messageDetailViewController = 
    //   [[OMBMessageDetailViewController alloc] initWithUser: residence.user];
    // [self.navigationController pushViewController: 
    //   messageDetailViewController
    //     animated: YES];
    OMBUser *user = residence.user;
    if (!user || [user.firstName length] == 0)
      user = [OMBUser landlordUser];
    [self presentViewController: 
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
    _imagesScrollView.contentOffset.x / _imagesScrollView.frame.size.width);
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
            imageView.transform = CGAffineTransformMakeScale(0.7f, 0.7f);
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

- (void) resetImageViews
{
  // Remove UIImageView from _imagesScrollView
  [_imagesScrollView.subviews enumerateObjectsUsingBlock: 
    ^(UIView *v, NSUInteger idx, BOOL *stop) {
      if ([v isKindOfClass: [UIImageView class]])
        [v removeFromSuperview];
    }
  ];
  // Empty out any UIImageView from the _imageViewArray
  [_imageViewArray removeAllObjects];
}

- (void) shareButtonSelected
{
  NSArray *dataToShare = @[[residence shareString]];
  UIActivityViewController *activityViewController = 
    [[UIActivityViewController alloc] initWithActivityItems: dataToShare
      applicationActivities: nil];
  [[self appDelegate].container presentViewController: activityViewController
    animated: YES completion: nil];

}

- (void) showBookItNow
{
  [self.navigationController pushViewController: 
    [[OMBResidenceBookItViewController alloc] initWithResidence: residence] 
      animated: YES];
}

- (void) showImageSlideViewController
{
  [self presentViewController: _imageSlideViewController animated: YES
    completion: nil];
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
