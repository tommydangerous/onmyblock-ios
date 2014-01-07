//
//  OMBGradientView.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 11/16/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBGradientView.h"

const CGPoint HORIZONTAL_START_POINT = { 0, 0.5 };
const CGPoint HORIZONTAL_END_POINT   = { 1, 0.5 };
const CGPoint VERTICAL_START_POINT   = { 0.5, 0 };
const CGPoint VERTICAL_END_POINT     = { 0.5, 1 };

@implementation OMBGradientView

+ (Class) layerClass
{
  return [CAGradientLayer class];
}

- (CAGradientLayer *) gradientLayer
{
  return (CAGradientLayer *) self.layer;
}

#pragma mark - Accessors

#pragma mark - Setters

- (BOOL) isHorizontal
{
  return (CGPointEqualToPoint(self.gradientLayer.startPoint, 
    HORIZONTAL_START_POINT)) && 
      (CGPointEqualToPoint(self.gradientLayer.endPoint, 
        HORIZONTAL_END_POINT));
}

- (void) setColors: (NSArray *) colors
{
  NSMutableArray *cgColors = [NSMutableArray arrayWithCapacity: [colors count]];
  for (UIColor *color in colors) {
    [cgColors addObject: (id) [color CGColor]];
  }
  self.gradientLayer.colors = cgColors;
}

#pragma mark - Getters

- (NSArray *) colors
{
  NSMutableArray *uiColors = [NSMutableArray arrayWithCapacity:
    [self.gradientLayer.colors count]];
  for (id color in self.gradientLayer.colors) {
    [uiColors addObject: [UIColor colorWithCGColor: (CGColorRef) color]];
  }
  return uiColors;
}

- (void) setHorizontal: (BOOL) horizontal
{
  self.gradientLayer.startPoint = 
    horizontal ? HORIZONTAL_START_POINT : VERTICAL_START_POINT;
  self.gradientLayer.endPoint   = 
    horizontal ? HORIZONTAL_END_POINT : VERTICAL_END_POINT;
}

@end
