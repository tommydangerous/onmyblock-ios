//
//  OMBCurvedLineView.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 1/20/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBCurvedLineView.h"

#define DEGREES_TO_RADIANS(degrees)  ((M_PI * degrees)/ 180)

@interface OMBCurvedLineView ()
{
  UIColor *lineColor;
}

@end

@implementation OMBCurvedLineView

#pragma mark - Initializer

- (id) initWithFrame: (CGRect) rect
{
  return [self initWithFrame: rect color: nil]; 
}

- (id) initWithFrame: (CGRect) rect color: (UIColor *) color
{
  if (!(self = [super initWithFrame: rect])) return nil;

  if (color)
    lineColor = color;
  else
    lineColor = [UIColor whiteColor];

  self.backgroundColor = [UIColor clearColor];

  return self;
}

- (void)drawRect:(CGRect)rect
{
  CGContextRef context = UIGraphicsGetCurrentContext();

  CGMutablePathRef path = CGPathCreateMutable();

  // As appropriate for iOS, the code below assumes a coordinate system with
  // the x-axis pointing to the right and the y-axis pointing down (flipped from the standard Cartesian convention).
  // Therefore, 0 degrees = East, 90 degrees = South, 180 degrees = West,
  // -90 degrees = 270 degrees = North (once again, flipped from the standard Cartesian convention).
  CGFloat startingAngle = 90.0;  // South
  CGFloat endingAngle = -45.0;   // North-East
  BOOL weGoFromTheStartingAngleToTheEndingAngleInACounterClockwiseDirection = YES;  // change this to NO if necessary

  CGFloat startingThickness = 0.0;
  CGFloat endingThickness = 3.0;

  CGPoint center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
  // CGFloat meanRadius = 0.9 * fminf(self.bounds.size.width * 0.3f, self.bounds.size.height * 0.3f);
  CGFloat meanRadius = self.bounds.size.width * 0.1f;

  // the parameters above should be supplied by the user
  // the parameters below are derived from the parameters supplied above

  CGFloat deltaAngle = fabsf(endingAngle - startingAngle);

  // projectedEndingThickness is the ending thickness we would have if the two arcs
  // subtended an angle of 180 degrees at their respective centers instead of deltaAngle
  CGFloat projectedEndingThickness = startingThickness + (endingThickness - startingThickness) * (180.0 / deltaAngle);

  CGFloat centerOffset = (projectedEndingThickness - startingThickness) / 4.0;
  CGPoint centerForInnerArc = CGPointMake(center.x + centerOffset * cos(startingAngle * M_PI / 180.0),
                                          center.y + centerOffset * sin(startingAngle * M_PI / 180.0));
  CGPoint centerForOuterArc = CGPointMake(center.x - centerOffset * cos(startingAngle * M_PI / 180.0),
                                          center.y - centerOffset * sin(startingAngle * M_PI / 180.0));

  CGFloat radiusForInnerArc = meanRadius - (startingThickness + projectedEndingThickness) / 4.0;
  CGFloat radiusForOuterArc = meanRadius + (startingThickness + projectedEndingThickness) / 4.0;

  // CGContextSetRGBStrokeColor(context, 1, 0, 0, 1);

  // CGContextStrokePath(context);


  CGPathAddArc(path,
               NULL,
               centerForInnerArc.x,
               centerForInnerArc.y,
               radiusForInnerArc,
               endingAngle * (M_PI / 180.0),
               startingAngle * (M_PI / 180.0),
               !weGoFromTheStartingAngleToTheEndingAngleInACounterClockwiseDirection
               );

  CGPathAddArc(path,
               NULL,
               centerForOuterArc.x,
               centerForOuterArc.y,
               radiusForOuterArc,
               startingAngle * (M_PI / 180.0),
               endingAngle * (M_PI / 180.0),
               weGoFromTheStartingAngleToTheEndingAngleInACounterClockwiseDirection
               );

  CGContextAddPath(context, path);
  
  CGContextSetFillColorWithColor(context, lineColor.CGColor);

  CGContextFillPath(context);
  // CGContextStrokePath(context);

  CGPathRelease(path);  
}

- (void) drawRectOLD: (CGRect) rect
{
  CGFloat radius = self.frame.size.width * 0.1f;

  CGFloat starttime = DEGREES_TO_RADIANS(60);
  CGFloat endtime   = DEGREES_TO_RADIANS(120);

  //draw arc
  CGPoint center = CGPointMake((self.frame.size.width - 1) * 0.5f,
    (self.frame.size.width - 1) * 0.5f);
  UIBezierPath *arc = [UIBezierPath bezierPath]; //empty path
  // [arc moveToPoint: center];
  CGPoint next;
  next.x = center.x + radius * cos(starttime);
  next.y = center.y + radius * sin(starttime);

  [arc moveToPoint: next];
  [arc addLineToPoint: next]; //go one end of arc

  [arc addArcWithCenter: center radius: radius startAngle: starttime 
    endAngle: endtime clockwise: YES]; //add the arc
  // [arc addLineToPoint:center]; //back to center

  [[UIColor yellowColor] set];
  // [arc fill];
  [arc stroke];
}

@end
