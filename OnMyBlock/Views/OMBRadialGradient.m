//
//  OMBRadialGradient.m
//  OnMyBlock
//
//  Created by Paul Aguilar on 4/11/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//
//  reference http://www.techotopia.com/index.php/An_iOS_7_Graphics_Tutorial_using_Core_Graphics_and_Core_Image#Drawing_Gradients

#import "OMBRadialGradient.h"

@implementation OMBRadialGradient

#pragma mark - Initializer

- (id)initWithFrame:(CGRect)frame
         withColors:(NSArray *)arrayColors
             onLeft:(BOOL)left
{
  if(!(self = [super initWithFrame: frame])) return nil;
  
  colors = arrayColors;
  direction = left;
  return self;
}

- (void)drawRect:(CGRect)rect
{
  CGContextRef context = UIGraphicsGetCurrentContext();
  CGGradientRef gradient;
  CGColorSpaceRef colorspace;
  CGFloat locations[2] = { 0.5, 1.0};
  
  colorspace = CGColorSpaceCreateDeviceRGB();
  
  gradient = CGGradientCreateWithColors(colorspace,
    (CFArrayRef)colors, locations);
  
  CGPoint startPoint, endPoint;
  CGFloat startRadius, endRadius;
  CGPoint index = direction ?
  CGPointZero : CGPointMake(rect.size.height, rect.size.width);
  
  startPoint = index;
  endPoint   = index;
  startRadius = 0;
  endRadius = sqrtf(powf(rect.size.height,2.f) + powf(rect.size.width,2.f));
  
  CGContextDrawRadialGradient (context, gradient, startPoint,
    startRadius, endPoint, endRadius, 0);
}

@end