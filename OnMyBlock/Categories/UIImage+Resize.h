//
//  UIImage+Resize.h
//  Bite
//
//  Created by Tommy DANGerous on 5/15/13.
//  Copyright (c) 2013 Quantum Ventures. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Resize)

#pragma mark - Methods

+ (UIImage *) image: (UIImage *) image size: (CGSize) size;
+ (UIImage *) image: (UIImage *) image size: (CGSize) size 
point: (CGPoint) point;

@end
