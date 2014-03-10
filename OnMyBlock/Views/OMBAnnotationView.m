//
//  OMBAnnotationView.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 10/18/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "OMBAnnotationView.h"

#import "NSString+Extensions.h"
#import "OCMapView.h"
#import "OMBAnnotation.h"
#import "OMBAnnotationCity.h"
#import "OMBViewController.h"
#import "UIColor+Extensions.h"
#import "UIFont+OnMyBlock.h"
#import "UIImage+Resize.h"

const float DEFAULT_BORDER_PERCENTAGE = 0.08;
const float DEFAULT_DIMENSION         = 30 * (1 + DEFAULT_BORDER_PERCENTAGE);

@implementation OMBAnnotationView

- (id) initWithAnnotation: (id <MKAnnotation>) annotation 
reuseIdentifier: (NSString *) reuseIdentifier
{
  self = [super initWithAnnotation: annotation 
    reuseIdentifier: reuseIdentifier];
  if (!self) return nil;

  self.backgroundColor = [UIColor clearColor];
  self.frame = CGRectMake(0, 0, DEFAULT_DIMENSION, DEFAULT_DIMENSION);

  // Inside view
  insideView = [UIView new];
  insideView.backgroundColor = [UIColor blue];
  insideView.frame = CGRectMake(
    (DEFAULT_DIMENSION * DEFAULT_BORDER_PERCENTAGE), 
      (DEFAULT_DIMENSION * DEFAULT_BORDER_PERCENTAGE), 
        (DEFAULT_DIMENSION * (1 - (DEFAULT_BORDER_PERCENTAGE * 2))),
          (DEFAULT_DIMENSION * (1 - (DEFAULT_BORDER_PERCENTAGE * 2))));
  insideView.layer.cornerRadius = insideView.frame.size.width / 2.0;
  [self addSubview: insideView];

  // Border
  self.layer.borderColor  = [UIColor grayMediumAlpha: 0.5].CGColor;
  self.layer.borderWidth  = DEFAULT_DIMENSION * DEFAULT_BORDER_PERCENTAGE;
  self.layer.cornerRadius = DEFAULT_DIMENSION / 2.0;

  label = [UILabel new];
  label.backgroundColor = [UIColor clearColor];
  label.font   = [UIFont fontWithName: @"HelveticaNeue-Medium" size: 14];
  label.frame  = self.frame;
  label.textAlignment = NSTextAlignmentCenter;
  label.text          = @"1";
  label.textColor     = [UIColor whiteColor];
  [self addSubview: label];

  [self loadAnnotation: annotation];

  return self;
}

#pragma mark - Methods

#pragma mark Instance Methods

- (void) deselect
{
  insideView.backgroundColor = [UIColor blue];
  self.layer.borderColor     = [UIColor grayMediumAlpha: 0.5].CGColor;
}

- (void) loadAnnotation: (id <MKAnnotation>) annotation
{
  [self deselect];
  // City
  if ([annotation isKindOfClass: [OMBAnnotationCity class]]) {
    [self setupForAnnotationCity: annotation];
  }
  else {
    // 1-9
    // 10 - 99
    // 100 - 999
    // 1000+
    CGFloat dimension = DEFAULT_DIMENSION;
    NSString *string  = @"1";
    // Cluster
    if ([annotation isKindOfClass: [OCAnnotation class]]) {
      NSUInteger count = 
        [[(OCAnnotation *) annotation annotationsInCluster] count];
      if (count >= 1000) {
        dimension *= 1.9;
      }
      else if (count >= 100) {
        dimension *= 1.6;
      }
      else if (count >= 10) {
        dimension *= 1.3;
      }
      else {
        dimension *= 1;
      }
      string = [NSString stringWithFormat: @"%i", count];
    }
    else {
      [(OMBAnnotation *) annotation setAnnotationView: self];
    }
    label.text  = string;
    [self setFramesWithDimension: dimension];
  }
}

