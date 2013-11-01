//
//  OMBImageScrollView.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 11/1/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBImageScrollView.h"

@implementation OMBImageScrollView

@synthesize imageView = _imageView;

#pragma mark - Initializer

- (id) init
{
  if (!(self = [super init])) return nil;

  UITapGestureRecognizer *tapGestureRecognizer =
    [[UITapGestureRecognizer alloc] initWithTarget: self 
      action: @selector(toggleZoom)];
  tapGestureRecognizer.numberOfTapsRequired = 2;
  [self addGestureRecognizer: tapGestureRecognizer];

  return self;
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) toggleZoom
{
  CGFloat zoom = self.minimumZoomScale;
  // If not zoomed in all the way
  if (self.zoomScale < self.maximumZoomScale)
    // Zoom in all the way
    zoom = self.maximumZoomScale;
  [self setZoomScale: zoom animated: YES];
}

@end
