//
//  OMBButtonWithImage.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 1/29/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBButtonWithImage.h"

#import "OMBViewController.h"
#import "UIImage+Resize.h"

@implementation OMBButtonWithImage

#pragma mark - Initializer

- (id) initWithFrame: (CGRect) rect
{
  if (!(self = [super initWithFrame: rect])) return nil;

  self.clipsToBounds   = YES;

  CGFloat imageSize = self.frame.size.height - OMBPadding;
  imageView = [UIImageView new];
  imageView.frame = CGRectMake(OMBPadding * 0.5f,
    (self.frame.size.height - imageSize) * 0.5f,
      imageSize, imageSize);
  [self addSubview: imageView];

  self.titleEdgeInsets = UIEdgeInsetsMake(0.0f, imageSize, 0.0f, 0.0f);

  return self;
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) setImage: (UIImage *) image
{
  CGFloat imageSize = self.frame.size.height - OMBPadding;
  imageView.image = [UIImage image: image 
    size: CGSizeMake(imageSize, imageSize)];
}

@end
