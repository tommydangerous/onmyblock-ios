//
//  OMBResidenceDetailViewController.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 10/21/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "OMBResidenceDetailViewController.h"

#import "OMBResidence.h"
#import "OMBResidenceImagesConnection.h"
#import "OMBResidenceImageSlideViewController.h"
#import "UIColor+Extensions.h"
#import "UIImage+Resize.h"

@implementation OMBResidenceDetailViewController

@synthesize addressLabel             = _addressLabel;
@synthesize addToFavoritesButton     = _addToFavoritesButton;
@synthesize imagesScrollView         = _imagesScrollView;
@synthesize imageSlideViewController = _imageSlideViewController;
@synthesize imageViewArray           = _imageViewArray;
@synthesize infoView                 = _infoView;
@synthesize pageOfImagesLabel        = _pageOfImagesLabel;
@synthesize rentLabel                = _rentLabel;
@synthesize table                    = _table;

#pragma mark - Initializer

- (id) initWithResidence: (OMBResidence *) object
{
  if (!(self = [super init])) return nil;

  residence  = object;
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

  _table = [[UITableView alloc] init];
  _table.alwaysBounceVertical = YES;
  _table.backgroundColor      = [UIColor redColor];
  _table.dataSource           = self;
  _table.delegate             = self;
  _table.frame                = screen;
  _table.separatorColor       = [UIColor clearColor];
  _table.separatorStyle       = UITableViewCellSeparatorStyleNone;
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

  // Info view
  _infoView = [[UIView alloc] init];
  _infoView.backgroundColor = [UIColor blueColor];
  _infoView.frame = CGRectMake(0, 0, screen.size.width, 200);
  // Rent label
  _rentLabel = [[UILabel alloc] init];
  _rentLabel.backgroundColor = [UIColor yellowColor];
  _rentLabel.font = [UIFont fontWithName: @"HelveticaNeue-Light" size: 36];
  _rentLabel.frame = CGRectMake(10, 10, (screen.size.width - 20), 54);
  _rentLabel.textColor = [UIColor textColor];
  [_infoView addSubview: _rentLabel];
  // Add to favorites button
  _addToFavoritesButton = [[UIButton alloc] init];
  _addToFavoritesButton.backgroundColor = [UIColor blue];
  _addToFavoritesButton.frame = CGRectMake((screen.size.width - (70 + 10)), 
    _rentLabel.frame.origin.y, 70, 50);
  _addToFavoritesButton.layer.cornerRadius = 2.0;
  UIImage *favoriteImage = 
    [UIImage image: [UIImage imageNamed: @"favorite.png"] 
      size: CGSizeMake(30, 30)];
  [_addToFavoritesButton setImage: favoriteImage 
    forState: UIControlStateNormal];
  [_infoView addSubview: _addToFavoritesButton];
  // Address label
  _addressLabel = [[UILabel alloc] init];
  _addressLabel.backgroundColor = [UIColor yellowColor];
  _addressLabel.font = [UIFont fontWithName: @"HelveticaNeue-Light" size: 18];
  _addressLabel.frame = CGRectMake(10, 
    (_rentLabel.frame.origin.y + _rentLabel.frame.size.height), 
      (screen.size.width - 20), 27);
  _addressLabel.textColor = [UIColor textColor];
  [_infoView addSubview: _addressLabel];
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
      imageView.image           = [UIImage image: image size:
        CGSizeMake(_imagesScrollView.frame.size.width,
          _imagesScrollView.frame.size.height)];
      [_imageViewArray addObject: imageView];
    }
    [self addImageViewsToImageScrollView];
    _pageOfImagesLabel.text = [NSString stringWithFormat: @"%i/%i",
      [self currentPageOfImages], [[residence imagesArray] count]];
  }
  // If images were not downloaded for the residence,
  // download the images and add the image view and image to images scroll view
  else {
    OMBResidenceImagesConnection *connection = 
      [[OMBResidenceImagesConnection alloc] initWithResidence: residence];
    connection.delegate = self;
    [connection start];
  }
}

- (void) viewWillAppear: (BOOL) animated
{
  [super viewWillAppear: animated];

  // Rent
  _rentLabel.text = [NSString stringWithFormat: @"%@", 
    [residence rentToCurrencyString]];
  // Address
  _addressLabel.text = residence.address;
}

#pragma mark - Protocol

#pragma mark - Protocol UIScrollViewDelegate

- (void) scrollViewDidEndDecelerating: (UIScrollView *) scrollView
{
  if (scrollView == _imagesScrollView) {
    _pageOfImagesLabel.text = [NSString stringWithFormat: @"%i/%i",
      [self currentPageOfImages], [[residence imagesArray] count]];
  }
}

- (void) scrollViewDidScroll: (UIScrollView *) scrollView
{

}

#pragma mark - Protocol UITableViewDataSource

- (UITableViewCell *) tableView: (UITableView *) tableView 
cellForRowAtIndexPath: (NSIndexPath *) indexPath
{
  UITableViewCell *cell = [[UITableViewCell alloc] init];
  // Image scroll
  if (indexPath.row == 0) {
    [cell.contentView addSubview: _imagesScrollView];

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
    [cell.contentView addSubview: _pageOfImagesLabel];
  }
  else if (indexPath.row == 1) {
    [cell.contentView addSubview: _infoView];
  }
  NSLog(@"%i", [cell.contentView.subviews count]);
  return cell;
}

- (NSInteger) tableView: (UITableView *) tableView
numberOfRowsInSection: (NSInteger) section
{
  return 5;
}

#pragma mark - Protocol UITableViewDelegate

- (CGFloat) tableView: (UITableView *) tableView
heightForRowAtIndexPath: (NSIndexPath *) indexPath
{
  // Image scroll
  if (indexPath.row == 0) {
    return _imagesScrollView.frame.size.height;
  }
  if (indexPath.row == 1) {
    return _infoView.frame.size.height;
  }
  return 0;
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

- (int) currentPageOfImages
{
  return (1 + 
    _imagesScrollView.contentOffset.x / _imagesScrollView.frame.size.width);
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
