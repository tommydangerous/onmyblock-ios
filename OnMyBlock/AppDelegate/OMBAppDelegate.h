//
//  OMBAppDelegate.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 10/17/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import <FacebookSDK/FacebookSDK.h>
#import <UIKit/UIKit.h>
#import <VenmoAppSwitch/Venmo.h>

extern NSString *const FBSessionStateChangedNotification;
extern NSString *const OMBUserDefaults;
extern NSString *const OMBUserDefaultsAPIKey;
extern NSString *const OMBUserDefaultsAPIKeyAccessToken;
extern NSString *const OMBUserDefaultsAPIKeyExpiresAt;
extern NSString *const OMBUserDefaultsViewedIntro;

@class OMBOffer;
@class OMBViewControllerContainer;

@interface OMBAppDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic, strong) OMBViewControllerContainer *container;
@property (nonatomic, strong) OMBOffer *currentOfferBeingPaidFor;
@property (nonatomic, strong) VenmoClient *venmoClient;
@property (nonatomic, strong) UIWindow *window;

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) clearFacebookTokenInformation;
- (void) openSession;
- (void) showLogin;
- (void) showSignUp;

@end

// UIFont size - line height
// 13 - 17
// 14 - 18
// 15 - 20
// 18 - 23
// 20 - 26
// 27 - 33