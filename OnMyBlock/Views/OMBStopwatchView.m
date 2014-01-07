//
//  OMBStopwatchView.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 11/22/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBStopwatchView.h"

#import "UIColor+Extensions.h"

#define DEGREES_TO_RADIANS(x) (M_PI * x / 180.0)

@implementation OMBStopwatchView

@synthesize hourHand   = _hourHand;
@synthesize minuteHand = _minuteHand;

#pragma mark - Initializer

- (id) initWithFrame: (CGRect) rect
{
  if (!(self = [super initWithFrame: rect])) return nil;

  UIColor *color = [UIColor textColor];

  UIView *circle = [[UIView alloc] init];
  float circleHeight = rect.size.width;
  float circleWidth  = circleHeight;
  circle.frame = CGRectMake(0, 0, circleWidth, circleHeight);
  circle.layer.borderColor = color.CGColor;
  circle.layer.borderWidth = rect.size.width * 0.01;
  circle.layer.cornerRadius = circleWidth * 0.5;
  // [self addSubview: circle];

  // Image size is 294 x 352
  UIImage *image = [UIImage imageNamed: @"stopwatch_image.png"];
  float imageHeight = image.size.height;
  float imageWidth = image.size.width;

  self.frame = CGRectMake(rect.origin.x, rect.origin.y,
    (rect.size.width * (imageWidth / imageHeight)), rect.size.height);

  UIImageView *imageView = [[UIImageView alloc] init];
  imageView.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y,
    self.frame.size.width, 
      (self.frame.size.width * (imageHeight / imageWidth)));
  imageView.image = image;
  [self addSubview: imageView];

  float imageViewHeight = imageView.frame.size.height;
  float imageViewWidth  = imageView.frame.size.width;

  // Time marks
  UIView *mark1 = [[UIView alloc] init];
  mark1.backgroundColor = color;
  float mark1Height = circleHeight * 0.08;
  float mark1Width  = circle.layer.borderWidth * 0.8;
  mark1.frame = CGRectMake(
    ((circleWidth - mark1Width) * 0.5), (circleHeight * 0.05),
      mark1Width, mark1Height);
  [circle addSubview: mark1];

  UIView *mark2 = [[UIView alloc] init];
  mark2.backgroundColor = mark1.backgroundColor;
  mark2.frame = CGRectMake(
    ((circleWidth - mark1Width) * 0.5), 
      (circleHeight - (mark1Height + (circleHeight * 0.05))),
        mark1Width, mark1Height);
  [circle addSubview: mark2];

  UIView *mark3 = [[UIView alloc] init];
  mark3.backgroundColor = mark1.backgroundColor;
  float mark3Height = mark1Width;
  float mark3Width  = mark1Height;
  mark3.frame = CGRectMake(
    (circleWidth * 0.05), ((circleHeight - mark3Height) * 0.5),
      mark3Width, mark3Height);
  [circle addSubview: mark3];

  UIView *mark4 = [[UIView alloc] init];
  mark4.backgroundColor = mark1.backgroundColor;
  mark4.frame = CGRectMake(
    (circleWidth - ((circleWidth * 0.05) + mark3Width)), 
      ((circleHeight - mark3Height) * 0.5), mark3Width, mark3Height);
  [circle addSubview: mark4];

  _hourHand = [[UIView alloc] init];
  _hourHand.backgroundColor = [UIColor pink];
  float hourHandHeight = imageWidth * 0.01;
  float hourHandWidth  = imageWidth * 0.25;
  // Need to put anchor point before the frame
  _hourHand.layer.anchorPoint = CGPointMake(1, 1);
  _hourHand.frame = CGRectMake(
    (imageViewWidth - ((imageViewWidth * 0.5) + hourHandWidth)),
      (imageViewHeight - ((imageViewWidth * 0.5) + (hourHandHeight * 0.5))), 
        hourHandWidth, hourHandHeight);  
  [imageView addSubview: _hourHand];

  _minuteHand = [[UIView alloc] init];
  _minuteHand.backgroundColor = _hourHand.backgroundColor;
  float minuteHandHeight = hourHandWidth * 0.3;
  float minuteHandWidth  = hourHandHeight * 0.7;
  _minuteHand.layer.anchorPoint = CGPointMake(1, 1);
  _minuteHand.frame = CGRectMake(
    ((imageViewWidth - minuteHandWidth) * 0.5),
      (((imageViewWidth - minuteHandWidth) * 0.5) - minuteHandHeight),
        minuteHandWidth, minuteHandHeight);
  [imageView addSubview: _minuteHand];

  UIView *dot = [[UIView alloc] init];
  dot.backgroundColor = color;
  float dotHeight = circleWidth * 0.05;
  dot.frame = CGRectMake(
    ((circleWidth - dotHeight) * 0.5), ((circleHeight - dotHeight) * 0.5),
      dotHeight, dotHeight);
  dot.layer.cornerRadius = dotHeight * 0.5;
  [circle addSubview: dot];

  UIView *stopBottom1 = [[UIView alloc] init];
  stopBottom1.backgroundColor = color;
  float stopBottom1Height = circleHeight * 0.08;
  float stopBottom1Width  = stopBottom1Height * 0.8;
  stopBottom1.frame = CGRectMake(
    ((circleWidth - stopBottom1Width) * 0.5), (-1 * stopBottom1Height),
      stopBottom1Width, stopBottom1Height);
  // [self addSubview: stopBottom1];

  UIView *stopTop1 = [[UIView alloc] init];
  stopTop1.backgroundColor = color;
  float stopTop1Height = stopBottom1Height * 1.2;
  float stopTop1Width  = stopBottom1Width * 2.2;
  stopTop1.frame = CGRectMake(
    ((circleWidth - stopTop1Width) * 0.5), 
      (-1 * (stopBottom1Height + stopTop1Height)), 
        stopTop1Width, stopTop1Height);
  [circle addSubview: stopTop1];

  return self;
}

@end
