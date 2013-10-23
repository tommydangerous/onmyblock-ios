//
//  OMBNeighborhoodStore.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 10/22/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OMBNeighborhoodStore : NSObject

@property (nonatomic, strong) NSDictionary *neighborhoods;

#pragma mark - Methods

#pragma mark - Class Methods

+ (OMBNeighborhoodStore *) sharedStore;

#pragma mark - Instance Methods

- (NSArray *) sortedNeighborhoods;

@end
