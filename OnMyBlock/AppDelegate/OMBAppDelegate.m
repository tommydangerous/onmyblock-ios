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

#import "NSError+OnMyBlock.h"
#import "NSString+Extensions.h"
#import "OMBAppDelegate.h"
#import "OMBIntroStillImagesViewController.h"
#import "OMBLoginViewController.h"
#import "OMBNavigationController.h"
#import "OMBOffer.h"
#import "OMBOfferVerifyVenmoConnection.h"
#import "OMBPayoutMethod.h"
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

- (BOOL) application: (UIApplication *) application 
didFinishLaunchingWithOptions: (NSDictionary *) launchOptions
{
  switch (__ENVIRONMENT__) {
    // Production
    case 3: {
      [self setupTracking];
      // Remove this when submitting to the App Store
      // [self testFlightTakeOff];
      break;
    }
    // Staging
    case 2: {
      [self testFlightTakeOff];
      break;
    }
    // Development
    case 1: {
      break;
    }
    default: {
      break;
    }
  }
    
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
  // [_container showOtherUserProfile];
  // [_container showIntroAnimatedDissolve: NO];

  // Check to see if the user has a saved api key in the user defaults
  [[OMBUser currentUser] checkForUserDefaultsAPIKey];

  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  // NSLog(@"%@", [defaults objectForKey: @"OMBUserDefaultsAPIKey"]);

  BOOL shouldShowIntro = NO;
  
  id viewedIntro = [defaults objectForKey: OMBUserDefaultsViewedIntro];
  if (!viewedIntro) {
    [defaults setObject: [NSNumber numberWithBool: NO] 
      forKey: OMBUserDefaultsViewedIntro];
  }
  NSNumber *number = [defaults objectForKey: OMBUserDefaultsViewedIntro];
  if (![number boolValue]) {
    if (![[OMBUser currentUser] loggedIn])
      shouldShowIntro = YES;
    [[NSUserDefaults standardUserDefaults] setObject:
      [NSNumber numberWithBool: YES] forKey: OMBUserDefaultsViewedIntro];
  }
  [defaults synchronize];

  if (shouldShowIntro)
    [_container showIntroAnimatedDissolve: NO];
  else
    [_container showDiscover];

  // Venmo
  _venmoClient = [VenmoClient clientWithAppId: VenmoClientID
    secret: VenmoClientSecret];

  // VenmoTransaction *venmoTransaction = [[VenmoTransaction alloc] init];
  // venmoTransaction.type = VenmoTransactionTypePay;
  // venmoTransaction.amount = [NSDecimalNumber decimalNumberWithString: 
  //   @"0.01"];
  // venmoTransaction.note = [NSString stringWithFormat: @"%@", [NSDate date]];
  // venmoTransaction.toUserHandle = @"tommy@onmyblock.com";

  // VenmoViewController *venmoViewController = 
  //   [_venmoClient viewControllerWithTransaction: venmoTransaction];
  // venmoViewController.completionHandler = 
  //   ^(VenmoViewController *viewController, BOOL canceled) {
  //     if (canceled) {
  //       NSLog(@"CANCELLLLLED");
  //     }
  //     [viewController dismissViewControllerAnimated: YES
  //       completion: nil];
  //   };
  // if (venmoViewController)
  //   [_container presentViewController: venmoViewController animated: YES
  //     completion: nil];

  // UIViewController *vc = [[UIViewController alloc] init];
  // UIView *view = [[UIView alloc] initWithFrame: screen];
  // vc.view = view;
  // self.window.rootViewController = vc;

  // //Create the container
  //   CALayer *container = [CALayer layer];
  //   container.frame = CGRectMake(0, 0, 640, 300);
  //   [view.layer addSublayer:container];

  //   CALayer *purplePlane = 
  //           [self addPlaneToLayer:container
  //           size:CGSizeMake(100, 100)
  //           position:CGPointMake(100, 100)
  //           color:[UIColor purpleColor]];

  //           //Apply transformation to the PLANE
  //   CATransform3D t = CATransform3DIdentity;
  //   //Add the perspective!!!
  //   t.m34 = 1.0/ 500;
  //   t = CATransform3DRotate(t, 45.0f * M_PI / 180.0f, 0, 1, 0);
  //   purplePlane.transform = t;

  return YES;
}

