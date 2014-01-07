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
  self.title = @"Current Offer: $4,500";

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
  [_favoritesButton setImage: [UIImage image: 
    [UIImage imageNamed: @"favorite_outline_white.png"] 
      size: CGSizeMake(40.0f, 40.0f)] forState: UIControlStateNormal];
  [_imagesView addSubview: _favoritesButton];
  // Number of offers
  _numberOfOffersLabel = [[UILabel alloc] init];
  _numberOfOffersLabel.font = fontMedium18;
  _numberOfOffersLabel.frame = CGRectMake(padding * 0.5, 
    _imagesView.frame.size.height - (27.0f + (padding * 0.5)), 
      _imagesView.frame.size.width - padding, 27.0f);
  _numberOfOffersLabel.text = @"5 offers";
  _numberOfOffersLabel.textAlignment = NSTextAlignmentRight;
  _numberOfOffersLabel.textColor = [UIColor whiteColor];
  [_imagesView addSubview: _numberOfOffersLabel];
  // Current offer
  _currentOfferLabel = [[UILabel alloc] init];
  _currentOfferLabel.font = [UIFont fontWithName: @"HelveticaNeue-Medium"
    size: 27];
  _currentOfferLabel.frame = CGRectMake(_numberOfOffersLabel.frame.origin.x,
    _numberOfOffersLabel.frame.origin.y - 36.0f, 
      _numberOfOffersLabel.frame.size.width, 36.0f);
  _currentOfferLabel.text = @"$4,500";
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
  _countDownTimerLabel.text = @"Time left in auction: 05:02:01:22";
  _countDownTimerLabel.textColor = [UIColor whiteColor];
  _countDownTimerLabel.textAlignment = NSTextAlignmentCenter;
  [_bottomButtonView addSubview: _countDownTimerLabel];
  // Contact me button
  _contactMeButton = [[UIButton alloc] init];
  _contactMeButton.backgroundColor = [UIColor blueAlpha: 0.8f];
  _contactMeButton.frame = CGRectMake(0.0f, 
    _countDownTimerLabel.frame.origin.y + 
    _countDownTimerLabel.frame.size.height + 1.0f, 
      (_bottomButtonView.frame.size.width - 1.0f) * 0.5, 44.0f);
  _contactMeButton.titleLabel.font = fontLight18;
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
  _miniMap          = [[MKMapView alloc] init];
  _miniMap.delegate = self;
  _miniMap.frame    = CGRectMake(padding, 
    kResidenceDetailCellSpacingHeight + padding,
      screenWidth - (padding * 2), screenWidth * 0.5);
  _miniMap.mapType       = MKMapTypeStandard;
  _miniMap.rotateEnabled = NO;
  _miniMap.scrollEnabled = NO;
  _miniMap.showsPointsOfInterest = NO;
  _miniMap.zoomEnabled   = NO;

  // Table footer view
  _table.tableFooterView = [[UIView alloc] initWithFrame: 
    CGRectMake(0.0f, 0.0f, screenWidth, _bottomButtonView.frame.size.height)];
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

  // Mini map
  // Set the region of the mini map
  CGFloat distanceInMiles = 1609 * 0.5; // 1609 meters = 1 mile
  CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(
    residence.latitude, residence.longitude);
  MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coordinate, 
    distanceInMiles, distanceInMiles);
  [_miniMap setRegion: region animated: NO];
  // Add annotation
  OMBAnnotation *annotation = [[OMBAnnotation alloc] init];
  annotation.coordinate     = coordinate;
  [_miniMap addAnnotation: annotation];

  // Fetch residence detail data
  OMBResidenceDetailConnection *connection =
    [[OMBResidenceDetailConnection alloc] initWithResidence: residence];
  connection.completionBlock = ^(NSError *error) {
    [self refreshResidenceData];
  };
  [connection start];
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
}

- (void) viewWillDisappear: (BOOL) animated
{
  // [super viewWillDisappear: animated];
  // _table.delegate = nil;
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
      return cell;
    }
  }

  // Map
  else if (indexPath.section == 5) {
    if (indexPath.row == 1) {
      static NSString *MapCellIdentifier = @"MapCellIdentifier";
      OMBResidenceDetailMapCell *cell = 
        [tableView dequeueReusableCellWithIdentifier: MapCellIdentifier];
      if (!cell)
        cell = [[OMBResidenceDetailMapCell alloc] initWithStyle:
          UITableViewCellStyleDefault reuseIdentifier: MapCellIdentifier];
      cell.mapView = _miniMap;
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
    return 2; // 2 is for the spacing above
  }

  // Description
  else if (section == 3) {
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
      return kResidenceDetailCellSpacingHeight;
    }
  }

  // Amenities
  else if (indexPath.section == 2) {
    if (indexPath.row == 0) {
      return kResidenceDetailCellSpacingHeight;
    }
    else if (indexPath.row == 1) {
      return kResidenceDetailCellSpacingHeight + 
        padding + (23.0f * 4) + padding;
    }
  }

  // Description
  else if (indexPath.section == 3) {
    if (indexPath.row == 0) {
      return kResidenceDetailCellSpacingHeight;
    }
    else if (indexPath.row == 1) {
      return 200.0f;
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

- (int) currentPageOfImages
{
  return (1 + 
    _imagesScrollView.contentOffset.x / _imagesScrollView.frame.size.width);
}

- (void) currentUserLogout
{
  NSLog(@"Residence Detail Current User Logout");
}

- (void) refreshResidenceData
{
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
  NSLog(@"RESIDENCE DETAIL SHARE BUTTON SELECTED");
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

@end
