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
extern NSString *const OMBCurrentUserLandlordTypeChangeNotification;
extern NSString *const OMBCurrentUserLogoutNotification;
extern NSString *const OMBCurrentUserUploadedImage;
extern NSString *const OMBFakeUserAccessToken;
extern NSString *const OMBMessagesUnviewedCountNotification;
extern NSString *const OMBUserCreateAuthenticationForFacebookNotification;
extern NSString *const OMBUserLoggedInNotification;
extern NSString *const OMBUserLoggedOutNotification;
extern NSString *const OMBUserTypeLandlord;
extern NSString *const OMBOffersLandordPendingCountNotification;
extern NSString *const OMBOffersRenterAcceptedCountNotification;

@class OMBCosigner;
@class OMBEmployment;
@class OMBFavoriteResidence;
@class OMBLegalAnswer;
@class OMBMessage;
@class OMBNeighborhood;
@class OMBOffer;
@class OMBPayoutMethod;
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
@property (nonatomic, strong) NSString *landlordType;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *school;
@property (nonatomic, strong) NSString *userType;

@property (nonatomic, strong) NSMutableDictionary *acceptedOffers;
@property (nonatomic, strong) NSMutableDictionary *confirmedTenants;
@property (nonatomic, strong) OMBNeighborhood *currentLocation;
@property (nonatomic, strong) NSMutableDictionary *depositPayoutTransactions;
@property (nonatomic, strong) NSMutableDictionary *favorites;
@property (nonatomic) BOOL hasDefaultImage;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSMutableDictionary *imageSizeDictionary;
@property (nonatomic, strong) NSURL *imageURL;
@property (nonatomic, strong) NSMutableDictionary *messages;
@property (nonatomic, strong) NSMutableDictionary *movedIn;
@property (nonatomic, strong) NSMutableDictionary *movedInOut;
@property (nonatomic, strong) NSTimer *notificationFetchTimer;
@property (nonatomic, strong) NSMutableDictionary *payoutMethods;
@property (nonatomic, strong) NSMutableDictionary *receivedOffers;
@property (nonatomic, strong) OMBRenterApplication *renterApplication;
@property (nonatomic, strong) NSMutableDictionary *residences;
@property (nonatomic, strong) NSMutableDictionary *heightForAboutTextDictionary;
@property (nonatomic) int uid;

#pragma mark - Methods

#pragma mark - Class Methods

+ (OMBUser *) currentUser;
+ (UIImage *) defaultUserImage;
+ (void) fakeLogin;
+ (OMBUser *) fakeUser;
+ (OMBUser *) landlordUser;
+ (UIImage *) placeholderImage;
+ (NSString *) pushNotificationChannelForConversations: (NSUInteger) userUID;
+ (NSString *) pushNotificationChannelForOffersPlaced: (NSUInteger) userUID;
+ (NSString *) pushNotificationChannelForOffersReceived: (NSUInteger) userUID;

#pragma mark - Instance Methods

- (void) acceptOffer: (OMBOffer *) offer
  withCompletion: (void (^) (NSError *error)) block;
- (void) addEmployment: (OMBEmployment *) employment;
- (void) addLegalAnswer: (OMBLegalAnswer *) object;
// - (void) addMessage: (OMBMessage *) message;
- (void) addMovedInOutDates: (OMBOffer *) object;
- (void) addReceivedOffer: (OMBOffer *) offer;
- (void) addFavoriteResidence: (OMBFavoriteResidence *) favoriteResidence;
- (void) addResidence: (OMBResidence *) residence;
- (BOOL) alreadyFavoritedResidence: (OMBResidence *) residence;
- (void) authenticateVenmoWithCode: (NSString *) code
depositMethod: (BOOL) deposit withCompletion: (void (^) (NSError *error)) block;
- (void) changeOtherSamePrimaryPayoutMethods: (OMBPayoutMethod *) payoutMethod;
- (void) checkForUserDefaultsAPIKey;
- (BOOL) compareUser: (OMBUser *) user;
- (void) confirmOffer: (OMBOffer *) offer
withCompletion: (void (^) (NSError *error)) block;
- (void) createAuthenticationForFacebookWithCompletion:
  (void (^) (NSError *error)) block;
- (void) createAuthenticationForLinkedInWithAccessToken: (NSString *) string
  completion: (void (^) (NSError *error)) block;
- (void) createOffer: (OMBOffer *) offer
  completion: (void (^) (NSError *error)) block;
