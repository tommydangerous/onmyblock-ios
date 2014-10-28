//
//  OMBAppDelegate.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 10/17/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import <FacebookSDK/FacebookSDK.h>
#import <UIKit/UIKit.h>
// #import <VenmoAppSwitch/Venmo.h>

extern NSString *const FBSessionStateChangedNotification;

@class OMBOffer;
@class OMBViewControllerContainer;

@interface OMBAppDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic, strong) OMBViewControllerContainer *container;
@property (nonatomic, strong) OMBOffer *currentOfferBeingPaidFor;
// @property (nonatomic, strong) VenmoClient *venmoClient;
@property (nonatomic, strong) UIWindow *window;

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) clearFacebookTokenInformation;
- (void) openSession;
- (void) registerForPushNotifications;
- (void) showLogin;
- (void) showSignUp;

@end
