//
//  OMBUser.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 10/30/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const OMBActivityIndicatorViewStartAnimatingNotification;
extern NSString *const OMBActivityIndicatorViewStopAnimatingNotification;
extern NSString *const OMBCurrentUserChangedFavorite;
extern NSString *const OMBCurrentUserLogoutNotification;
extern NSString *const OMBUserLoggedInNotification;
extern NSString *const OMBUserLoggedOutNotification;

@class OMBCosigner;
@class OMBEmployment;
@class OMBFavoriteResidence;
@class OMBLegalAnswer;
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

@property (nonatomic, strong) NSMutableDictionary *favorites;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSURL *imageURL;
@property (nonatomic, strong) OMBRenterApplication *renterApplication;
@property (nonatomic) int uid;

#pragma mark - Methods

#pragma mark - Class Methods

+ (OMBUser *) currentUser;
+ (void) fakeLogin;
+ (OMBUser *) fakeUser;

#pragma mark - Instance Methods

- (void) addCosigner: (OMBCosigner *) cosigner;
- (void) addEmployment: (OMBEmployment *) employment;
- (void) addLegalAnswer: (OMBLegalAnswer *) object;
- (void) addPreviousRental: (OMBPreviousRental *) previousRental;
- (void) addFavoriteResidence: (OMBFavoriteResidence *) favoriteResidence;
- (BOOL) alreadyFavoritedResidence: (OMBResidence *) residence;
- (void) downloadImageFromImageURLWithCompletion: 
(void (^) (NSError *error)) block;
- (NSArray *) favoritesArray;
- (NSString *) fullName;
- (BOOL) loggedIn;
- (void) logout;
- (NSString *) phoneString;
- (void) readFromCosignerDictionary: (NSDictionary *) dictionary;
- (void) readFromDictionary: (NSDictionary *) dictionary;
- (void) readFromEmploymentDictionary: (NSDictionary *) dictionary;
- (void) readFromLegalAnswerDictionary: (NSDictionary *) dictionary;
- (void) readFromPreviousRentalDictionary: (NSDictionary *) dictionary;
- (void) readFromResidencesDictionary: (NSDictionary *) dictionary;
- (void) removeResidenceFromFavorite: (OMBResidence *) residence;
- (NSString *) shortName;

@end
