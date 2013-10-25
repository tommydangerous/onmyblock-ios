//
//  OMBResidenceDetailViewController.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 10/21/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBResidenceDetailViewController.h"

#import "OMBResidence.h"
#import "OMBResidenceImagesConnection.h"
#import "OMBResidenceImageSlideViewController.h"
#import "UIColor+Extensions.h"
#import "UIImage+Resize.h"

@implementation OMBResidenceDetailViewController

@synthesize imagesScrollView = _imagesScrollView;
@synthesize imageSlideViewController = _imageSlideViewController;
@synthesize imageViewArray   = _imageViewArray;

#pragma mark - Initializer

- (id) initWithResidence: (OMBResidence *) object
{
  if (!(self = [super init])) return nil;

  _imageSlideViewController = 
    [[OMBResidenceImageSlideViewController alloc] init];
  _imageSlideViewController.modalTransitionStyle = 
    UIModalTransitionStyleCrossDissolve;
  residence  = object;
  self.title = [residence.address capitalizedString];

  return self;
}

#pragma mark - Override

#pragma mark - Override UIViewController

- (void) loadView
{
  [super loadView];

  _imageViewArray = [NSMutableArray array];
  subviews        = [NSMutableArray array];

  CGRect screen = [[UIScreen mainScreen] bounds];
  
  mainScrollView = [[UIScrollView alloc] init];
  mainScrollView.alwaysBounceVertical = YES;
  mainScrollView.backgroundColor = [UIColor blackColor];
  mainScrollView.delegate = self;
  mainScrollView.frame = screen;
  self.view = mainScrollView;

  // Images scrolling view; image slides
  _imagesScrollView = [[UIScrollView alloc] init];
  _imagesScrollView.backgroundColor = [UIColor grayLight];
  _imagesScrollView.delegate = self;
  _imagesScrollView.frame = CGRectMake(0, 0, screen.size.width, 
    (screen.size.height * 0.4));
  _imagesScrollView.pagingEnabled = YES;
  _imagesScrollView.showsHorizontalScrollIndicator = NO;
  [subviews addObject: _imagesScrollView];

  UITapGestureRecognizer *tapGesture = 
    [[UITapGestureRecognizer alloc] initWithTarget: self 
      action: @selector(showImageSlideViewController)];
  [_imagesScrollView addGestureRecognizer: tapGesture];

  // Add all views to scroll view
  float totalHeightSize = 0;
  for (UIView *v in subviews) {
    totalHeightSize += v.frame.size.height;
    [mainScrollView addSubview: v];
  }
  // Set scroll view's content size
  mainScrollView.contentSize = CGSizeMake(mainScrollView.frame.size.width, 
    totalHeightSize);
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
