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
#import "OMBResidence.h"
#import "OMBResidenceCell.h"
#import "OMBResidenceSimilarConnection.h"
#import "OMBResidenceDetailConnection.h"
#import "OMBResidenceImagesConnection.h"
#import "OMBResidenceImageSlideViewController.h"
#import "UIColor+Extensions.h"
#import "UIImage+Color.h"
#import "UIImage+Resize.h"

int kResidenceDetailPadding       = 10;
int kResidenceDetailPaddingDouble = 10 * 2;

@implementation OMBResidenceDetailViewController

@synthesize addressLabel             = _addressLabel;
@synthesize addToFavoritesButton     = _addToFavoritesButton;
@synthesize availableLabel           = _availableLabel;
@synthesize availableView            = _availableView;
@synthesize bathLabel                = _bathLabel;
@synthesize bathSubLabel             = _bathSubLabel;
@synthesize bedLabel                 = _bedLabel;
@synthesize bedSubLabel              = _bedSubLabel;
@synthesize contactButton            = _contactButton;
@synthesize imagesScrollView         = _imagesScrollView;
@synthesize imageSlideViewController = _imageSlideViewController;
@synthesize imageViewArray           = _imageViewArray;
@synthesize infoView                 = _infoView;
@synthesize pageOfImagesLabel        = _pageOfImagesLabel;
@synthesize rentLabel                = _rentLabel;
@synthesize squareFeetLabel          = _squareFeetLabel;
@synthesize squareFeetSubLabel       = _squareFeetSubLabel;
@synthesize table                    = _table;

#pragma mark - Initializer

- (id) initWithResidence: (OMBResidence *) object
{
  if (!(self = [super init])) return nil;

  residence         = object;
  similarResidences = [NSMutableArray array];
  self.title = [residence.address capitalizedString];
  _imageSlideViewController = 
    [[OMBResidenceImageSlideViewController alloc] initWithResidence: residence];
  _imageSlideViewController.modalTransitionStyle = 
    UIModalTransitionStyleCrossDissolve;
  _imageSlideViewController.residenceDetailViewController = self;

  return self;
}

#pragma mark - Override

#pragma mark - Override UIViewController

