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

- (id) init
{
  if (!(self = [self initWithFrame: CGRectZero])) return nil;

  return self;
}

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

- (void) clearImage
{
  _image = nil;
  _imageView.image = nil;
}

- (void) setFrame: (CGRect) rect
{
  [super setFrame: rect];
  height = self.frame.size.height;
  width  = self.frame.size.width;
  if (_image)
    [self setImage: _image];
}

- (void) setFrame: (CGRect) rect redrawImage: (BOOL) redraw
{
  [super setFrame: rect];
  height = self.frame.size.height;
  width  = self.frame.size.width;
  if (redraw && _image)
    [self setImage: _image];
}

- (void) setImage: (UIImage *) object
{
  _image = object;
  if (!_image) {
    return;
  }
  // Don't do anything if the image size is the same
  else if (height == _image.size.height && width == _image.size.width) {
    _imageView.image = _image;
    _imageView.frame = CGRectMake(0.0f, 0.0f, width, height);
    return;
  }
  CGFloat newHeight = height;
  CGFloat newWidth  = _image.size.width * (height / _image.size.height);
  if (newWidth < width) {
    newHeight = newHeight * (width / newWidth);
    newWidth  = width;
  }
  CGPoint point = CGPointZero;
  // Center it vertically
  if (newHeight > height) {
    point.y = (newHeight - height) * -0.5;
  }
  // Center it horizontally
  if (newWidth > width) {
    point.x = (newWidth - width) * -0.5;
  }
  _imageView.image = [UIImage image: _image 
    size: CGSizeMake(newWidth, newHeight) point: point];
  _imageView.frame = CGRectMake(0.0f, 0.0f, newWidth, newHeight);
}

- (void) setImage1: (UIImage *) object
{
  _image = object;
  float imageHeight      = _image.size.height;
  float imageWidth       = _image.size.width;
  float aspectRatio      = width / height;
  float imageAspectRatio = imageWidth / imageHeight;
  float newAspectRatio, newHeight, newWidth;
  CGPoint point = CGPointZero;
  if (aspectRatio > imageAspectRatio) {
    if (height > imageHeight || width > imageWidth) {
      newAspectRatio = height / imageHeight;  
    }
    else {
      newAspectRatio = width / imageWidth;
    }
    newHeight = height;
    newWidth  = height * newAspectRatio;
    // Center horizontally
    point = CGPointMake((width - newWidth) * 0.5f, 0.0f);
  }
  else {
    if (height > imageHeight || width > imageWidth) {
      newAspectRatio = width / imageWidth;
    }
    else {
      newAspectRatio = height / imageHeight;
    }
    newHeight = width * newAspectRatio;
    newWidth  = width;
    // Center vertically
    point = CGPointMake(0.0f, (height - newHeight) * 0.5f);
  }
  _imageView.image = [UIImage image: _image
    size: CGSizeMake(newWidth, newHeight)];
  _imageView.frame = CGRectMake(point.x, point.y, newWidth, newHeight);
}

- (void) setImage3: (UIImage *) object
{
  NSLog(@"NEED FIXING");
  _image = object;
  float imageHeight      = _image.size.height;
  float imageWidth       = _image.size.width;
  float aspectRatio      = width / height;
  float imageAspectRatio = imageWidth / imageHeight;
  float newHeight, newWidth; 
  if (aspectRatio > imageAspectRatio) {
    newHeight = width * imageAspectRatio;
    newWidth  = width;
    _imageView.image = [UIImage image: _image
      size: CGSizeMake(newWidth, newHeight)];
    // Center vertically
    _imageView.frame = CGRectMake(0.0f, ((height - newHeight) * 0.5), 
      newWidth, newHeight);
  }
  else {
    newHeight = height;
    newWidth  = height * imageAspectRatio;
    _imageView.image = [UIImage image: _image
      size: CGSizeMake(newWidth, newHeight)];
    // Center horizontally
    _imageView.frame = CGRectMake(((width - newWidth) * 0.5), 0.0f,
      newWidth, newHeight);
  }
}

- (void) setImage2: (UIImage *) object
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
    NSLog(@"1");
  }
  // If the image's width is larger than the image's height
  else if (imageWidth > imageHeight) {
    aspectRatio = imageWidth / imageHeight;
    newHeight   = height;
    newWidth    = height * aspectRatio;
    _imageView.image = [UIImage image: _image 
      size: CGSizeMake(newWidth, newHeight)];
    _imageView.frame = CGRectMake(((width - newWidth) * 0.5), 0.0f,
      newWidth, newHeight);
    NSLog(@"2");
  }
  // If the image is a square
  else {
    // If the frame's height is greater than the width
    if (height > width) {
      newHeight = height;
      newWidth  = height;
      _imageView.image = [UIImage image: _image
        size: CGSizeMake(newWidth, newHeight)];
      _imageView.frame = CGRectMake((width - newWidth) * 0.5, 
        0.0f, newWidth, newHeight);
      NSLog(@"3");
    }
    // If the frame's width is greater than the height
    else {
      newHeight = width;
      newWidth  = width;
      _imageView.image = [UIImage image: _image
        size: CGSizeMake(newWidth, newHeight)];
      _imageView.frame = CGRectMake(0.0f, 
        (height - newHeight) * 0.5, newWidth, newHeight);
      NSLog(@"WIDTH: %f", newWidth);
    }
  }
}

@end
