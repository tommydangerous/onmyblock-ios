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
@property (nonatomic, strong) NSString *city;
@property (nonatomic) NSTimeInterval createdAt;
@property (nonatomic, strong) NSString *description;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *landlordName;
@property (nonatomic) float latitude;
@property (nonatomic) int leaseMonths;
@property (nonatomic) float longitude;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic) float rent;
@property (nonatomic) int squareFeet;
@property (nonatomic, strong) NSString *state;
@property (nonatomic) int uid; // ID
@property (nonatomic) NSTimeInterval updatedAt;
@property (nonatomic, strong) NSString *zip;

// iOS app properties
@property (nonatomic, strong) UIImage *coverPhotoForCell;
@property (nonatomic, strong) NSURL *coverPhotoURL;
@property (nonatomic, strong) NSMutableDictionary *images;
@property (nonatomic) int lastImagePosition;

#pragma mark - Methods

#pragma mark Instance Methods

- (NSString *) availableOnString;
- (UIImage *) coverPhoto;
- (UIImage *) coverPhotoWithSize: (CGSize) size;
- (NSString *) defaultContactMessage;
- (NSString *) dictionaryKey;
- (NSURL *) googleStaticMapImageURL;
- (NSURL *) googleStaticStreetViewImageURL;
- (NSArray *) imagesArray;
- (void) readFromPropertyDictionary: (NSDictionary *) dictionary;
- (void) readFromResidenceDictionary: (NSDictionary *) dictionary;
- (NSString *) rentToCurrencyString;

@end
