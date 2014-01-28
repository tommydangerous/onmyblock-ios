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

  imageView = [[UIImageView alloc] initWithFrame: rect];
  [self addSubview: imageView];

  return self;
}

#pragma mark - Methods

#pragma mark - Instance Methods

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

  imageView.image = blurredSnapshotImage;
}

@end
