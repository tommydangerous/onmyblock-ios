//
//  OMBPropertiesStore.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 10/18/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import <Foundation/Foundation.h>

@class OMBMapViewController;
@class OMBProperty;

@interface OMBPropertiesStore : NSObject

@property (nonatomic, strong) OMBMapViewController *mapViewController;
@property (nonatomic, strong) NSMutableDictionary *properties;

#pragma mark - Methods

#pragma mark Class Methods

+ (OMBPropertiesStore *) sharedStore;

#pragma mark Instance Methods

- (void) addProperty: (OMBProperty *) property;
- (void) fetchPropertiesWithParameters: (NSDictionary *) parameters;
- (void) readFromDictionary: (NSDictionary *) dictionary;

@end
