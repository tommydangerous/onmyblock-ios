//
//  OMBAppDelegate.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 10/17/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import <NewRelicAgent/NewRelicAgent.h>
#import "GAI.h"
#import "TestFlight.h"

#import "OMBAppDelegate.h"
#import "OMBIntroStillImagesViewController.h"
#import "OMBLoginViewController.h"
#import "OMBViewControllerContainer.h"
#import "OMBUser.h"
#import "UIColor+Extensions.h"

NSString *const FBSessionStateChangedNotification = 
  @"com.onmyblock.Login:FBSessionStateChangedNotification";
NSString *const OMBUserDefaults = @"OMBUserDefaults";
NSString *const OMBUserDefaultsAPIKey = @"OMBUserDefaultsAPIKey";
NSString *const OMBUserDefaultsAPIKeyAccessToken = 
  @"OMBUserDefaultsAPIKeyAccessToken";
NSString *const OMBUserDefaultsAPIKeyExpiresAt = 
  @"OMBUserDefaultsAPIKeyExpiresAt";
NSString *const OMBUserDefaultsViewedIntro = @"OMBUserDefaultsViewedIntro";

@implementation OMBAppDelegate

@synthesize container = _container;

- (BOOL) application: (UIApplication *) application 
didFinishLaunchingWithOptions: (NSDictionary *) launchOptions
{
  #warning Add these back when in production
  // [self setupTracking];
  // [self testFlightTakeOff];
    
  CGRect screen = [[UIScreen mainScreen] bounds];
  self.window   = [[UIWindow alloc] initWithFrame: screen];

  _container = [[OMBViewControllerContainer alloc] init];

  // Set root view controller for app
  self.window.backgroundColor    = [UIColor backgroundColor];
  self.window.rootViewController = _container;
  [self.window makeKeyAndVisible];

  // Facebook
  if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded)
    // If current session has a valid Facebook token
    [self openSession];

  // #warning Remove fake login
  // [OMBUser fakeLogin]; // Fake login
  // Use this to show whatever view controller you are working on
  // [_container showHomebaseRenter];
  // [_container showIntroAnimatedDissolve: NO];

  // Check to see if the user has a saved api key in the user defaults
  [[OMBUser currentUser] checkForUserDefaultsAPIKey];

  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  // NSLog(@"%@", [defaults objectForKey: @"OMBUserDefaultsAPIKey"]);
  
  id viewedIntro = [defaults objectForKey: OMBUserDefaultsViewedIntro];
  if (!viewedIntro) {
    [defaults setObject: [NSNumber numberWithBool: NO] 
      forKey: OMBUserDefaultsViewedIntro];
  }
  NSNumber *number = [defaults objectForKey: OMBUserDefaultsViewedIntro];
  if (![number boolValue]) {
    if (![[OMBUser currentUser] loggedIn])
      [_container showIntroAnimatedDissolve: NO];
    [[NSUserDefaults standardUserDefaults] setObject:
      [NSNumber numberWithBool: YES] forKey: OMBUserDefaultsViewedIntro];
  }
  [defaults synchronize];

  return YES;
}

- (BOOL) application: (UIApplication *) application openURL: (NSURL *) url
sourceApplication: (NSString *) sourceApplication annotation: (id) annotation
{
  // Delegate method to call the Facebook session object 
  // that handles the incoming URL
  // [[NSNotificationCenter defaultCenter] postNotificationName:
  //   OMBActivityIndicatorViewStartAnimatingNotification object: nil];
  return [FBSession.activeSession handleOpenURL: url];

  // Venmo App Switch
  // NSLog(@"openURL: %@", url);
  // return [_venmoClient openURL: url completionHandler:
  //   ^(VenmoTransaction *transaction, NSError *error) {
  //     if (transaction) {
  //       NSString *success = (transaction.success ? @"Success" : @"Failure");
  //       NSString *title = [@"Transaction " stringByAppendingString: success];
  //       NSString *message = [@"payment_id: " stringByAppendingFormat:
  //         @"%@. %@ %@ %@ (%@) $%@ %@",
  //          transaction.transactionID,
  //          transaction.fromUserID,
  //          transaction.typeStringPast,
  //          transaction.toUserHandle,
  //          transaction.toUserID,
  //          transaction.amountString,
  //          transaction.note];
  //       UIAlertView *alertView = [[UIAlertView alloc] initWithTitle: title 
  //         message: message delegate: nil cancelButtonTitle: @"OK"
  //           otherButtonTitles: nil];
  //       [alertView show];
  //     }
  //     // Error
  //     else {
  //       NSLog(@"transaction error code: %i", error.code);
  //     }
  //   }
  // ];
}

