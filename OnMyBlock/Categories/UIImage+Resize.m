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

@end
