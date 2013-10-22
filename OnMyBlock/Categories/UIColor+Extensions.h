//
//  UIColor+Extensions.h
//  Bite
//
//  Created by Tommy DANGerous on 6/9/13.
//  Copyright (c) 2013 Quantum Ventures. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Extensions)

+ (UIColor *) blue;
+ (UIColor *) grayDark;
+ (UIColor *) grayDarkAlpha: (float) value;
+ (UIColor *) grayLight;
+ (UIColor *) grayLightAlpha: (float) value;
+ (UIColor *) grayMedium;
+ (UIColor *) grayMediumAlpha: (float) value;
+ (UIColor *) textColor;
+ (UIColor *) whiteAlpha: (float) value;

@end
