//
//  OMBResidence.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 10/21/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import <Foundation/Foundation.h>

@class OMBResidenceImage;

@interface OMBResidence : NSObject

// Web app properties
@property (nonatomic, strong) NSString *address;
@property (nonatomic) NSTimeInterval availableOn;
@property (nonatomic) float bathrooms;
@property (nonatomic) float bedrooms;
@property (nonatomic) BOOL cats;
@property (nonatomic, strong) NSString *city;
@property (nonatomic) NSTimeInterval createdAt;
@property (nonatomic, strong) NSString *description;
@property (nonatomic) BOOL dogs;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *landlordName;
@property (nonatomic) float latitude;
@property (nonatomic) int leaseMonths;
@property (nonatomic) float longitude;
@property (nonatomic) NSTimeInterval moveInDate;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *propertyType;
@property (nonatomic) float rent;
@property (nonatomic) int squareFeet;
@property (nonatomic, strong) NSString *state;
@property (nonatomic, strong) NSString *title;
@property (nonatomic) int uid; // ID
@property (nonatomic, strong) NSString *unit;
@property (nonatomic) NSTimeInterval updatedAt;
@property (nonatomic, strong) NSString *zip;

// iOS app properties
@property (nonatomic, strong) NSMutableDictionary *amenities;
@property (nonatomic, strong) UIImage *coverPhotoForCell;
@property (nonatomic, strong) NSURL *coverPhotoURL;
@property (nonatomic, strong) NSMutableArray *images;
@property (nonatomic, strong) NSMutableDictionary *imageSizeDictionary;
@property (nonatomic) int lastImagePosition;

#pragma mark - Methods

#pragma mark - Class Methods

+ (NSArray *) defaultListOfAmenities;
+ (OMBResidence *) fakeResidence;

#pragma mark Instance Methods

// - (void) addImage: (UIImage *) image atPosition: (int) position 
// withString: (NSString *) string;
- (void) addResidenceImage: (OMBResidenceImage *) residenceImage;
- (NSString *) availableOnString;
- (UIImage *) coverPhoto;
- (UIImage *) coverPhotoWithSize: (CGSize) size;
- (NSString *) defaultContactMessage;
- (NSString *) dictionaryKey;
- (NSURL *) googleStaticMapImageURL;
- (NSURL *) googleStaticStreetViewImageURL;
- (NSArray *) imagesArray;
- (UIImage *) imageAtPosition: (int) position;
- (UIImage *) imageForSize: (CGFloat) size;
- (void) readFromPropertyDictionary: (NSDictionary *) dictionary;
- (void) readFromResidenceDictionary: (NSDictionary *) dictionary;
- (void) removeResidenceImage: (OMBResidenceImage *) residenceImage;
- (NSString *) rentToCurrencyString;

@end