- (void) OLDloadAnnotation: (id <MKAnnotation>) annotation
{
  float dimension = DEFAULT_DIMENSION;
  NSString *text  = @"1";
  [self deselect];
  // If a city
  if ([annotation isKindOfClass: [OMBAnnotationCity class]]) {
    int number = [annotation.title intValue];
    dimension = (DEFAULT_DIMENSION * 1.1) * 1.1 * (number / 10);
    if (dimension > DEFAULT_DIMENSION * 3 * (1 + DEFAULT_BORDER_PERCENTAGE))
      dimension = DEFAULT_DIMENSION * 3 * (1 + DEFAULT_BORDER_PERCENTAGE);
    OMBAnnotationCity *annotationCity = annotation;
    text = annotationCity.cityName;
  }
  // If it is a cluster
  else if ([annotation isKindOfClass: [OCAnnotation class]]) {
    int number = 
      (int) [[(OCAnnotation *) annotation annotationsInCluster] count];
    if (number > 10)
      dimension = (DEFAULT_DIMENSION * 1.1) * 1.1 * (number / 10);
    if (dimension > DEFAULT_DIMENSION * 2 * (1 + DEFAULT_BORDER_PERCENTAGE))
      dimension = DEFAULT_DIMENSION * 2 * (1 + DEFAULT_BORDER_PERCENTAGE);
    text = [NSString stringWithFormat: @"%i", (int) number];
  }
  else
    [(OMBAnnotation *) annotation setAnnotationView: self];

  // Resize
  // Frame
  self.frame = CGRectMake(0, 0, dimension, dimension);

  // Inside view
  insideView.frame = CGRectMake(
    (dimension * DEFAULT_BORDER_PERCENTAGE), 
      (dimension * DEFAULT_BORDER_PERCENTAGE), 
        (dimension * (1 - (DEFAULT_BORDER_PERCENTAGE * 2))),
          (dimension * (1 - (DEFAULT_BORDER_PERCENTAGE * 2))));
  insideView.layer.cornerRadius = insideView.frame.size.width / 2.0;

  // Border
  self.layer.borderWidth  = dimension * DEFAULT_BORDER_PERCENTAGE;
  self.layer.cornerRadius = dimension / 2.0;

  // Label
  label.frame = self.frame;
  label.text  = text;
}

- (void) select
{
  insideView.backgroundColor = [UIColor grayDark];
  self.layer.borderColor     = [UIColor grayDarkAlpha: 0.5].CGColor;
}

- (void) setupForAnnotationCity: (OMBAnnotationCity *) annotationCity
{
  CGFloat padding = OMBPadding;

  // Label
  label.text = annotationCity.cityName;
  CGRect rect = [label.text boundingRectWithSize: CGSizeMake(999, 21)
    font: label.font];

  // Frame
  self.frame = CGRectMake(0.0f, 0.0f, rect.size.width + padding,
    rect.size.height + padding);

  // Inside view
  insideView.frame = CGRectMake(padding * 0.25f, padding * 0.25f,
    rect.size.width + (padding * 0.5f), rect.size.height + (padding * 0.5f));
  insideView.layer.cornerRadius = 2.0f;

  // Border
  self.layer.borderWidth  = rect.size.height * DEFAULT_BORDER_PERCENTAGE;
  self.layer.cornerRadius = insideView.layer.cornerRadius;

  label.frame = self.frame;
}

- (void) setFramesWithDimension: (CGFloat) dimension
{
  // Resize
  // Frame
  self.frame = CGRectMake(0, 0, dimension, dimension);

  // Inside view
  insideView.frame = CGRectMake(
    (dimension * DEFAULT_BORDER_PERCENTAGE), 
      (dimension * DEFAULT_BORDER_PERCENTAGE), 
        (dimension * (1 - (DEFAULT_BORDER_PERCENTAGE * 2))),
          (dimension * (1 - (DEFAULT_BORDER_PERCENTAGE * 2))));
  insideView.layer.cornerRadius = insideView.frame.size.width * 0.5f;

  // Border
  self.layer.borderWidth  = dimension * DEFAULT_BORDER_PERCENTAGE;
  self.layer.cornerRadius = dimension * 0.5f;

  // Label
  label.frame = self.frame; 
}

@end
