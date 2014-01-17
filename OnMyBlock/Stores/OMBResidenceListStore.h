//
//  OMBResidenceListStore.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 1/16/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@class OMBResidence;

@interface OMBResidenceListStore : NSObject

@property (nonatomic) CLLocationCoordinate2D centerCoordinate;
@property (nonatomic, strong) NSMutableArray *residences;

#pragma mark - Methods

#pragma mark - Class Methods

+ (OMBResidenceListStore *) sharedStore;

#pragma mark - Instance Methods

- (void) addResidence: (OMBResidence *) residence;
- (void) fetchResidencesWithParameters: (NSDictionary *) dictionary
completion: (void (^) (NSError *error)) block;
- (void) readFromDictionary: (NSDictionary *) dictionary;
- (NSArray *) sortedResidencesByDistance;

@end
