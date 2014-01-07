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

@implementation OMBAppDelegate

@synthesize container = _container;

- (BOOL) application: (UIApplication *) application 
didFinishLaunchingWithOptions: (NSDictionary *) launchOptions
{
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

  NSLog(@"APP DELEGATE SHOW INTRO!");
  // Fake login
  [OMBUser fakeLogin];
  // [_container showHomebaseRenter];
  [_container showIntroAnimatedDissolve: NO];
  if ([[OMBUser currentUser] loggedIn])
    [self hideIntro];

  return YES;
}

- (BOOL) application: (UIApplication *) application openURL: (NSURL *) url
sourceApplication: (NSString *) sourceApplication annotation: (id) annotation
{
  // Delegate method to call the Facebook session object 
  // that handles the incoming URL
  return [FBSession.activeSession handleOpenURL: url];

  // Venmo App Switch
  NSLog(@"openURL: %@", url);
  return [_venmoClient openURL: url completionHandler:
    ^(VenmoTransaction *transaction, NSError *error) {
      if (transaction) {
        NSString *success = (transaction.success ? @"Success" : @"Failure");
        NSString *title = [@"Transaction " stringByAppendingString: success];
        NSString *message = [@"payment_id: " stringByAppendingFormat:
          @"%@. %@ %@ %@ (%@) $%@ %@",
           transaction.transactionID,
           transaction.fromUserID,
           transaction.typeStringPast,
           transaction.toUserHandle,
           transaction.toUserID,
           transaction.amountString,
           transaction.note];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle: title 
          message: message delegate: nil cancelButtonTitle: @"OK"
            otherButtonTitles: nil];
        [alertView show];
      }
      // Error
      else {
        NSLog(@"transaction error code: %i", error.code);
      }
    }
  ];
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
}

- (void) applicationWillTerminate: (UIApplication *) application
{
}

#pragma mark - Methods

#pragma mark - Instance Methods

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
  [FBSession openActiveSessionWithReadPermissions: @[@"email"] 
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
      [FBSession.activeSession closeAndClearTokenInformation];
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