- (void) loadView
{
  [super loadView];

  _imageViewArray = [NSMutableArray array];

  CGRect screen = [[UIScreen mainScreen] bounds];
  self.view = [[UIView alloc] initWithFrame: screen];

  UIFont *fontLight18  = [UIFont fontWithName: @"HelveticaNeue-Light" size: 18];
  UIFont *fontMedium18 = [UIFont fontWithName: @"HelveticaNeue-Medium" 
    size: 18];

  _table = [[UITableView alloc] initWithFrame: screen
    style: UITableViewStylePlain];
  _table.alwaysBounceVertical         = YES;
  _table.backgroundColor              = [UIColor backgroundColor];
  _table.canCancelContentTouches      = YES;
  _table.contentInset                 = UIEdgeInsetsMake(0, 0, -49, 0);
  _table.dataSource                   = self;
  _table.delegate                     = self;
  _table.separatorColor               = [UIColor clearColor];
  _table.separatorStyle               = UITableViewCellSeparatorStyleNone;
  _table.showsVerticalScrollIndicator = NO;
  [self.view addSubview: _table];

  // Images scrolling view; image slides
  _imagesScrollView                 = [[UIScrollView alloc] init];
  _imagesScrollView.backgroundColor = [UIColor grayLight];
  _imagesScrollView.bounces  = NO;
  _imagesScrollView.delegate = self;
  _imagesScrollView.frame    = CGRectMake(0, 0, screen.size.width, 
    (screen.size.height * 0.5));
  _imagesScrollView.pagingEnabled                  = YES;
  _imagesScrollView.showsHorizontalScrollIndicator = NO;

  UITapGestureRecognizer *tapGesture = 
    [[UITapGestureRecognizer alloc] initWithTarget: self 
      action: @selector(showImageSlideViewController)];
  [_imagesScrollView addGestureRecognizer: tapGesture];

  // Page of images
  _pageOfImagesLabel = [[UILabel alloc] init];
  _pageOfImagesLabel.backgroundColor = [UIColor colorWithRed: 0 
    green: 0 blue: 0 alpha: 0.5];
  _pageOfImagesLabel.font = [UIFont fontWithName: @"HelveticaNeue-Light"
    size: 13];
  _pageOfImagesLabel.frame = CGRectMake(
    (_imagesScrollView.frame.size.width - (50 + 10)), 10, 50, 30);
  _pageOfImagesLabel.textAlignment = NSTextAlignmentCenter;
  _pageOfImagesLabel.textColor = [UIColor whiteColor];

  // Info view
  _infoView = [[UIView alloc] init];
  _infoView.backgroundColor = [UIColor clearColor];
  // Rent label
  _rentLabel = [[UILabel alloc] init];
  _rentLabel.font = [UIFont fontWithName: @"HelveticaNeue-Light" size: 36];
  _rentLabel.frame = CGRectMake(kResidenceDetailPaddingDouble, 
    kResidenceDetailPadding, 
      (screen.size.width - (kResidenceDetailPaddingDouble * 2)), 60);
  _rentLabel.textColor = [UIColor textColor];
  [_infoView addSubview: _rentLabel];

  // Add to favorites button
  _addToFavoritesButton = [[UIButton alloc] init];
  _addToFavoritesButton.backgroundColor = [UIColor pink];
  _addToFavoritesButton.clipsToBounds = YES;
  _addToFavoritesButton.frame = CGRectMake(
    (screen.size.width - (70 + _rentLabel.frame.origin.x)), 
    _rentLabel.frame.origin.y, 70, 50);
  _addToFavoritesButton.layer.cornerRadius = 2.0;
  UIImage *favoriteImage = 
    [UIImage image: [UIImage imageNamed: @"favorite.png"] 
      size: CGSizeMake(30, 30)];
  [_addToFavoritesButton addTarget: self 
    action: @selector(addToFavoritesButtonSelected) 
      forControlEvents: UIControlEventTouchUpInside];
  [_addToFavoritesButton setBackgroundImage: 
    [UIImage imageWithColor: [UIColor pinkDark]] 
      forState: UIControlStateHighlighted];
  [_addToFavoritesButton setImage: favoriteImage 
    forState: UIControlStateNormal];
  [_addToFavoritesButton setImage: favoriteImage 
    forState: UIControlStateHighlighted];
  [_infoView addSubview: _addToFavoritesButton];
  // Address label
  _addressLabel       = [[UILabel alloc] init];
  _addressLabel.font  = fontLight18;
  _addressLabel.frame = CGRectMake(_rentLabel.frame.origin.x, 
    (_rentLabel.frame.origin.y + _rentLabel.frame.size.height), 
      (screen.size.width - (_rentLabel.frame.origin.x * 2)), 30);
  _addressLabel.textColor = [UIColor textColor];
  [_infoView addSubview: _addressLabel];

  // Bed view
  UIView *bedView = [[UIView alloc] init];
  bedView.frame   = CGRectMake(0, 
    (_addressLabel.frame.origin.y + _addressLabel.frame.size.height + 
      kResidenceDetailPaddingDouble), (screen.size.width / 3.0), 
        (kResidenceDetailPaddingDouble + 24 + 20));
  CALayer *bedBorderBottom        = [CALayer layer];
  CALayer *bedBorderTop           = [CALayer layer];
  bedBorderBottom.backgroundColor = [UIColor grayLight].CGColor;
  bedBorderTop.backgroundColor    = [UIColor grayLight].CGColor;
  bedBorderBottom.frame = CGRectMake(0, (bedView.frame.size.height - 0.5),
    bedView.frame.size.width, 0.5);
  bedBorderTop.frame = CGRectMake(bedBorderBottom.frame.origin.x, 0, 
    bedBorderBottom.frame.size.width, bedBorderBottom.frame.size.height);
  [bedView.layer addSublayer: bedBorderBottom];
  [bedView.layer addSublayer: bedBorderTop];
  [_infoView addSubview: bedView];
  // Bed label
  _bedLabel       = [[UILabel alloc] init];
  _bedLabel.font  = fontLight18;
  _bedLabel.frame = CGRectMake(0, 10, bedView.frame.size.width, 24);
  _bedLabel.textAlignment = NSTextAlignmentCenter;
  _bedLabel.textColor     = [UIColor textColor];
  [bedView addSubview: _bedLabel];
  // Bed sub label
  _bedSubLabel       = [[UILabel alloc] init];
  _bedSubLabel.font  = [UIFont fontWithName: @"HelveticaNeue-Light" size: 15];
  _bedSubLabel.frame = CGRectMake(0, 
    (_bedLabel.frame.origin.y + _bedLabel.frame.size.height), 
      _bedLabel.frame.size.width, 20);
  _bedSubLabel.textAlignment = NSTextAlignmentCenter;
  _bedSubLabel.textColor     = [UIColor grayMedium];
  [bedView addSubview: _bedSubLabel];

  // Bath view
  UIView *bathView = [[UIView alloc] init];
  bathView.frame = CGRectMake(
    (bedView.frame.origin.x + bedView.frame.size.width), 
      bedView.frame.origin.y, bedView.frame.size.width, 
        bedView.frame.size.height);
  CALayer *bathBorderBottom        = [CALayer layer];
  CALayer *bathBorderTop           = [CALayer layer];
  bathBorderBottom.backgroundColor = bedBorderBottom.backgroundColor;
  bathBorderTop.backgroundColor    = bedBorderBottom.backgroundColor;
  bathBorderBottom.frame = bedBorderBottom.frame;
  bathBorderTop.frame    = bedBorderTop.frame;
  [bathView.layer addSublayer: bathBorderBottom];
  [bathView.layer addSublayer: bathBorderTop];
  [_infoView addSubview: bathView];
  // Bath label
  _bathLabel               = [[UILabel alloc] init];
  _bathLabel.font          = _bedLabel.font;
  _bathLabel.frame         = _bedLabel.frame;
  _bathLabel.textAlignment = _bedLabel.textAlignment;
  _bathLabel.textColor     = _bedLabel.textColor;
  [bathView addSubview: _bathLabel];
  // Bath sub label
  _bathSubLabel               = [[UILabel alloc] init];
  _bathSubLabel.font          = _bedSubLabel.font;
  _bathSubLabel.frame         = _bedSubLabel.frame;
  _bathSubLabel.textAlignment = _bedSubLabel.textAlignment;
  _bathSubLabel.textColor     = _bedSubLabel.textColor;
  [bathView addSubview: _bathSubLabel];

  // Square feet view
  UIView *squareFeetView = [[UIView alloc] init];
  squareFeetView.frame = CGRectMake(
    (bathView.frame.origin.x + bathView.frame.size.width), 
      bathView.frame.origin.y, bathView.frame.size.width, 
        bathView.frame.size.height);
  CALayer *squareFeetBorderBottom        = [CALayer layer];
  CALayer *squareFeetBorderTop           = [CALayer layer];
  squareFeetBorderBottom.backgroundColor = bedBorderBottom.backgroundColor;
  squareFeetBorderTop.backgroundColor    = bedBorderBottom.backgroundColor;
  squareFeetBorderBottom.frame = bedBorderBottom.frame;
  squareFeetBorderTop.frame    = bedBorderTop.frame;
  [squareFeetView.layer addSublayer: squareFeetBorderBottom];
  [squareFeetView.layer addSublayer: squareFeetBorderTop];
  [_infoView addSubview: squareFeetView];
  [_infoView addSubview: squareFeetView];
  // Square feet label
  _squareFeetLabel               = [[UILabel alloc] init];
  _squareFeetLabel.font          = _bedLabel.font;
  _squareFeetLabel.frame         = _bedLabel.frame;
  _squareFeetLabel.textAlignment = _bedLabel.textAlignment;
  _squareFeetLabel.textColor     = _bedLabel.textColor;
  [squareFeetView addSubview: _squareFeetLabel];
  // Square feet sub label
  _squareFeetSubLabel               = [[UILabel alloc] init];
  _squareFeetSubLabel.font          = _bedSubLabel.font;
  _squareFeetSubLabel.frame         = _bedSubLabel.frame;
  _squareFeetSubLabel.text          = @"sqft";
  _squareFeetSubLabel.textAlignment = _bedSubLabel.textAlignment;
  _squareFeetSubLabel.textColor     = _bedSubLabel.textColor;
  [squareFeetView addSubview: _squareFeetSubLabel];

  // Contact button
  _contactButton                 = [[UIButton alloc] init];
  _contactButton.backgroundColor = [UIColor green];
  _contactButton.clipsToBounds   = YES;
  _contactButton.frame = CGRectMake(_rentLabel.frame.origin.x,
    (bedView.frame.origin.y + bedView.frame.size.height + 
      kResidenceDetailPaddingDouble), _rentLabel.frame.size.width, (18 * 3));
  _contactButton.layer.cornerRadius = 2.0;
  _contactButton.titleLabel.font    = fontMedium18;
  [_contactButton addTarget: self action: @selector(contactButtonSelected)
    forControlEvents: UIControlEventTouchUpInside];
  [_contactButton setBackgroundImage: [UIImage imageWithColor: 
    [UIColor greenDark]] forState: UIControlStateHighlighted];
  [_contactButton setTitle: @"CONTACT" forState: UIControlStateNormal];
  [_contactButton setTitleColor: [UIColor whiteColor] 
    forState: UIControlStateNormal];
  [_infoView addSubview: _contactButton];

  // Info view frame
  _infoView.frame = CGRectMake(0, 0, screen.size.width, 
    (_contactButton.frame.origin.y + _contactButton.frame.size.height + 
      kResidenceDetailPaddingDouble));
  CALayer *infoViewBorderBottom = [CALayer layer];
  infoViewBorderBottom.backgroundColor = [UIColor grayMedium].CGColor;
  infoViewBorderBottom.frame = CGRectMake(0, 
    (_infoView.frame.size.height - 0.5), _infoView.frame.size.width, 0.5);
  [_infoView.layer addSublayer: infoViewBorderBottom];

  // Available view
  _availableView                 = [[UIView alloc] init];
  _availableView.backgroundColor = [UIColor whiteColor];
  // Header
  UILabel *availableHeaderLabel = [[UILabel alloc] init];
  availableHeaderLabel.font = fontMedium18;
  availableHeaderLabel.frame = CGRectMake(kResidenceDetailPaddingDouble, 
    kResidenceDetailPadding,
      (screen.size.width - (2 * kResidenceDetailPaddingDouble)), 27);
  availableHeaderLabel.text = @"Available";
  availableHeaderLabel.textColor = [UIColor textColor];
  [_availableView addSubview: availableHeaderLabel];
  // Label
  _availableLabel      = [[UILabel alloc] init];
  _availableLabel.font = fontLight18;
  _availableLabel.frame = CGRectMake(availableHeaderLabel.frame.origin.x,
    (availableHeaderLabel.frame.origin.y + 
      availableHeaderLabel.frame.size.height), 
        availableHeaderLabel.frame.size.width, 
          availableHeaderLabel.frame.size.height);
  _availableLabel.textColor = [UIColor textColor];
  [_availableView addSubview: _availableLabel];
  // Available view frame
  _availableView.frame = CGRectMake(0, 0, screen.size.width, 
    ((kResidenceDetailPadding * 2) + 
      availableHeaderLabel.frame.size.height + 
        _availableLabel.frame.size.height));
  CALayer *availableBorderBottom = [CALayer layer];
  availableBorderBottom.backgroundColor = infoViewBorderBottom.backgroundColor;
  availableBorderBottom.frame = CGRectMake(0, 
    (_availableView.frame.size.height - 0.5), 
      _availableView.frame.size.width, 0.5);
  CALayer *availableBorderTop = [CALayer layer];
  availableBorderTop.backgroundColor = infoViewBorderBottom.backgroundColor;
  availableBorderTop.frame = CGRectMake(0, 0, 
    _availableView.frame.size.width, availableBorderBottom.frame.size.height);
  [_availableView.layer addSublayer: availableBorderBottom];
  [_availableView.layer addSublayer: availableBorderTop];

  // Lease month view
  _leaseMonthView = [[UIView alloc] init];
  _leaseMonthView.backgroundColor = _availableView.backgroundColor;
  // Header
  UILabel *leaseMonthHeaderLabel = [[UILabel alloc] init];
  leaseMonthHeaderLabel.font = availableHeaderLabel.font;
  leaseMonthHeaderLabel.frame = availableHeaderLabel.frame;
  leaseMonthHeaderLabel.text = @"Term";
  leaseMonthHeaderLabel.textColor = availableHeaderLabel.textColor;
  [_leaseMonthView addSubview: leaseMonthHeaderLabel];
  // Label
  _leaseMonthLabel = [[UILabel alloc] init];
  _leaseMonthLabel.font = _availableLabel.font;
  _leaseMonthLabel.frame = _availableLabel.frame;
  _leaseMonthLabel.textColor = _availableLabel.textColor;
  [_leaseMonthView addSubview: _leaseMonthLabel];
  // Lease month view frame
  _leaseMonthView.frame = _availableView.frame;
  CALayer *leaseMonthBorderBottom = [CALayer layer];
  CALayer *leaseMonthBorderTop    = [CALayer layer];
  leaseMonthBorderBottom.backgroundColor = infoViewBorderBottom.backgroundColor;
  leaseMonthBorderBottom.frame = availableBorderBottom.frame;
  leaseMonthBorderTop.backgroundColor = infoViewBorderBottom.backgroundColor;
  leaseMonthBorderTop.frame = availableBorderTop.frame;
  [_leaseMonthView.layer addSublayer: leaseMonthBorderBottom];
  [_leaseMonthView.layer addSublayer: leaseMonthBorderTop];

  // Description view
  _descriptionView = [[UIView alloc] init];
  _descriptionView.backgroundColor = _availableView.backgroundColor;
  // Header
  UILabel *descriptionHeaderLabel = [[UILabel alloc] init];
  descriptionHeaderLabel.font = availableHeaderLabel.font;
  descriptionHeaderLabel.frame = availableHeaderLabel.frame;
  descriptionHeaderLabel.text = @"Description";
  descriptionHeaderLabel.textColor = availableHeaderLabel.textColor;
  [_descriptionView addSubview: descriptionHeaderLabel];
  // Label
  _descriptionLabel = [[UILabel alloc] init];
  _descriptionLabel.font = [UIFont fontWithName: @"HelveticaNeue-Light"
    size: 15];
  _descriptionLabel.frame = CGRectMake(_availableLabel.frame.origin.x,
    (_availableLabel.frame.origin.y + kResidenceDetailPadding),
      _availableLabel.frame.size.width, _availableLabel.frame.size.height);
  _descriptionLabel.numberOfLines = 0;
  _descriptionLabel.text = @"Very popular college pad.";
  _descriptionLabel.textColor = _availableLabel.textColor;
  [_descriptionView addSubview: _descriptionLabel];
  // Description view frame
  _descriptionView.frame = CGRectMake(_availableView.frame.origin.x,
    _availableView.frame.origin.y, _availableView.frame.size.width,
      (_availableView.frame.size.height + kResidenceDetailPaddingDouble));
  descriptionBorderBottom = [CALayer layer];
  CALayer *descriptionBorderTop = [CALayer layer];
  descriptionBorderBottom.backgroundColor = 
    availableBorderBottom.backgroundColor;
    descriptionBorderBottom.frame = availableBorderBottom.frame;
  descriptionBorderTop.backgroundColor = availableBorderTop.backgroundColor;
  descriptionBorderTop.frame = availableBorderTop.frame;
  [_descriptionView.layer addSublayer: descriptionBorderTop];
  [_descriptionView.layer addSublayer: descriptionBorderBottom];

  // Map
  _map                 = [[UIView alloc] init];
  _map.backgroundColor = [UIColor whiteColor];
  _map.frame = CGRectMake(_availableView.frame.origin.x, 
    _availableView.frame.origin.y, _availableView.frame.size.width,
      ((kResidenceDetailPaddingDouble * 2) + 200));
  CALayer *mapBorderBottom = [CALayer layer];
  CALayer *mapBorderTop    = [CALayer layer];
  mapBorderBottom.backgroundColor = availableBorderBottom.backgroundColor;
  mapBorderBottom.frame = CGRectMake(availableBorderBottom.frame.origin.x, 
    (_map.frame.size.height - availableBorderBottom.frame.size.height), 
      availableBorderBottom.frame.size.width, 
        availableBorderBottom.frame.size.height);
  mapBorderTop.backgroundColor = availableBorderTop.backgroundColor;
  mapBorderTop.frame           = availableBorderTop.frame;
  [_map.layer addSublayer: mapBorderBottom];
  [_map.layer addSublayer: mapBorderTop];
  // Mini map
  _miniMap          = [[MKMapView alloc] init];
  _miniMap.delegate = self;
  _miniMap.frame    = CGRectMake(kResidenceDetailPaddingDouble, 
    kResidenceDetailPaddingDouble, 
      (_map.frame.size.width - (kResidenceDetailPaddingDouble * 2)), 200);
  _miniMap.mapType       = MKMapTypeStandard;
  _miniMap.rotateEnabled = NO;
  _miniMap.scrollEnabled = NO;
  _miniMap.zoomEnabled   = NO;
  [_map addSubview: _miniMap];

  // Similar residences view
  _similarResidencesView = [[UIView alloc] init];
  _similarResidencesView.backgroundColor = _availableView.backgroundColor;
  _similarResidencesView.frame = CGRectMake(_availableView.frame.origin.x,
    _availableView.frame.origin.y, _availableView.frame.size.width,
      ((kResidenceDetailPadding * 2) + availableHeaderLabel.frame.size.height));
  CALayer *similarResidencesBorderTop = [CALayer layer];
  similarResidencesBorderTop.backgroundColor = 
    availableBorderTop.backgroundColor;
  similarResidencesBorderTop.frame = availableBorderTop.frame;
  [_similarResidencesView.layer addSublayer: similarResidencesBorderTop];
  // Header
  UILabel *similarResidencesHeaderLabel = [[UILabel alloc] init];
  similarResidencesHeaderLabel.font = availableHeaderLabel.font;
  similarResidencesHeaderLabel.frame = availableHeaderLabel.frame;
  similarResidencesHeaderLabel.text = @"Similar";
  similarResidencesHeaderLabel.textColor = availableHeaderLabel.textColor;
  [_similarResidencesView addSubview: similarResidencesHeaderLabel];
}

