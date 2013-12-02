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
  return [UIColor colorWithRed: (255/255.0) green: (255/255.0) 
    blue: (255/255.0) alpha: 1]; 
}

+ (UIColor *) backgroundColorAlpha: (float) value
{
  return [UIColor colorWithRed: (255/255.0) green: (255/255.0) 
    blue: (255/255.0) alpha: value]; 
}

+ (UIColor *) blue
{
  return [UIColor colorWithRed: (111/255.0) green: (174/255.0) 
    blue: (193/255.0) alpha: 1];
}

+ (UIColor *) blueDark
{
  return [UIColor colorWithRed: (80/255.0) green: (145/255.0) 
    blue: (165/255.0) alpha: 1];
}

+ (UIColor *) blueDarkAlpha: (float) value
{
  return [UIColor colorWithRed: (80/255.0) green: (145/255.0) 
    blue: (165/255.0) alpha: value];
}

+ (UIColor *) facebookBlue
{
  return [UIColor colorWithRed: (59/255.0) green: (87/255.0) 
    blue: (157/255.0) alpha: 1];
}

+ (UIColor *) facebookBlueDark
{
  return [UIColor colorWithRed: (39/255.0) green: (67/255.0) 
    blue: (137/255.0) alpha: 1];
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

+ (UIColor *) grayUltraLight
{  
  return [UIColor colorWithRed: (245/255.0) green: (245/255.0) 
    blue: (245/255.0) alpha: 1];
}

+ (UIColor *) grayUltraLightAlpha: (float) value
{
  return [UIColor colorWithRed: (245/255.0) green: (245/255.0) 
    blue: (245/255.0) alpha: value];
}

+ (UIColor *) green
{
  return [UIColor colorWithRed: (88/255.0) green: (209/255.0) 
    blue: (136/255.0) alpha: 1];
}

+ (UIColor *) greenDark
{
  return [UIColor colorWithRed: (42/255.0) green: (186/255.0) 
    blue: (100/255.0) alpha: 1];
}

+ (UIColor *) pink
{
  return [UIColor colorWithRed: (193/255.0) green: (25/255.0) 
    blue: (120/255.0) alpha: 1];
}

+ (UIColor *) pinkAlpha: (float) value
{
  return [UIColor colorWithRed: (193/255.0) green: (25/255.0) 
    blue: (120/255.0) alpha: value];
}

+ (UIColor *) pinkDark
{
  return [UIColor colorWithRed: (173/255.0) green: (5/255.0) 
    blue: (100/255.0) alpha: 1];
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
