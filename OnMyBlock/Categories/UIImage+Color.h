//
//  UIImage+Color.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 10/23/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Color)

+ (UIImage *) changeColorForImage:(UIImage *)image toColor:(UIColor*)color;
+ (UIImage *) imageNamed: (NSString *) name withColor: (UIColor *) color;
+ (UIImage *) imageWithColor: (UIColor *) color;

@end
