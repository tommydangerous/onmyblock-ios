//
//  OMBUser.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 10/30/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
  OMBUserOfferTypeAccepted,
  OMBUserOfferTypeReceived
} OMBUserOfferType;

extern NSString *const OMBActivityIndicatorViewStartAnimatingNotification;
extern NSString *const OMBActivityIndicatorViewStopAnimatingNotification;
extern NSString *const OMBCurrentUserChangedFavorite;
extern NSString *const OMBCurrentUserLogoutNotification;
extern NSString *const OMBFakeUserAccessToken;
extern NSString *const OMBMessagesUnviewedCountNotification;
extern NSString *const OMBUserLoggedInNotification;
extern NSString *const OMBUserLoggedOutNotification;

@class OMBCosigner;
@class OMBEmployment;
@class OMBFavoriteResidence;
@class OMBLegalAnswer;
@class OMBMessage;
@class OMBNeighborhood;
@class OMBOffer;
@class OMBPreviousRental;
@class OMBRenterApplication;
@class OMBResidence;

@interface OMBUser : NSObject

@property (nonatomic, strong) NSString *about;
@property (nonatomic, strong) NSString *accessToken;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *facebookAccessToken;
@property (nonatomic, strong) NSString *facebookId;
@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *school;
@property (nonatomic, strong) NSString *userType;

@property (nonatomic, strong) NSMutableDictionary *acceptedOffers;
@property (nonatomic, strong) OMBNeighborhood *currentLocation;
@property (nonatomic, strong) NSMutableDictionary *favorites;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSMutableDictionary *imageSizeDictionary;
@property (nonatomic, strong) NSURL *imageURL;
@property (nonatomic, strong) NSMutableDictionary *messages;
@property (nonatomic, strong) NSTimer *notificationFetchTimer;
@property (nonatomic, strong) NSMutableDictionary *receivedOffers;
@property (nonatomic, strong) OMBRenterApplication *renterApplication;
@property (nonatomic, strong) NSMutableDictionary *residences;
@property (nonatomic) int uid;

#pragma mark - Methods

#pragma mark - Class Methods

+ (OMBUser *) currentUser;
+ (void) fakeLogin;
+ (OMBUser *) fakeUser;
+ (OMBUser *) landlordUser;

#pragma mark - Instance Methods

- (void) acceptOffer: (OMBOffer *) offer 
withCompletion: (void (^) (NSError *error)) block;
- (void) addCosigner: (OMBCosigner *) cosigner;
- (void) addEmployment: (OMBEmployment *) employment;
- (void) addLegalAnswer: (OMBLegalAnswer *) object;
- (void) addMessage: (OMBMessage *) message;
- (void) addPreviousRental: (OMBPreviousRental *) previousRental;
- (void) addReceivedOffer: (OMBOffer *) offer;
- (void) addFavoriteResidence: (OMBFavoriteResidence *) favoriteResidence;
- (void) addResidence: (OMBResidence *) residence;
- (BOOL) alreadyFavoritedResidence: (OMBResidence *) residence;
- (void) declineOffer: (OMBOffer *) offer
withCompletion: (void (^) (NSError *error)) block;
- (void) downloadImageFromImageURLWithCompletion: 
(void (^) (NSError *error)) block;
- (NSArray *) favoritesArray;
- (void) fetchAcceptedOffersWithCompletion: (void (^) (NSError *error)) block;
- (void) fetchMessagesAtPage: (NSInteger) page withUser: (OMBUser *) user
delegate: (id) delegate completion: (void (^) (NSError *error)) block;
- (NSString *) fullName;
- (UIImage *) imageForSize: (CGSize) size;
- (UIImage *) imageForSizeKey: (NSString *) string;
- (BOOL) loggedIn;
- (void) logout;
- (NSArray *) messagesWithUser: (OMBUser *) user;
- (NSString *) phoneString;
- (void) readFromAcceptedOffersDictionary: (NSDictionary *) dictionary;
- (void) readFromCosignerDictionary: (NSDictionary *) dictionary;
- (void) readFromDictionary: (NSDictionary *) dictionary;
- (void) readFromEmploymentDictionary: (NSDictionary *) dictionary;
- (void) readFromFavoriteResidencesDictionary: (NSDictionary *) dictionary;
- (void) readFromLegalAnswerDictionary: (NSDictionary *) dictionary;
- (void) readFromMessagesDictionary: (NSDictionary *) dictionary;
- (void) readFromPreviousRentalDictionary: (NSDictionary *) dictionary;
- (void) readFromReceivedOffersDictionary: (NSDictionary *) dictionary;
- (void) readFromResidencesDictionary: (NSDictionary *) dictionary;
- (void) rejectOffer: (OMBOffer *) offer 
withCompletion: (void (^) (NSError *error)) block;
- (void) removeAllReceivedOffersWithOffer: (OMBOffer *) offer;
- (void) removeOffer: (OMBOffer *) offer type: (OMBUserOfferType) type;
- (void) removeReceivedOffer: (OMBOffer *) offer;
- (void) removeResidence: (OMBResidence *) residence;
- (void) removeResidenceFromFavorite: (OMBResidence *) residence;
- (NSArray *) residencesSortedWithKey: (NSString *) key 
ascending: (BOOL) ascending;
- (NSString *) shortName;
- (NSArray *) sortedOffersType: (OMBUserOfferType) type 
withKey: (NSString *) key ascending: (BOOL) ascending;

@end
