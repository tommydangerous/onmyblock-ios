//
//  OMBAnnotationView.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 10/18/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBAnnotationView.h"

#import "OCMapView.h"
#import "UIColor+Extensions.h"
#import "UIImage+Resize.h"

const int DEFAULT_DIMENSION = 24;

@implementation OMBAnnotationView

- (id) initWithAnnotation: (id <MKAnnotation>) annotation 
reuseIdentifier: (NSString *) reuseIdentifier
{
  self = [super initWithAnnotation: annotation 
    reuseIdentifier: reuseIdentifier];
  if (self) {
    label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor clearColor];
    label.font   = [UIFont fontWithName: @"HelveticaNeue-Medium" size: 11];
    label.hidden = YES;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor     = [UIColor blue];
    [self addSubview: label];
  }
  return self;
}

#pragma mark - Methods

#pragma mark Instance Methods

- (void) loadAnnotation: (id <MKAnnotation>) object
{
  float dimension;
  // If it is a cluster
  if ([object isKindOfClass: [OCAnnotation class]]) {
    int number = [[(OCAnnotation *) object annotationsInCluster] count];
    if (number > 15)
      dimension = (DEFAULT_DIMENSION * 1.15) * 1.15 * (number / 15);
    else
      dimension = (DEFAULT_DIMENSION * 1.15);
    self.image  = [UIImage image: [UIImage imageNamed: @"marker_circle.png"] 
      size: CGSizeMake(dimension, dimension)];
    label.frame  = CGRectMake(0, 0, dimension, dimension);
    label.hidden = NO;
    label.text   = [NSString stringWithFormat: @"%i", number];
  }
  else {
    dimension    = DEFAULT_DIMENSION;
    self.image   = [UIImage image: [UIImage imageNamed: @"marker_single.png"] 
      size: CGSizeMake(dimension, dimension)];
    label.frame  = CGRectMake(0, 0, dimension, dimension);
    label.hidden = YES;
    label.text   = @"";
  }
}

@end