- (void) viewDidAppear: (BOOL) animated
{
  [super viewDidAppear: animated];

  [self resetImageViews];
  // If images were already downloaded for the residence,
  // create image views and set the residence images to them
  if ([[residence imagesArray] count] > 1) {
    for (UIImage *image in residence.imagesArray) {
      UIImageView *imageView    = [[UIImageView alloc] init];
      imageView.backgroundColor = [UIColor clearColor];
      imageView.clipsToBounds   = YES;
      imageView.contentMode     = UIViewContentModeTopLeft;
      imageView.image           = [UIImage image: image sizeToFitVertical:
        CGSizeMake(_imagesScrollView.frame.size.width,
          _imagesScrollView.frame.size.height)];
      [_imageViewArray addObject: imageView];
    }
    [self addImageViewsToImageScrollView];
    _pageOfImagesLabel.text = [NSString stringWithFormat: @"%i/%i",
      [self currentPageOfImages], (int) [[residence imagesArray] count]];
  }
  // If images were not downloaded for the residence,
  // download the images and add the image view and image to images scroll view
  else {
    OMBResidenceImagesConnection *connection = 
      [[OMBResidenceImagesConnection alloc] initWithResidence: residence];
    connection.delegate = self;
    [connection start];
  }

  // Mini map
  // Set the region of the mini map
  int distanceInMiles = 1609 * 0.5; // 1609 meters = 1 mile
  CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(
    residence.latitude, residence.longitude);
  MKCoordinateRegion region =
    MKCoordinateRegionMakeWithDistance(coordinate, distanceInMiles, 
      distanceInMiles);
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

  // If no similar residences, fetch them
  if ([similarResidences count] == 0) {
    OMBResidenceSimilarConnection *conn = 
      [[OMBResidenceSimilarConnection alloc] initWithResidence: residence];
    conn.completionBlock = ^(NSError *error) {
      // reloadSections:withRowAnimation:
    };
    conn.delegate = self;
    [conn start]; 
  }

  // Rent
  _rentLabel.text = [NSString stringWithFormat: @"%@", 
    [residence rentToCurrencyString]];
  // Address
  _addressLabel.text = residence.address;
  // Bedrooms
  NSString *bedsString = @"beds";
  if (residence.bedrooms == 1)
    bedsString = @"bed";
  NSString *bedsNumberString;
  if (residence.bedrooms == (int) residence.bedrooms)
    bedsNumberString = [NSString stringWithFormat: @"%i", 
      (int) residence.bedrooms];
  else
    bedsNumberString = [NSString stringWithFormat: @"%.01f",
      residence.bedrooms];
  _bedLabel.text    = bedsNumberString; // 3
  _bedSubLabel.text = bedsString;       // bed / beds
  // Bathrooms
  NSString *bathsString = @"baths";
  if (residence.bathrooms == 1)
    bathsString = @"bath";
  NSString *bathsNumberString;
  if (residence.bathrooms == (int) residence.bathrooms)
    bathsNumberString = [NSString stringWithFormat: @"%i",
      (int) residence.bathrooms];
  else
    bathsNumberString = [NSString stringWithFormat: @"%.01f",
      residence.bathrooms];
  _bathLabel.text    = bathsNumberString;
  _bathSubLabel.text = bathsString;

  [self refreshResidenceData];
}

