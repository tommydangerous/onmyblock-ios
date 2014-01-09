//
//  OMBGoogleMapsReverseGeocodingConnection.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/16/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

#import "OMBConnection.h"

@interface OMBGoogleMapsReverseGeocodingConnection : OMBConnection

#pragma mark - Initializer

- (id) initWithCoordinate: (CLLocationCoordinate2D) coordinate;

@end
