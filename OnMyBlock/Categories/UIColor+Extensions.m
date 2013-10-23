//
//  UIColor+Extensions.m
//  Bite
//
//  Created by Tommy DANGerous on 6/9/13.
//  Copyright (c) 2013 Quantum Ventures. All rights reserved.
//

#import "UIColor+Extensions.h"

@implementation UIColor (Extensions)

+ (UIColor *) backgroundColor
{
  return [UIColor colorWithRed: (245/255.0) green: (245/255.0) 
    blue: (245/255.0) alpha: 1]; 
}

+ (UIColor *) backgroundColorAlpha: (float) value
{
  return [UIColor colorWithRed: (245/255.0) green: (245/255.0) 
    blue: (245/255.0) alpha: value]; 
}

+ (UIColor *) blue
{
  return [UIColor colorWithRed: (111/255.0) green: (174/255.0) 
    blue: (193/255.0) alpha: 1];
}

+ (UIColor *) blueDarkAlpha: (float) value
{
  return [UIColor colorWithRed: (80/255.0) green: (145/255.0) 
    blue: (165/255.0) alpha: value];
}

+ (UIColor *) grayDark
{
  return [UIColor colorWithRed: (80/255.0) green: (80/255.0) 
    blue: (80/255.0) alpha: 1];
}

+ (UIColor *) grayDarkAlpha: (float) value
{
  return [UIColor colorWithRed: (80/255.0) green: (80/255.0) 
    blue: (80/255.0) alpha: value];
}

+ (UIColor *) grayLight
{
  return [UIColor colorWithRed: (210/255.0) green: (210/255.0) 
    blue: (210/255.0) alpha: 1];
}

+ (UIColor *) grayLightAlpha: (float) value
{
  return [UIColor colorWithRed: (210/255.0) green: (210/255.0) 
    blue: (210/255.0) alpha: value];
}

+ (UIColor *) grayMedium
{  
  return [UIColor colorWithRed: (140/255.0) green: (140/255.0) 
    blue: (140/255.0) alpha: 1];
}

+ (UIColor *) grayMediumAlpha: (float) value
{
  return [UIColor colorWithRed: (140/255.0) green: (140/255.0) 
    blue: (140/255.0) alpha: value];
}

+ (UIColor *) textColor
{
  return [UIColor blackColor];
}

+ (UIColor *) whiteAlpha: (float) value
{
  return [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: value];
}

@end
