//
//  OMBResidenceListStore.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 1/16/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import <Foundation/Foundation.h>

@class OMBResidence;

@protocol OMBResidenceListStoreDelegate <NSObject>

- (void)fetchResidencesForListFailed:(NSError *)error;
- (void)fetchResidencesForListSucceeded:(id)responseObject;

@end

@interface OMBResidenceListStore : NSObject

@property (nonatomic) CLLocationCoordinate2D centerCoordinate;
@property (nonatomic, strong) NSMutableDictionary *residences;

#pragma mark - Methods

#pragma mark - Class Methods

+ (OMBResidenceListStore *) sharedStore;

#pragma mark - Instance Methods

- (void) addResidence: (OMBResidence *) residence;
- (void) cancelConnection;
- (void)fetchResidencesWithParameters:(NSDictionary *)dictionary
delegate:(id<OMBResidenceListStoreDelegate>)delegate;
- (void) readFromDictionary: (NSDictionary *) dictionary;
- (void) removeResidences;
- (NSArray *) residenceArray;
- (NSArray *) sortedResidencesByDistanceFromCoordinate:
  (CLLocationCoordinate2D) coordinate;
- (NSArray *) sortedResidencesWithKey: (NSString *) string
  ascending: (BOOL) ascending;

@end
