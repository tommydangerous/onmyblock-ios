//
//  UIImage+Resize.m
//  Bite
//
//  Created by Tommy DANGerous on 5/15/13.
//  Copyright (c) 2013 Quantum Ventures. All rights reserved.
//

#import "UIImage+Resize.h"

CGFloat const MIN_RESOLUTION        = 640.0f * 320.0f;
CGFloat const MAX_IMAGE_UPLOAD_SIZE = 500 * 1000.0f; // 500kbs

@implementation UIImage (Resize)

#pragma mark - Methods

+ (NSData *) compressImage: (UIImage *) image
withMinimumResolution: (CGFloat) resolution
{
  if (resolution < MIN_RESOLUTION)
    resolution = MIN_RESOLUTION;

  //Resize the image 
  CGFloat factor = 1.0f;
  CGFloat imageResolution = image.size.height * image.size.width;
  if (imageResolution > resolution) {
    factor = sqrt(imageResolution / resolution)*2;
    image  = [UIImage image: image proportionatelySized: 
      CGSizeMake(image.size.width/factor, image.size.height/factor)];
  }
  CGFloat compression = 0.9f;
  CGFloat maxCompression = 0.1f;
  NSData *imageData = UIImageJPEGRepresentation(image, compression);
  while ([imageData length] > MAX_IMAGE_UPLOAD_SIZE && 
    compression > maxCompression) {
    
    compression -= 0.10f;
    imageData = UIImageJPEGRepresentation(image, compression);
    NSLog(@"COMPRESS: %d", imageData.length);
  }
  return imageData;
}

+ (UIImage *) image: (UIImage *) image proportionatelySized: (CGSize) size
{
  CGFloat newHeight = 0.0f;
  CGFloat newWidth  = 0.0f;
  CGPoint point     = CGPointZero;
  if (image.size.height > image.size.width) {
    CGFloat ratio = size.width / image.size.width;
    newHeight = image.size.height * ratio;
    newWidth  = size.width;
    // if (newHeight > size.height)
    //   point.y = (newHeight - size.height) * -0.5f;
    // else if (size.height > newHeight)
    //   point.y = (size.height - newHeight) * 0.5f;
  }
  else {
    CGFloat ratio = size.height / image.size.height;
    newHeight = size.height;
    newWidth  = image.size.width * ratio;
    // point.x = (newWidth - size.width) * -0.5f;
  }
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
