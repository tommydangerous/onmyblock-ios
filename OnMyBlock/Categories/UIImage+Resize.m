//
//  UIImage+Resize.m
//  Bite
//
//  Created by Tommy DANGerous on 5/15/13.
//  Copyright (c) 2013 Quantum Ventures. All rights reserved.
//

#import "UIImage+Resize.h"

@implementation UIImage (Resize)

#pragma mark - Methods

+ (UIImage *) image: (UIImage *) image proportionatelySized: (CGSize) size
{
  float newHeight, newWidth;
  if (image.size.width < image.size.height) {
    newHeight = size.height;
    newWidth  = (newHeight / image.size.height) * image.size.width;
  }
  else {
    newWidth  = size.width;
    newHeight = (newWidth / image.size.width) * image.size.height;
  }
  CGPoint point = CGPointMake(0, 0);
  // Center it horizontally
  if (newWidth > size.width)
    point.x = (newWidth - size.width) / -2.0;
  // Center it vertically
  if (newHeight > size.height)
    point.y = (newHeight - size.height) / -2.0;
  return [UIImage image: image size: CGSizeMake(newWidth, newHeight) 
    point: point];
}

+ (UIImage *) image: (UIImage *) image size: (CGSize) size
{
  // Create a bitmap context
  UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
  [image drawInRect: CGRectMake(0, 0, size.width, size.height)];
  UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  return newImage;
}

+ (UIImage *) image: (UIImage *) image size: (CGSize) size 
point: (CGPoint) point
{
  // Create a bitmap context
  UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
  [image drawInRect: CGRectMake(point.x, point.y, size.width, size.height)];
  UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  return newImage;
}

+ (UIImage *) image: (UIImage *) image sizeToFitVertical: (CGSize) size
{
  float newHeight = size.height;
  float newWidth  = (newHeight / image.size.height) * image.size.width;
  CGPoint point = CGPointMake(0, 0);
  // Center it horizontally
  if (newWidth > size.width)
    point.x = (newWidth - size.width) / -2.0;
  // Center it vertically
  if (newHeight > size.height)
    point.y = (newHeight - size.height) / -2.0;
  return [UIImage image: image size: CGSizeMake(newWidth, newHeight) 
    point: point];
}

@end
