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

+ (UIColor *) blueAlpha: (float) value
{
  return [UIColor colorWithRed: (111/255.0) green: (174/255.0) 
    blue: (193/255.0) alpha: value];
}

+ (UIColor *) blueHighlighted
{
  return [UIColor blueHighlightedAlpha: 1.0f];
}

+ (UIColor *) blueHighlightedAlpha: (CGFloat) value
{
  return [UIColor colorWithRed: (111 - 20)/255.0 green: (174 - 20)/255.0 
    blue: (193 - 20)/255.0 alpha: value];
}

+ (UIColor *) blueDark
{
  return [UIColor colorWithRed: (46/255.0) green: (112/255.0) 
    blue: (159/255.0) alpha: 1.0f];
}

+ (UIColor *) blueDarkAlpha: (float) value
{
  return [UIColor colorWithRed: (46/255.0) green: (112/255.0) 
    blue: (159/255.0) alpha: value];
}

+ (UIColor *) blueLight
{
  return [UIColor colorWithRed: (174/255.0f) green: (197/255.0f) 
    blue: (206/255.0f) alpha: 1.0f];
}

+ (UIColor *) facebookBlue
{
  return [UIColor facebookBlueAlpha: 1.0f];
}

+ (UIColor *) facebookBlueAlpha: (CGFloat) value
{
  return [UIColor colorWithRed: (59/255.0) green: (87/255.0) 
    blue: (157/255.0) alpha: value];
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

+ (UIColor *) grayVeryLight
{
  return [UIColor colorWithWhite: 230/255.0f alpha: 1.0f];
}

+ (UIColor *) green
{
  return [UIColor colorWithRed: (88/255.0) green: (209/255.0) 
    blue: (136/255.0) alpha: 1];
}

+ (UIColor *) greenAlpha: (float) value
{
  return [UIColor colorWithRed: (88/255.0) green: (209/255.0) 
    blue: (136/255.0) alpha: value];
}

+ (UIColor *) greenDark
{
  return [UIColor colorWithRed: (42/255.0) green: (186/255.0) 
    blue: (100/255.0) alpha: 1];
}

+ (UIColor *) linkedinBlue
{
  return [UIColor colorWithRed: 0.0f green: 102/255.0f blue: 153/255.0f
    alpha: 1.0f];
}

+ (UIColor *) linkedinGray
{
  return [UIColor colorWithRed: 221/255.0f green: 221/255.0f blue: 221/255.0f
    alpha: 1.0f];
}

+ (UIColor *) orange
{
  return [UIColor orangeAlpha: 1.0f];
}

+ (UIColor *) orangeAlpha: (CGFloat) value
{
  return [UIColor colorWithRed: 248/255.0f green: 143/255.0f blue: 18/255.0f
    alpha: value];
}

+ (UIColor *) paypalBlue
{
  return [UIColor colorWithRed: 0.0f green: 69/255.0f blue: 124/255.0f
    alpha: 1.0f];
}

+ (UIColor *) paypalBlueLight
{
  return [UIColor colorWithRed: 20/255.0f green: 79/255.0f blue: 144/255.0f
    alpha: 1.0f];
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

+ (UIColor *) red
{
  return [UIColor colorWithRed: (255/255.0) green: (26/255.0) 
    blue: (0/255.0) alpha: 1];
}

+ (UIColor *) textColor
{
  return [UIColor blackColor];
}

+ (UIColor *) venmoBlue
{
  return [UIColor colorWithRed: 61/255.0 green: 149/255.0 blue: 206/255.0
    alpha: 1.0f];
}

+ (UIColor *) venmoBlueDark
{
  return [UIColor colorWithRed: 62/255.0 green: 125/255.0 blue: 183/255.0
    alpha: 1.0f];
}

+ (UIColor *) whiteAlpha: (float) value
{
  return [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: value];
}

+ (UIColor *) yellow
{
  return [UIColor colorWithRed: 246/255.0 green: 186/255.0 blue: 50/255.0
    alpha: 1.0f];
}

@end
