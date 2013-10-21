//
//  OMBResidence.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 10/21/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OMBResidence : NSObject

// Web app properties
@property (nonatomic, strong) NSString *address;
@property (nonatomic) NSTimeInterval availableOn;
@property (nonatomic) float bathrooms;
@property (nonatomic) float bedrooms;
@property (nonatomic) float latitude;
@property (nonatomic) int leaseMonths;
@property (nonatomic) float longitude;
@property (nonatomic) float rent;
@property (nonatomic) int uid; // ID

// iOS app properties
@property (nonatomic, strong) NSURL *coverPhotoURL;
@property (nonatomic, strong) NSMutableDictionary *images;

#pragma mark - Methods

#pragma mark Instance Methods

- (UIImage *) coverPhoto;
- (UIImage *) coverPhotoWithSize: (CGSize) size;
- (NSString *) dictionaryKey;
- (NSArray *) imagesArray;
- (void) readFromDictionary: (NSDictionary *) dictionary;
- (NSString *) rentToCurrencyString;

@end
