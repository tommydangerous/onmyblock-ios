//
//  OMBAnnotationView.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 10/18/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "OMBAnnotationView.h"

#import "OCMapView.h"
#import "UIColor+Extensions.h"
#import "UIImage+Resize.h"

const int DEFAULT_DIMENSION = 30;

@implementation OMBAnnotationView

- (id) initWithAnnotation: (id <MKAnnotation>) annotation 
reuseIdentifier: (NSString *) reuseIdentifier
{
  self = [super initWithAnnotation: annotation 
    reuseIdentifier: reuseIdentifier];
  if (self) {
    self.frame = CGRectMake(0, 0, DEFAULT_DIMENSION, DEFAULT_DIMENSION);
    self.backgroundColor = [UIColor blue];
    self.layer.cornerRadius = DEFAULT_DIMENSION / 2.0;
    label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor clearColor];
    label.font   = [UIFont fontWithName: @"HelveticaNeue-Medium" size: 13];
    label.frame  = self.frame;
    label.textAlignment = NSTextAlignmentCenter;
    label.text          = @"1";
    label.textColor     = [UIColor whiteColor];
    [self addSubview: label];
  }
  return self;
}

#pragma mark - Methods

#pragma mark Instance Methods

- (void) loadAnnotation: (id <MKAnnotation>) annotation
{
  float dimension = DEFAULT_DIMENSION;
  NSString *text  = @"1";
  // If it is a cluster
  if ([annotation isKindOfClass: [OCAnnotation class]]) {
    int number = [[(OCAnnotation *) annotation annotationsInCluster] count];
    if (number > 15)
      dimension = (DEFAULT_DIMENSION * 1.1) * 1.1 * (number / 15);
    if (dimension > 60)
      dimension = 60;
    text = [NSString stringWithFormat: @"%i", number];
  }
  self.frame  = CGRectMake(0, 0, dimension, dimension);
  self.layer.cornerRadius = dimension / 2.0;
  label.frame = self.frame;
  label.text  = text;
}

@end
