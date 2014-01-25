//
//  OMBAllResidenceStore.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 1/24/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import <Foundation/Foundation.h>

@class OMBResidence;

@interface OMBAllResidenceStore : NSObject

@property (nonatomic, strong) NSMutableDictionary *residences;

#pragma mark - Methods

#pragma mark - Class Methods

+ (OMBAllResidenceStore *) sharedStore;

#pragma mark - Instance Methods

- (void) addResidence: (OMBResidence *) residence;
- (OMBResidence *) residenceForUID: (NSInteger) uid;

@end