- (void) createPayoutMethodWithDictionary: (NSDictionary *) dictionary
withCompletion: (void (^) (NSError *error)) block;
- (void) declineAndPutOtherOffersOnHold: (OMBOffer *) offer;
- (void) declineOffer: (OMBOffer *) offer
withCompletion: (void (^) (NSError *error)) block;
- (NSArray *) depositPayoutMethods;
- (void) downloadImageFromImageURLWithCompletion:
(void (^) (NSError *error)) block;
- (BOOL) emailContactPermission;
- (NSArray *) favoritesArray;
- (void) fetchAcceptedOffersWithCompletion: (void (^) (NSError *error)) block;
- (void) fetchConfirmedTenantsWithCompletion: (void (^) (NSError *error)) block;
- (void) fetchCurrentUserInfo;
- (void) fetchEmploymentsWithCompletion: (void (^) (NSError *error)) block;
- (void) fetchLegalAnswersWithCompletion: (void (^) (NSError *error)) block;
- (void) fetchMovedInWithCompletion: (void (^) (NSError *error)) block;
- (void) fetchPayoutMethodsWithCompletion: (void (^) (NSError *error)) block;
- (void) fetchDepositPayoutTransactionsWithCompletion:
  (void (^) (NSError *error)) block;
- (void) fetchListingsWithCompletion: (void (^) (NSError *error)) block;
- (void) fetchReceivedOffersWithCompletion: (void (^) (NSError *error)) block;
- (void) fetchMessagesAtPage: (NSInteger) page withUser: (OMBUser *) user
delegate: (id) delegate completion: (void (^) (NSError *error)) block;
- (void) fetchUserProfileWithCompletion: (void (^) (NSError *error)) block;
- (NSString *) fullName;
- (BOOL) hasLandlordType;
- (BOOL) hasSentApplicationsInResidence:(OMBResidence *)residence;
- (CGFloat) heightForAboutTextWithWidth: (CGFloat) width;
- (UIImage *) imageForSize: (CGSize) size;
- (UIImage *) imageForSizeKey: (NSString *) string;
- (BOOL) isCurrentUser;
- (BOOL) isLandlord;
- (BOOL) loggedIn;
- (void) logout;
- (NSArray *) messagesWithUser: (OMBUser *) user;
- (NSArray *) paymentPayoutMethods;
- (NSString *) phoneString;
- (void) postLandlordTypeChangeNotification;
- (OMBPayoutMethod *) primaryDepositPayoutMethod;
- (OMBPayoutMethod *) primaryPaymentPayoutMethod;
- (NSInteger) profilePercentage;
- (void) readFromAcceptedOffersDictionary: (NSDictionary *) dictionary;
- (void) readFromConfirmedTenantsDictionary: (NSDictionary *) dictionary;
- (void) readFromDepositPayoutTransactionDictionary:
(NSDictionary *) dictionary;
- (void) readFromDictionary: (NSDictionary *) dictionary;
- (void) readFromEmploymentDictionary: (NSDictionary *) dictionary;
- (void) readFromFavoriteResidencesDictionary: (NSDictionary *) dictionary;
- (void) readFromLegalAnswerDictionary: (NSDictionary *) dictionary;
- (void) readFromMessagesDictionary: (NSDictionary *) dictionary;
- (void) readFromMovedInDictionary: (NSDictionary *) dictionary;
- (void) readFromPayoutMethodsDictionary: (NSDictionary *) dictionary;
- (void) readFromReceivedOffersDictionary: (NSDictionary *) dictionary;
- (void) readFromResidencesDictionary: (NSDictionary *) dictionary;
- (void) rejectOffer: (OMBOffer *) offer
withCompletion: (void (^) (NSError *error)) block;
- (void) removeAllReceivedOffersWithOffer: (OMBOffer *) offer;
- (void) removeOffer: (OMBOffer *) offer type: (OMBUserOfferType) type;
- (void) removeReceivedOffer: (OMBOffer *) offer;
- (void) removeResidence: (OMBResidence *) residence;
- (void) removeResidenceFromFavorite: (OMBResidence *) residence;
- (NSArray *) residencesActive: (BOOL) active sortedWithKey: (NSString *) key
  ascending: (BOOL) ascending;
- (NSArray *) residencesSortedWithKey: (NSString *) key
  ascending: (BOOL) ascending;
- (NSString *) shortName;
- (NSArray *) sortedOffersType: (OMBUserOfferType) type
  withKeys: (NSArray *) keys ascending: (BOOL) ascending;
- (NSArray *) sortedPayoutMethodsWithKey: (NSString *) key
ascending: (BOOL) ascending;
- (void) updateWithDictionary: (NSDictionary *) dictionary
completion: (void (^) (NSError *error)) block;
- (void) uploadImage: (UIImage *) img
withCompletion: (void (^) (NSError *error)) block;

@end
