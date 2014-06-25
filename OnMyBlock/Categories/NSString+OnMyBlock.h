//
//  NSString+OnMyBlock.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 4/3/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import <Foundation/Foundation.h>

// Notifications
// Users
extern NSString *const OMBUserSubscribeToPushNotificationChannels;

// Parse
extern NSString *const ParseApplicationId;
extern NSString *const ParseBadgeIncrement;
extern NSString *const ParseChannelsKey;
extern NSString *const ParseClientKey;

// PayPal
extern NSString *const PayPalClientID;
extern NSString *const PayPalClientIDSandbox;
extern NSString *const PayPalReceiverEmail;

// User defaults
extern NSString *const OMBUserDefaults;
// API key
extern NSString *const OMBUserDefaultsAPIKey;
extern NSString *const OMBUserDefaultsAPIKeyAccessToken;
extern NSString *const OMBUserDefaultsAPIKeyExpiresAt;
// Offer price threshold
extern NSString *const OMBOfferPriceThreshold;
// Permission dialogs
extern NSString *const OMBUserDefaultsPermission;
extern NSString *const OMBUserDefaultsPermissionCurrentLocation;
extern NSString *const OMBUserDefaultsPermissionPushNotifications;
// Renter application
extern NSString *const OMBUserDefaultsRenterApplication;
extern NSString *const OMBUserDefaultsRenterApplicationCheckedCoapplicants;
extern NSString *const OMBUserDefaultsRenterApplicationCheckedCosigners;
extern NSString *const OMBUserDefaultsRenterApplicationCheckedLegalQuestions;
extern NSString *const OMBUserDefaultsRenterApplicationCheckedRentalHistory;
extern NSString *const OMBUserDefaultsRenterApplicationCheckedWorkHistory;
extern NSString *const OMBUserDefaultsRenterApplicationCreated;
// Intro
extern NSString *const OMBUserDefaultsViewedIntro;

// Venmo
extern NSString *const VenmoClientID;
extern NSString *const VenmoClientSecret;

@interface NSString (OnMyBlock)

@end
