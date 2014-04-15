//
//  OMBResidenceMapStore.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 3/6/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@class OMBResidence;

@interface OMBResidenceMapStore : NSObject

#pragma mark - Methods

#pragma mark - Class Methods

+ (OMBResidenceMapStore *) sharedStore;

#pragma mark - Instance Methods

- (NSArray *) annotations;
- (void) fetchResidencesWithParameters: (NSDictionary *) parameters
delegate: (id) delegate completion: (void (^) (NSError *error)) block;
- (void) readFromDictionary: (NSDictionary *) dictionary;
- (NSArray *) residences;
- (OMBResidence *) residenceForCoordinate: (CLLocationCoordinate2D) coordinate;

@end
