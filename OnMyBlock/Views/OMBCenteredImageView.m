//
//  OMBCenteredImageView.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 11/29/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBCenteredImageView.h"

#import "UIImage+Resize.h"

@implementation OMBCenteredImageView

@synthesize image     = _image;
@synthesize imageView = _imageView;

#pragma mark - Initializer

- (id) initWithFrame: (CGRect) rect
{
  if (!(self = [super initWithFrame: rect])) return nil;

  self.clipsToBounds = YES;
  height             = self.frame.size.height;
  width              = self.frame.size.width;

  _imageView = [[UIImageView alloc] init];
  [self addSubview: _imageView];

  return self;
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) setFrame: (CGRect) rect
{
  [super setFrame: rect];
  height = self.frame.size.height;
  width  = self.frame.size.width;
}

- (void) setImage: (UIImage *) object
{
  _image = object;
  float imageHeight = _image.size.height;
  float imageWidth  = _image.size.width;
  float aspectRatio, newHeight, newWidth;
  // If the image's height is larger than the image's width
  if (imageHeight > imageWidth) {
    // Scale the image's width to fit the frame's width
    // and center the image view vertically

    // Divide the larger dimension by the smaller dimension
    aspectRatio = imageHeight / imageWidth;
    newHeight   = width * aspectRatio;
    newWidth    = width;
    _imageView.image = [UIImage image: _image 
      size: CGSizeMake(newWidth, newHeight)];
    _imageView.frame = CGRectMake(0.0f, ((height - newHeight) * 0.5), 
      newWidth, newHeight);  
  }
  // If the image's width is larger than the image's height
  else {
    aspectRatio = imageWidth / imageHeight;
    newHeight   = height;
    newWidth    = height * aspectRatio;
    _imageView.image = [UIImage image: _image 
      size: CGSizeMake(newWidth, newHeight)];
    _imageView.frame = CGRectMake(((width - newWidth) * 0.5), 0.0f,
      newWidth, newHeight);
  }
}

@end