- (BOOL) application: (UIApplication *) application openURL: (NSURL *) url
sourceApplication: (NSString *) sourceApplication annotation: (id) annotation
{
  // Delegate method to call the Facebook session object 
  // that handles the incoming URL
  // [[NSNotificationCenter defaultCenter] postNotificationName:
  //   OMBActivityIndicatorViewStartAnimatingNotification object: nil];

  // NSLog(@"Open URL: %@", url);
  // NSLog(@"Source Application: %@", sourceApplication);
  // NSLog(@"Annotation: %@", annotation);

  // Facebook
  if ([[url absoluteString] rangeOfString: @"facebook"].location != 
    NSNotFound) {

    return [FBSession.activeSession handleOpenURL: url];
  }

  // Venmo
  if ([[url absoluteString] rangeOfString: @"venmo"].location != NSNotFound) {
    NSDictionary *params = [[url absoluteString] dictionaryFromString];
    if ([params objectForKey: @"signed_request"]) {
      if ([[params objectForKey: @"signed_request"] rangeOfString: 
        @"null"].location != NSNotFound) {

        NSLog(@"CANCELLLLLED");
        [[NSNotificationCenter defaultCenter] postNotificationName:
          OMBOfferNotificationVenmoAppSwitchCancelled object: nil
            userInfo: nil];
        return NO;
      }
    }
    return [_venmoClient openURL: url completionHandler:
      ^(VenmoTransaction *transaction, NSError *error) {
        UINavigationController *nav =
          (UINavigationController *) _container.currentDetailViewController;
        if (transaction) {
          if (transaction.success && _currentOfferBeingPaidFor) {
            // If there is no transactionID,
            // then the user charged instead of paid
            if (transaction.transactionID) {
              OMBOfferVerifyVenmoConnection *conn =
                [[OMBOfferVerifyVenmoConnection alloc] initWithOffer:
                  _currentOfferBeingPaidFor dictionary: @{
                    @"amount": transaction.amountString,
                    @"note":   transaction.note,
                    @"transactionID": transaction.transactionID
                  }
                ];
              conn.completionBlock = ^(NSError *error) {
                [[NSNotificationCenter defaultCenter] postNotificationName:
                  OMBOfferNotificationPaidWithVenmo object: nil 
                    userInfo: @{
                      @"error": error ? error : [NSNull null]
                    }];
                // [_container stopSpinning];
              };
              // [_container startSpinning];
              [conn start];
              [[NSNotificationCenter defaultCenter] postNotificationName:
                OMBOfferNotificationProcessingWithServer object: nil
                  userInfo: nil];
            }
            // The current user charged OnMyBlock instead of paid
            else {
              error = [NSError errorWithDomain: VenmoErrorDomain 
                code: VenmoErrorDomainCodeTransactionTypeIncorrect userInfo: @{
                  NSLocalizedDescriptionKey: @"Venmo Payment Failed",
                  NSLocalizedFailureReasonErrorKey: 
                    @"You made a charge instead of a payment."
                }
              ];
            }
          }
          // The transaction was not successful
          else {
            error = [NSError errorWithDomain: VenmoErrorDomain 
              code: VenmoErrorDomainCodeTransactionUnsuccessful userInfo: @{
                NSLocalizedDescriptionKey: @"Venmo Payment Failed",
                NSLocalizedFailureReasonErrorKey: 
                  @"The transaction was not successful."
              }
            ];
          }  
        }
        if (error)
          [(OMBViewController *) nav.topViewController showAlertViewWithError: 
            error];
      }
    ];
  }
  return YES;
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
