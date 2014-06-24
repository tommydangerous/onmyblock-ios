//
//  UIImage+Resize.h
//  Bite
//
//  Created by Tommy DANGerous on 5/15/13.
//  Copyright (c) 2013 Quantum Ventures. All rights reserved.
//

#import <UIKit/UIKit.h>

extern CGFloat const MIN_RESOLUTION;
extern CGFloat const MAX_IMAGE_UPLOAD_SIZE;

@interface UIImage (Resize)

#pragma mark - Methods

+ (NSData *) compressImage: (UIImage *) image
  withMinimumResolution: (CGFloat) resolution;
+ (UIImage *) image: (UIImage *) image proportionatelySized: (CGSize) size;
+ (UIImage *) image: (UIImage *) image size: (CGSize) size;
+ (UIImage *) image: (UIImage *) image size: (CGSize) size 
point: (CGPoint) point;
+ (UIImage *) image: (UIImage *) image sizeToFitVertical: (CGSize) size;

// - (UIImage *)croppedImage:(CGRect)bounds;
// - (UIImage *)thumbnailImage:(NSInteger)thumbnailSize
//           transparentBorder:(NSUInteger)borderSize
//                cornerRadius:(NSUInteger)cornerRadius
//        interpolationQuality:(CGInterpolationQuality)quality;
// - (UIImage *)resizedImage:(CGSize)newSize
//      interpolationQuality:(CGInterpolationQuality)quality;
// - (UIImage *)resizedImageWithContentMode:(UIViewContentMode)contentMode
//                                   bounds:(CGSize)bounds
//                     interpolationQuality:(CGInterpolationQuality)quality;
// - (UIImage *)resizedImage:(CGSize)newSize
//                 transform:(CGAffineTransform)transform
//            drawTransposed:(BOOL)transpose
//      interpolationQuality:(CGInterpolationQuality)quality;
// - (CGAffineTransform)transformForOrientation:(CGSize)newSize;

@end