- (void) applicationWillResignActive: (UIApplication *) application
{
}

- (void) applicationDidEnterBackground: (UIApplication *) application
{
}

- (void) applicationWillEnterForeground: (UIApplication *) application
{
}

- (void) applicationDidBecomeActive: (UIApplication *) application
{
  // Stop all the spinners
  [[NSNotificationCenter defaultCenter] postNotificationName:
    OMBActivityIndicatorViewStopAnimatingNotification object: nil];
  [_container stopSpinning];
}

- (void) applicationWillTerminate: (UIApplication *) application
{
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) clearFacebookTokenInformation
{
  [FBSession.activeSession closeAndClearTokenInformation];
  // Need to clear the cookie stored in Safari
  NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
  for (NSHTTPCookie *cookie in [storage cookies]) {
    NSString *domainName = [cookie domain];
    NSRange domainRange = [domainName rangeOfString: @"facebook"];
    if (domainRange.length > 0) {
      [storage deleteCookie:cookie];
    }
  }
}

- (void) hideIntro
{
  [_container.introViewController dismissViewControllerAnimated: NO
    completion: nil];
}

- (void) hideLogin
{
  [_container.loginViewController dismissViewControllerAnimated: NO
    completion: nil];
}

- (void) openSession
{
  NSArray *facebookPermissions = @[
    @"email",
    @"user_education_history",
    @"user_location",
    @"user_work_history"
  ];
  [FBSession openActiveSessionWithReadPermissions: facebookPermissions
    allowLoginUI: YES completionHandler: 
      ^(FBSession *session, FBSessionState state, NSError *error) {
        [self sessionStateChanged: session state: state error: error];
      }
    ];
}

- (void) sessionStateChanged: (FBSession *) session
state: (FBSessionState) state error: (NSError *) error
{
  NSLog(@"Session state changed");
  switch (state) {
    // If the user was or is logged in
    case FBSessionStateOpen: {
      [OMBUser currentUser];
      // Dismiss the intro view controller
      // [self hideIntro];
      // Dismiss login view controller
      // [self hideLogin];
      break;
    }
    case FBSessionStateClosed:
    case FBSessionStateClosedLoginFailed:
      [self clearFacebookTokenInformation];
      break;
    default:
      break;
  }
  // The user model listens for this notification
  [[NSNotificationCenter defaultCenter] postNotificationName:
    FBSessionStateChangedNotification object: session];
  if (error) {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle: @"Error"
      message: error.localizedDescription delegate: nil
        cancelButtonTitle: @"Try again" otherButtonTitles: nil];
    [alertView show];
  }
}

- (void) setupTracking
{
  [NewRelicAgent startWithApplicationToken:
    @"AA232e12d9b2fba4fa3e73a8f3e6b102a75fc517a2"];

  // Optional: automatically send uncaught exceptions to Google Analytics.
  [GAI sharedInstance].trackUncaughtExceptions = YES;
  // Optional: set Google Analytics dispatch interval to e.g. 20 seconds.
  [GAI sharedInstance].dispatchInterval = 20;
  // Optional: set Logger to VERBOSE for debug information.
  [[[GAI sharedInstance] logger] setLogLevel: kGAILogLevelVerbose];
  // Initialize tracker.
  id <GAITracker> tracker = [[GAI sharedInstance] trackerWithTrackingId:
    @"UA-45382533-1"];
  NSLog(@"GAITracker: %@", tracker);
}

- (void) showLogin
{
  [_container showLogin];
}

- (void) showSignUp
{
  [_container showSignUp];
}

- (void) testFlightTakeOff
{
  [TestFlight takeOff: @"c093afcb-4e1f-449d-8663-cfe23e1dbd74"];
}

@end
