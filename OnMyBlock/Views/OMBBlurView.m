//
//  OMBBlurView.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 1/27/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBBlurView.h"

#import "UIImage+ImageEffects.h"

@implementation OMBBlurView

- (id) initWithFrame: (CGRect) rect
{
  if (!(self = [super initWithFrame: rect])) return nil;

  _imageView = [[UIImageView alloc] initWithFrame: rect];
  // _imageView.clipsToBounds = YES;
  // _imageView.contentMode   = UIViewContentModeScaleAspectFill;
  [self addSubview: _imageView];

  return self;
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) refreshWithImage: (UIImage *) image
{
  // Create the image context
  UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 
    self.window.screen.scale);

  // There he is! The new API method
  [self drawViewHierarchyInRect: self.frame afterScreenUpdates: NO];

  // Blur Radius = how blurry
  // Average 20
  
  // Low saturation is less color
  // High saturation is more intense color
  // Average saturation is 1.8
  UIImage *blurredSnapshotImage = [image applyBlurWithRadius: 
    _blurRadius tintColor: _tintColor saturationDeltaFactor: 1.5
      maskImage: nil];

  // Be nice and clean your mess up
  UIGraphicsEndImageContext();

  _imageView.image = blurredSnapshotImage;
}

- (void) refreshWithView: (UIView *) view
{
  // Create the image context
  UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, 
    view.window.screen.scale);

  // There he is! The new API method
  [view drawViewHierarchyInRect: view.frame afterScreenUpdates: NO];

  // Get the snapshot
  UIImage *snapshotImage = UIGraphicsGetImageFromCurrentImageContext();

  UIImage *blurredSnapshotImage = [snapshotImage applyBlurWithRadius: 
    _blurRadius tintColor: _tintColor saturationDeltaFactor: 1.8 
      maskImage: nil];

  // Be nice and clean your mess up
  UIGraphicsEndImageContext();

  _imageView.image = blurredSnapshotImage;
}

@end
