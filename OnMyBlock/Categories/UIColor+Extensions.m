//
//  UIColor+Extensions.m
//  Bite
//
//  Created by Tommy DANGerous on 6/9/13.
//  Copyright (c) 2013 Quantum Ventures. All rights reserved.
//

#import "UIColor+Extensions.h"

@implementation UIColor (Extensions)

+ (UIColor *) blue
{
  return [UIColor colorWithRed: (111/255.0) green: (174/255.0) 
    blue: (193/255.0) alpha: 1];
}

+ (UIColor *) grayLight
{
  return [UIColor colorWithRed: (210/255.0) green: (210/255.0) 
    blue: (210/255.0) alpha: 1];
}

+ (UIColor *) grayLightAlpha: (int) value
{
  return [UIColor colorWithRed: (210/255.0) green: (210/255.0) 
    blue: (210/255.0) alpha: value];
}

+ (UIColor *) grayMedium
{  
  return [UIColor colorWithRed: (140/255.0) green: (140/255.0) 
    blue: (140/255.0) alpha: 1];
}

+ (UIColor *) grayMediumAlpha: (int) value
{
  return [UIColor colorWithRed: (140/255.0) green: (140/255.0) 
    blue: (140/255.0) alpha: value];
}

+ (UIColor *) textColor
{
  return [UIColor colorWithRed: (80/255.0) green: (80/255.0) 
    blue: (80/255.0) alpha: 1];
}

@end