- (void) viewWillAppear: (BOOL) animated
{
  [super viewWillAppear: animated];
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

- (void) scrollViewDidEndDecelerating: (UIScrollView *) scrollView
{
  if (scrollView == _imagesScrollView) {
    _pageOfImagesLabel.text = [NSString stringWithFormat: @"%i/%i",
      [self currentPageOfImages], (int) [[residence imagesArray] count]];
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
  UITableViewCell *cell = [[UITableViewCell alloc] init];
  cell.selectionStyle   = UITableViewCellSelectionStyleNone;
  if (indexPath.section == 0) {
    // Image scroll
    if (indexPath.row == 0) {
      [cell.contentView addSubview: _imagesScrollView];
      [cell.contentView addSubview: _pageOfImagesLabel];
    }
    else if (indexPath.row == 1) {
      cell.selectedBackgroundView = [[UIView alloc] init];
      [cell.contentView addSubview: _infoView];
    }
  }
  else if (indexPath.section == 1) {
    if (indexPath.row == 0)
      [cell.contentView addSubview: _availableView];
  }
  else if (indexPath.section == 2) {
    if (indexPath.row == 0) {
      [cell.contentView addSubview: _leaseMonthView];
    }
  }
  else if (indexPath.section == 3) {
    if (indexPath.row == 0)
      [cell.contentView addSubview: _descriptionView];
  }
  else if (indexPath.section == 4) {
    if (indexPath.row == 0)
      [cell.contentView addSubview: _map];
  }
  else if (indexPath.section == 5) {
    if (indexPath.row == 0) {
      [cell.contentView addSubview: _similarResidencesView];
    }
    else {
      static NSString *CellIdentifier = @"CellIdentifier";
      OMBResidenceCell *rCell = [tableView dequeueReusableCellWithIdentifier:
        CellIdentifier];
      if (!rCell) {
        rCell = [[OMBResidenceCell alloc] initWithStyle: 
          UITableViewCellStyleDefault reuseIdentifier: CellIdentifier];
      }
      [rCell loadResidenceData: 
        [similarResidences objectAtIndex: (indexPath.row - 1)]];
      return rCell;
    }
  }
  return cell;
}

- (NSInteger) tableView: (UITableView *) tableView
numberOfRowsInSection: (NSInteger) section
{
  // Image scroll and info view
  if (section == 0)
    return 2;
  // Available view
  else if (section == 1)
    return 1;
  else if (section == 2)
    return 1;
  else if (section == 3)
    return 1;
  else if (section == 4)
    return 1;
  else if (section == 5) {
    if ([similarResidences count] > 0) {
      return [similarResidences count] + 1;
    }
    else {
      return 0;
    }
  }
  return 0;
}

#pragma mark - Protocol UITableViewDelegate

- (void) tableView: (UITableView *) tableView
didSelectRowAtIndexPath: (NSIndexPath *) indexPath
{
  if (indexPath.section == 5) {
    if (indexPath.row > 0) {
      OMBResidenceDetailViewController *vc = 
        [[OMBResidenceDetailViewController alloc] initWithResidence: 
          [similarResidences objectAtIndex: (indexPath.row - 1)]];
      [self.navigationController pushViewController: vc animated: YES];
    }
  }
}

- (CGFloat) tableView: (UITableView *) tableView 
heightForFooterInSection: (NSInteger) section
{
  if (section == 0 || section == 1 || section == 2 || section == 3 
    || section == 4)
    return kResidenceDetailPaddingDouble;
  return 0;
}

- (CGFloat) tableView: (UITableView *) tableView
heightForRowAtIndexPath: (NSIndexPath *) indexPath
{
  // Image scroll and info view
  if (indexPath.section == 0) {
    // Image scroll
    if (indexPath.row == 0) {
      return _imagesScrollView.frame.size.height;
    }
    // Info view
    if (indexPath.row == 1) {
      return _infoView.frame.size.height;
    }
  }
  else if (indexPath.section == 1) {
    if (indexPath.row == 0)
      return _availableView.frame.size.height;
  }
  else if (indexPath.section == 2) {
    if (indexPath.row == 0)
      return _leaseMonthView.frame.size.height;
  }
  else if (indexPath.section == 3) {
    if (indexPath.row == 0)
      return _descriptionView.frame.size.height;
  }
  else if (indexPath.section == 4) {
    if (indexPath.row == 0)
      return _map.frame.size.height;
  }
  else if (indexPath.section == 5) {
    if (indexPath.row == 0)
      return _similarResidencesView.frame.size.height;
    else {
      CGRect screen = [[UIScreen mainScreen] bounds];
      return (screen.size.height * 0.3) + 1;
    }
  }
  return 0;
}

- (UIView *) tableView: (UITableView *) tableView 
viewForFooterInSection: (NSInteger) section
{
  CGRect screen = [[UIScreen mainScreen] bounds];
  UIView *footerView = [[UIView alloc] init];
  if (section == 0 || section == 1 || section == 2 || section == 3 
    || section == 4)
    footerView.frame = CGRectMake(0, 0, screen.size.width, 
      kResidenceDetailPaddingDouble);
  return footerView;
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) addImageViewsToImageScrollView
{
  // Add imageViews to _imagesScrollView from _imagesViewArray
  // and then set the _imagesScrollView content size
  for (UIImageView *imageView in _imageViewArray) {
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

- (void) addSimilarResidence: (OMBResidence *) object
{
  [similarResidences addObject: object];
  [_table reloadSections: [NSIndexSet indexSetWithIndex: 5] 
    withRowAnimation: UITableViewRowAnimationTop];
}

- (void) addToFavoritesButtonSelected
{
  NSLog(@"Add to favorites");
}

- (void) contactButtonSelected
{
  NSLog(@"Contact");
}

- (int) currentPageOfImages
{
  return (1 + 
    _imagesScrollView.contentOffset.x / _imagesScrollView.frame.size.width);
}

- (void) refreshResidenceData
{
  [_table beginUpdates];
  // Square feet
  _squareFeetLabel.text = [NSString stringWithFormat: @"%i", 
    residence.squareFeet];
  // Available on
  _availableLabel.text = [residence availableOnString];
  // Lease months
  if (residence.leaseMonths)
    _leaseMonthLabel.text = [NSString stringWithFormat: @"%i months", 
      residence.leaseMonths];
  else
    _leaseMonthLabel.text = @"Multiple";
  // Description
  if ([residence.description length] > 0)
    _descriptionLabel.text = residence.description;
  CGSize descriptionMaxSize = CGSizeMake((_descriptionView.frame.size.width - 
    (_descriptionLabel.frame.origin.x * 2)), 5000);
  CGRect descriptionRect = [_descriptionLabel.text boundingRectWithSize: 
    descriptionMaxSize options: NSStringDrawingUsesLineFragmentOrigin 
      attributes: @{NSFontAttributeName: _descriptionLabel.font} context: nil];
  _descriptionLabel.frame = CGRectMake(_descriptionLabel.frame.origin.x,
    _descriptionLabel.frame.origin.y, _descriptionLabel.frame.size.width,
      descriptionRect.size.height);
  _descriptionView.frame = CGRectMake(_descriptionView.frame.origin.x,
    _descriptionView.frame.origin.y, _descriptionView.frame.size.width,
      (27 + (kResidenceDetailPaddingDouble * 2) + 
        _descriptionLabel.frame.size.height));
  descriptionBorderBottom.frame = CGRectMake(
    descriptionBorderBottom.frame.origin.x, 
      (_descriptionView.frame.size.height - 
        descriptionBorderBottom.frame.size.height), 
          descriptionBorderBottom.frame.size.width, 
            descriptionBorderBottom.frame.size.height);
  [_table endUpdates];
}

- (void) resetImageViews
{
  // Remove UIImageView from _imagesScrollView
  [_imagesScrollView.subviews enumerateObjectsUsingBlock: 
    ^(UIImageView *imageView, NSUInteger idx, BOOL *stop) {
      [imageView removeFromSuperview];
    }
  ];
  // Empty out any UIImageView from the _imageViewArray
  [_imageViewArray removeAllObjects];
}

- (void) showImageSlideViewController
{
  [self presentViewController: _imageSlideViewController animated: YES
    completion: nil];
}

@end
