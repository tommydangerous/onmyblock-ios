//
//  OMBNeighborhood.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 10/22/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface OMBNeighborhood : NSObject

@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic, strong) NSString *name;

#pragma mark - Methods

#pragma mark - Instance Methods

- (NSString *) nameKey;

@end
