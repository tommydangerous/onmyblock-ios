//
//  OMBUser.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 10/30/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const OMBCurrentUserChangedFavorite;
extern NSString *const OMBCurrentUserLogoutNotification;
extern NSString *const OMBUserLoggedInNotification;
extern NSString *const OMBUserLoggedOutNotification;

@class OMBFavoriteResidence;
@class OMBResidence;

@interface OMBUser : NSObject

@property (nonatomic, strong) NSString *accessToken;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *facebookAccessToken;
@property (nonatomic, strong) NSString *facebookId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *userType;

@property (nonatomic, strong) NSMutableDictionary *favorites;
@property (nonatomic) int uid;

#pragma mark - Methods

#pragma mark - Class Methods

+ (OMBUser *) currentUser;

#pragma mark - Instance Methods

- (void) addFavoriteResidence: (OMBFavoriteResidence *) favoriteResidence;
- (BOOL) alreadyFavoritedResidence: (OMBResidence *) residence;
- (NSArray *) favoritesArray;
- (BOOL) loggedIn;
- (void) logout;
- (void) readFromDictionary: (NSDictionary *) dictionary;
- (void) readFromResidencesDictionary: (NSDictionary *) dictionary;
- (void) removeResidenceFromFavorite: (OMBResidence *) residence;

@end
