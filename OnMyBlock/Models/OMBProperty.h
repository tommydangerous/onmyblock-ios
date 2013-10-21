//
//  OMBProperty.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 10/18/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OMBProperty : NSObject

@property (nonatomic, strong) NSString *address;
@property (nonatomic) NSTimeInterval availableOn;
@property (nonatomic) float bathrooms;
@property (nonatomic) float bedrooms;
@property (nonatomic) float latitude;
@property (nonatomic) int leaseMonths;
@property (nonatomic) float longitude;
@property (nonatomic) float rent;
@property (nonatomic) int uid; // ID

#pragma mark - Methods

#pragma mark Instance Methods

- (NSString *) latitudeLongitudeKey;
- (void) readFromDictionary: (NSDictionary *) dictionary;
- (NSString *) rentToCurrencyString;

@end
