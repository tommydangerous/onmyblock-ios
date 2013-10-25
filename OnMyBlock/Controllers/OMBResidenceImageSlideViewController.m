//
//  OMBResidenceImageSlideViewController.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 10/25/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBResidenceImageSlideViewController.h"

#import "UIColor+Extensions.h"

@implementation OMBResidenceImageSlideViewController

@synthesize imageSlideScrollView  = _imageSlideScrollView;

#pragma mark - Override

#pragma mark - Override UIViewController

- (void) loadView
{
  [super loadView];

  CGRect screen = [[UIScreen mainScreen] bounds];

  self.view = [[UIView alloc] init];
  self.view.frame = screen;

  // Image slide scroll view
  _imageSlideScrollView = [[UIScrollView alloc] init];
  _imageSlideScrollView.bounces = NO;
  _imageSlideScrollView.contentSize = CGSizeMake((screen.size.width * 2),
    screen.size.height);
  _imageSlideScrollView.frame = screen;
  _imageSlideScrollView.pagingEnabled = YES;
  [self.view addSubview: _imageSlideScrollView];

  int i = 0;
  while (i < 2) {
    UIScrollView *scroll = [[UIScrollView alloc] init];
    scroll.delegate = self;
    scroll.frame = CGRectMake((i * screen.size.width), 0, 
      screen.size.width, screen.size.height);
    scroll.backgroundColor = [UIColor blackColor];
    [_imageSlideScrollView addSubview: scroll];

    UIImageView *imageView = [[UIImageView alloc] init];
    UIImage *image  = [UIImage imageNamed: @"background.png"];
    imageView.image = image;
    imageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    [scroll addSubview: imageView];

    scroll.minimumZoomScale = screen.size.width / image.size.width;
    scroll.maximumZoomScale = 1.0;
    scroll.showsHorizontalScrollIndicator = NO;
    scroll.showsVerticalScrollIndicator   = NO;
    scroll.zoomScale = scroll.minimumZoomScale;
    i += 1;
  }

  // Close button
  UIButton *button = [[UIButton alloc] init];
  button.backgroundColor = [UIColor clearColor];
  button.titleLabel.font = [UIFont fontWithName: @"HelveticaNeue-Light" 
    size: 18];
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
    (20 + 10), (buttonSize.width + 20), (buttonSize.height + 20));
}

#pragma mark - Protocol

#pragma mark - Protocol UIScrollViewDelegate

- (void) scrollViewDidZoom: (UIScrollView *) scrollView
{
  int index = [scrollView.subviews indexOfObjectPassingTest: 
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
  int index = [scrollView.subviews indexOfObjectPassingTest: 
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
  [self dismissViewControllerAnimated: YES completion: ^{
    for (UIView *v in _imageSlideScrollView.subviews) {
      if ([v isKindOfClass: [UIScrollView class]]) {
        UIScrollView *scroll = (UIScrollView *) v;
        scroll.zoomScale     = scroll.minimumZoomScale;
      }
    }
  }];
}

@end
