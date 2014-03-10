//
//  OMBAmenityStore.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 3/10/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OMBAmenityStore : NSObject

#pragma mark - Methods

#pragma mark - Class Methods

+ (OMBAmenityStore *) sharedStore;

#pragma mark - Instance Methods

- (NSArray *) allAmenities;
- (NSArray *) amenitiesForCategory: (NSString *) category;
- (NSArray *) categories;

@end
