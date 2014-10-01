//
//  OMBResidence.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 10/21/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "UIImageView+WebCache.h"

@class OMBCenteredImageView;
@class OMBOffer;
@class OMBOpenHouse;
@class OMBResidenceCoverPhotoURLConnection;
@class OMBResidenceImage;
@class OMBSentApplication;
@class OMBUser;

extern NSString *const OMBResidencePropertyTypeApartment;
extern NSString *const OMBResidencePropertyTypeHouse;
extern NSString *const OMBResidencePropertyTypeSublet;

@interface OMBResidence : NSObject
{
  OMBResidenceCoverPhotoURLConnection *coverPhotoURLConnection;
}

// Web app properties
@property (nonatomic, strong) NSString *address;
@property (nonatomic) NSInteger auctionDuration;
@property (nonatomic) NSTimeInterval auctionStartDate;
@property (nonatomic) NSTimeInterval availableOn;
@property (nonatomic) float bathrooms;
@property (nonatomic) float bedrooms;
@property (nonatomic) BOOL cats;
@property (nonatomic, strong) NSString *city;
@property (nonatomic) NSTimeInterval createdAt;
@property (nonatomic) CGFloat deposit;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic) BOOL dogs;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *externalSource;
@property (nonatomic) BOOL inactive;
@property (nonatomic) BOOL isAuction;
@property (nonatomic, strong) NSString *landlordName;
@property (nonatomic) NSInteger landlordUserID;
@property (nonatomic) float latitude;
@property (nonatomic) int leaseMonths;
@property (nonatomic, strong) NSString *leaseType;
@property (nonatomic) float longitude;
@property (nonatomic) CGFloat minRent;
@property (nonatomic) NSTimeInterval moveInDate;
@property (nonatomic) NSTimeInterval moveOutDate;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *propertyType;
@property (nonatomic) BOOL rented;
// If rentItNow is YES, the "Apply Now" button should appear instead of Book It
@property (nonatomic) BOOL rentItNow;
@property (nonatomic) CGFloat rentItNowPrice;
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
@property (nonatomic, strong) NSMutableDictionary *coverPhotoSizeDictionary;
@property (nonatomic, strong) NSURL *coverPhotoURL;
@property (nonatomic, strong) NSMutableArray *images;
@property (nonatomic, strong) NSMutableDictionary *imageSizeDictionary;
@property (nonatomic) BOOL hasNoImage;
@property (nonatomic) int lastImagePosition;
@property (nonatomic, strong) NSMutableArray *offers;
@property (nonatomic, strong) NSMutableArray *openHouseDates;
@property (nonatomic, strong) OMBSentApplication *sentApplication;
@property (nonatomic, strong) OMBUser *user;

#pragma mark - Methods

#pragma mark - Class Methods

+ (OMBResidence *) fakeResidence;
+ (NSInteger) numberOfSteps;
+ (UIImage *) placeholderImage;

#pragma mark - Instance Methods

#pragma mark - Public

- (BOOL) isAboveThreshold;

- (void) addAmenity: (NSString *) amenity;
- (void) addImageWithResidenceImage: (OMBResidenceImage *) residenceImage
toImageSizeDictionaryWithSize: (CGSize) size;
- (void) addOffer: (OMBOffer *) offer;
- (void) addOpenHouse: (OMBOpenHouse *) openHouse;
- (void) addResidenceImage: (OMBResidenceImage *) residenceImage;
- (NSString *) addressOrTitle;
- (NSUInteger) amenityCount;
- (NSArray *) availableAmenities;
- (NSString *) availableOnString;
- (void) cancelCoverPhotoDownload;
- (UIImage *) coverPhoto;
- (UIImage *) coverPhotoForSize: (CGSize) size;
- (UIImage *) coverPhotoForSizeKey: (NSString *) string;
- (NSString *) dictionaryKey;
- (void) downloadCoverPhotoWithCompletion: (void (^) (NSError *error)) block;
- (void) downloadImagesWithCompletion: (void (^) (NSError *error)) block;
- (void) fetchDetailsWithCompletion: (void (^) (NSError *error)) block;
- (void) fetchOffersWithCompletion: (void (^) (NSError *error)) block;
- (NSURL *) googleStaticMapImageURL;
- (NSURL *) googleStaticStreetViewImageURL;
- (BOOL) hasAmenity: (NSString *) amenity;
- (NSArray *) imagesArray;
- (UIImage *) imageAtPosition: (int) position;
- (UIImage *) imageForSize: (CGSize) size
  forResidenceImage: (OMBResidenceImage *) residenceImage;
- (UIImage *) imageForSizeKey: (NSString *) string
  forResidenceImage: (OMBResidenceImage *) residenceImage;
- (BOOL) isFromExternalSource;
- (BOOL) isSublet;
- (NSString *) leaseMonthsStringShort;
- (NSString *) legalDetailsShareString;
- (NSDate *) moveOutDateDate;
- (NSInteger) numberOfStepsLeft;
- (UIImage *) photoAtIndex:(NSInteger)index withSize:(CGSize) size;
- (void) readFromDictionaryLightning: (NSDictionary *) dictionary;
- (void) readFromOffersDictionary: (NSDictionary *) dictionary;
- (void) readFromOpenHouseDictionary: (NSDictionary *) dictionary;
- (void) readFromPropertyDictionary: (NSDictionary *) dictionary;
- (void) readFromResidenceDictionary: (NSDictionary *) dictionary;
- (void) removeResidenceImage: (OMBResidenceImage *) residenceImage;
- (void) removeAmenity: (NSString *) amenity;
- (NSString *) rentToCurrencyString;
- (void) setImageForCenteredImageView: (OMBCenteredImageView *) imageView
withURL: (NSURL *) url completion: (void (^)(void)) block;
- (NSString *) shareString;
- (NSArray *) sortedOffers;
- (NSArray *) sortedOpenHouseDates;
- (NSString *) stateFormattedString;
- (NSString *) statusString;
- (NSString *) titleOrAddress;
- (void) updateAttributes: (NSArray *) attributes
completion: (void (^) (NSError *error)) block;
- (void) updateCoverPhotoURL;
- (void) updateResidenceWithResidence: (OMBResidence *) residence;
- (BOOL) validTitle;

@end
