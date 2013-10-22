//
//  OMBAnnotation.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 10/18/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBAnnotation.h"

@implementation OMBAnnotation

@synthesize annotationView = _annotationView;
@synthesize coordinate     = _coordinate;
@synthesize title          = _title;

#pragma mark - Setters

- (void) setCoordinate: (CLLocationCoordinate2D) coord
{
  _coordinate = coord;
}

- (void) setTitle: (NSString *) string
{
  _title = string;
}

@end
