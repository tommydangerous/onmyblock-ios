//
//  OMBRenterApplication.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/5/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import <Foundation/Foundation.h>

@class OMBCosigner;
@class OMBPreviousRental;

@interface OMBRenterApplication : NSObject

@property (nonatomic) BOOL cats;
@property (nonatomic, strong) NSMutableArray *cosigners;
@property (nonatomic) BOOL dogs;
@property (nonatomic, strong) NSMutableArray *previousRentals;

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) addCosigner: (OMBCosigner *) cosigner;
- (void) addPreviousRental: (OMBPreviousRental *) previousRental;
- (NSArray *) cosignersSortedByFirstName;
- (void) readFromDictionary: (NSDictionary *) dictionary;

@end
