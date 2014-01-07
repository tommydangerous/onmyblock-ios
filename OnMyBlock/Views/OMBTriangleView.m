//
//  OMBTriangleView.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 11/22/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBTriangleView.h"

@implementation OMBTriangleView

- (void) drawRect: (CGRect) rect
{
  CGContextRef ctx = UIGraphicsGetCurrentContext();

  CGContextBeginPath(ctx);

  // Top - middle
  CGContextMoveToPoint(ctx, CGRectGetMidX(rect), CGRectGetMidY(rect));
  // Bottom - right
  CGContextAddLineToPoint(ctx, CGRectGetMaxX(rect), CGRectGetMaxY(rect));
  // Bottom - left
  CGContextAddLineToPoint(ctx, CGRectGetMinX(rect), CGRectGetMaxY(rect));

  CGContextClosePath(ctx);

  CGContextSetRGBFillColor(ctx, 140/255.0, 140/255.0, 140/255.0, 1);
  CGContextFillPath(ctx);
}

@end
