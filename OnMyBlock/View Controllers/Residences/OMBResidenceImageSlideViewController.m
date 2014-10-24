//
//  OMBResidenceImageSlideViewController.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 10/25/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBResidenceImageSlideViewController.h"

#import "OMBImageScrollView.h"
#import "OMBResidence.h"
#import "OMBResidenceDetailViewController.h"
#import "OMBResidenceImage.h"
#import "UIColor+Extensions.h"

@implementation OMBResidenceImageSlideViewController

@synthesize imageSlideScrollView  = _imageSlideScrollView;
@synthesize residenceDetailViewController = _residenceDetailViewController;

#pragma mark - Initializer

- (id) initWithResidence: (OMBResidence *) object
{
  if (!(self = [super init])) return nil;

  residence = object;
  self.screenName = [NSString stringWithFormat:
    @"Residence Images Slide View Controller - Residence ID: %i",
      residence.uid];

  return self;
}

#pragma mark - Override

#pragma mark - Override UIViewController

- (void) loadView
{
  [super loadView];

  CGRect screen = [[UIScreen mainScreen] bounds];

  self.view = [[UIView alloc] initWithFrame: screen];
  self.view.backgroundColor = [UIColor clearColor];

  // Image slide scroll view
  _imageSlideScrollView               = [[UIScrollView alloc] init];
  _imageSlideScrollView.bounces       = NO;
  _imageSlideScrollView.delegate      = self;
  _imageSlideScrollView.frame         = screen;
  _imageSlideScrollView.pagingEnabled = YES;
  [self.view addSubview: _imageSlideScrollView];

  // Close button
  UIButton *button = [[UIButton alloc] init];
  button.backgroundColor = [UIColor clearColor];
  button.titleLabel.font = [UIFont fontWithName: @"HelveticaNeue-Light" 
    size: 15];
  [button addTarget: self action: @selector(close) 
    forControlEvents: UIControlEventTouchUpInside];
  [button setTitle: @"Close" forState: UIControlStateNormal];
  [button setTitleColor: [UIColor whiteColor] forState: UIControlStateNormal];
  [button setTitleColor: [UIColor blue] forState: UIControlStateHighlighted];
  [self.view addSubview: button];
  CGSize buttonSize = [button.currentTitle sizeWithAttributes: @{
    NSFontAttributeName: button.titleLabel.font
  }];
  button.frame = CGRectMake((screen.size.width - (buttonSize.width + 20)), 
    20, (buttonSize.width + 20), (buttonSize.height + 20));
}

- (void) viewWillAppear: (BOOL) animated
{
  [super viewWillAppear: animated];

  CGRect screen = [[UIScreen mainScreen] bounds];

  NSArray *array = [residence imagesArray];
  for (OMBResidenceImage *residenceImage in array) {
    OMBImageScrollView *scroll = [[OMBImageScrollView alloc] init];
    scroll.backgroundColor     = [UIColor blackColor];
    scroll.delegate            = self;
    scroll.frame = CGRectMake(
      ([array indexOfObject: residenceImage] * screen.size.width), 0,
        screen.size.width, screen.size.height);
    [_imageSlideScrollView addSubview: scroll];

    UIImage *image         = residenceImage.image;
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    imageView.image = image;
    [scroll addSubview: imageView];

    scroll.minimumZoomScale = screen.size.width / image.size.width;
    scroll.maximumZoomScale = 1.0;
    scroll.showsHorizontalScrollIndicator = NO;
    scroll.showsVerticalScrollIndicator   = NO;
    scroll.zoomScale = scroll.minimumZoomScale;
  }
  _imageSlideScrollView.contentSize = CGSizeMake(
    (screen.size.width * [array count]), screen.size.height);

  // Adjust the content offset depending on the residence detail current page
  // CGPoint point = CGPointMake(
  //   (_imageSlideScrollView.frame.size.width * 
  //     ([_residenceDetailViewController currentPageOfImages] - 1)), 0);
  // [_imageSlideScrollView setContentOffset: point animated: NO];
}

- (void) viewWillDisappear: (BOOL) animated
{
  [super viewWillDisappear: animated];

  [self removeAllImages];
}

#pragma mark - Protocol

#pragma mark - Protocol UIScrollViewDelegate

- (void) scrollViewDidEndDecelerating: (UIScrollView *) scrollView
{
  if (scrollView == _imageSlideScrollView) {
    // [_residenceDetailViewController setContentOffsetForImageCollectionView:
    //   scrollView.contentOffset.x / scrollView.frame.size.width];
  }
}

- (void) scrollViewDidZoom: (UIScrollView *) scrollView
{
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

- (UIView *) viewForZoomingInScrollView: (UIScrollView *) scrollView
{
  NSUInteger index = [scrollView.subviews indexOfObjectPassingTest:
    ^(id obj, NSUInteger idx, BOOL *stop) {
      return [obj isKindOfClass: [UIImageView class]];
    }
  ];
  if (index != NSNotFound)
    return [scrollView.subviews objectAtIndex: index];
  return nil;
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) close
{
  [UIView animateWithDuration: 0.25f animations: ^{
    self.view.alpha = 0.0f;
  } completion: ^(BOOL finished) {
    [self dismissViewControllerAnimated: NO completion: ^{
      for (UIView *v in _imageSlideScrollView.subviews) {
        if ([v isKindOfClass: [UIScrollView class]]) {
          UIScrollView *scroll = (UIScrollView *) v;
          scroll.zoomScale     = scroll.minimumZoomScale;
        }
      }
    }];
  }];
}

- (void) removeAllImages
{
  [_imageSlideScrollView.subviews enumerateObjectsUsingBlock: 
    ^(UIView *v, NSUInteger idx, BOOL *stop) {
      [v removeFromSuperview];
    }
  ];
}

@end
