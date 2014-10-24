//
//  OMBMapViewViewController.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 1/27/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

#import "OMBViewController.h"

@interface OMBMapViewViewController : OMBViewController
<MKMapViewDelegate>
{
  CLLocationCoordinate2D coordinate;
  MKMapView *map;
}

#pragma mark - Initializer

- (id) initWithCoordinate: (CLLocationCoordinate2D) coord
title: (NSString *) string;

@end
