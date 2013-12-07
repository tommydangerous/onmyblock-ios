//
//  OMBUser.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 10/30/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBUser.h"

#import "OMBAppDelegate.h"
#import "OMBCosigner.h"
#import "OMBFavoritesListConnection.h"
#import "OMBFavoriteResidence.h"
#import "OMBIntroViewController.h"
#import "OMBRenterApplication.h"
#import "OMBResidence.h"
#import "OMBResidenceStore.h"
#import "OMBPreviousRental.h"
#import "OMBUserFacebookAuthenticationConnection.h"
#import "OMBUserImageDownloader.h"
#import "OMBViewControllerContainer.h"

NSString *const OMBActivityIndicatorViewStartAnimatingNotification =
  @"OMBActivityIndicatorViewStartAnimatingNotification";
NSString *const OMBActivityIndicatorViewStopAnimatingNotification =
  @"OMBActivityIndicatorViewStopAnimatingNotification";
NSString *const OMBCurrentUserChangedFavorite = 
  @"OMBCurrentUserChangedFavorite";
// Menu view controller posts this, and user listens for it
NSString *const OMBCurrentUserLogoutNotification = 
  @"OMBCurrentUserLogoutNotification";
// Whenever the user logs in
NSString *const OMBUserLoggedInNotification  = @"OMBUserLoggedInNotification";
// User posts this after sending current user logout message to itself
NSString *const OMBUserLoggedOutNotification = @"OMBUserLoggedOutNotification";

@implementation OMBUser

@synthesize about               = _about;
@synthesize accessToken         = _accessToken;
@synthesize email               = _email;
@synthesize facebookAccessToken = _facebookAccessToken;
@synthesize facebookId          = _facebookId;
@synthesize firstName           = _firstName;
@synthesize lastName            = _lastName;
@synthesize phone               = _phone;
@synthesize school              = _school;
@synthesize userType            = _userType;

@synthesize favorites           = _favorites;
@synthesize image               = _image;
@synthesize imageURL            = _imageURL;
@synthesize uid                 = _uid;

#pragma mark - Initializer

- (id) init
{
  if (!(self = [super init])) return nil;

  _favorites         = [NSMutableDictionary dictionary];
  _renterApplication = [[OMBRenterApplication alloc] init];

  [[NSNotificationCenter defaultCenter] addObserver: self
    selector: @selector(sessionStateChanged:)
      name: FBSessionStateChangedNotification object: nil];
  [[NSNotificationCenter defaultCenter] addObserver: self
    selector: @selector(logout)
      name: OMBCurrentUserLogoutNotification object: nil];

  return self;
}

#pragma mark - Methods

#pragma mark - Class Methods

+ (OMBUser *) currentUser
{
  static OMBUser *user = nil;
  if (!user) {
    user = [[OMBUser alloc] init];
  }
  return user;
}

#pragma mark - Instance Methods

- (void) addCosigner: (OMBCosigner *) cosigner
{
  [_renterApplication addCosigner: cosigner];
}

- (void) addFavoriteResidence: (OMBFavoriteResidence *) favoriteResidence
{
  if (![_favorites objectForKey: [favoriteResidence dictionaryKey]]) {
    [_favorites setObject: favoriteResidence forKey: 
      [favoriteResidence dictionaryKey]];
    [[NSNotificationCenter defaultCenter] postNotificationName:
      OMBCurrentUserChangedFavorite object: nil];
  }
}

- (void) addPreviousRental: (OMBPreviousRental *) previousRental
{
  [_renterApplication addPreviousRental: previousRental];
  NSLog(@"%@", _renterApplication.previousRentals);
}

- (BOOL) alreadyFavoritedResidence: (OMBResidence *) residence
{
  if ([_favorites objectForKey: [NSString stringWithFormat: @"%i", 
    residence.uid]])
    return YES;
  return NO;
}

- (void) authenticateWithServer: (void (^) (NSError *error)) block
{
  OMBUserFacebookAuthenticationConnection *connection = 
    [[OMBUserFacebookAuthenticationConnection alloc] initWithUser: self];
  connection.completionBlock = ^(NSError *error) {
    if ([[OMBUser currentUser] loggedIn]) {
      // Load the user's favorites
      [self fetchFavorites];
      // Post notification
      [[NSNotificationCenter defaultCenter] postNotificationName: 
        OMBUserLoggedInNotification object: nil];
      // Hide the intro view controller
      OMBAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
      [appDelegate.container.introViewController dismissViewControllerAnimated: 
        YES completion: nil];
    }
    // Tell all the activity indicators to stop spinning
    [[NSNotificationCenter defaultCenter] postNotificationName:
      OMBActivityIndicatorViewStopAnimatingNotification object: nil];
  };
  [connection start];
  NSLog(@"Authenticate with server");
}

- (void) downloadImageFromImageURLWithCompletion: 
(void (^) (NSError *error)) block
{
  OMBUserImageDownloader *downloader = 
    [[OMBUserImageDownloader alloc] initWithUser: self];
  downloader.completionBlock = block;
  [downloader startDownload];
}

- (NSArray *) favoritesArray
{
  NSArray *favoriteResidences = [_favorites allValues];
  NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey: @"createdAt"
    ascending: NO];
  favoriteResidences = [favoriteResidences sortedArrayUsingDescriptors: 
    @[sort]];
  NSMutableArray *array = [NSMutableArray array];
  for (OMBFavoriteResidence *favoriteResidence in favoriteResidences) {
    [array addObject: favoriteResidence.residence];
  }
  return array;
}

- (void) fetchFavorites
{
  [[[OMBFavoritesListConnection alloc] init] start];
}

- (NSString *) fullName
{
  return [NSString stringWithFormat: @"%@ %@",
    [_firstName capitalizedString], [_lastName capitalizedString]];
}

- (BOOL) loggedIn
{
  if ([OMBUser currentUser].accessToken)
    return YES;
  return NO;
}

- (void) logout
{
  [OMBUser currentUser].accessToken         = nil;
  [OMBUser currentUser].email               = nil;
  [OMBUser currentUser].facebookAccessToken = nil;
  [OMBUser currentUser].facebookId          = nil;
  [OMBUser currentUser].firstName           = nil;
  [OMBUser currentUser].image               = nil;
  [OMBUser currentUser].imageURL            = nil;
  [OMBUser currentUser].lastName            = nil;
  [OMBUser currentUser].userType            = nil;
  [OMBUser currentUser].uid                 = 0;
  [[OMBUser currentUser].favorites removeAllObjects];
  [[NSNotificationCenter defaultCenter] postNotificationName: 
    OMBUserLoggedOutNotification object: nil];
}

- (NSString *) phoneString
{
  if (_phone && [_phone length] > 0) {
    NSRegularExpression *regex = 
      [NSRegularExpression regularExpressionWithPattern: @"([0-9]+)" 
        options: 0 error: nil];
    NSArray *matches = [regex matchesInString: _phone options: 0 
      range: NSMakeRange(0, [_phone length])];
    NSString *newPhone = @"";
    for (NSTextCheckingResult *result in matches) {
      newPhone = [newPhone stringByAppendingString: 
        [_phone substringWithRange: result.range]];
    }
    if ([newPhone length] >= 10) {
      NSString *areaCodeString = [newPhone substringWithRange: 
        NSMakeRange(0, 3)];
      NSString *phoneString1   = [newPhone substringWithRange: 
        NSMakeRange(3, 3)];
      NSString *phoneString2   = [newPhone substringWithRange: 
        NSMakeRange(6, 4)];
      return [NSString stringWithFormat: @"(%@) %@-%@", 
        areaCodeString, phoneString1, phoneString2];
    }

  }
  return @"";
}

- (void) readFromCosignerDictionary: (NSDictionary *) dictionary
{
  NSArray *array = [dictionary objectForKey: @"cosigners"];
  for (NSDictionary *dict in array) {
    OMBCosigner *cosigner = [[OMBCosigner alloc] init];
    [cosigner readFromDictionary: dict];
    [self addCosigner: cosigner];
  }
}

- (void) readFromDictionary: (NSDictionary *) dictionary
{
  // Sample JSON
  // {
  //   about:      about,
  //   access_token: access_token,
  //   email:      email,
  //   first_name: first_name,
  //   id:         self.id,
  //   image_url:  image_url,
  //   last_name:  last_name,
  //   phone:      phone,
  //   school:     school,
  //   success:     1,
  //   user_type:  user_type
  // }
  _about       = [dictionary objectForKey: @"about"];
  if (!_about)
    _about = @"";
  _accessToken = [dictionary objectForKey: @"access_token"];
  _email       = [dictionary objectForKey: @"email"];
  _firstName   = [dictionary objectForKey: @"first_name"];
  if (!_firstName)
    _firstName = @"";
  NSString *string = [dictionary objectForKey: @"image_url"];
  // If URL is something like this //ombrb-prod.s3.amazonaws.com
  if ([string hasPrefix: @"//"]) {
    string = [@"http:" stringByAppendingString: string];
  }
  else if (![string hasPrefix: @"http"]) {
    NSString *baseURLString = [[OnMyBlockAPIURL componentsSeparatedByString: 
      OnMyBlockAPI] objectAtIndex: 0];
    string = [NSString stringWithFormat: @"%@%@", baseURLString, string];
  }
  _imageURL    = [NSURL URLWithString: string];
  _lastName    = [dictionary objectForKey: @"last_name"];
  if (!_lastName)
    _lastName = @"";
  _phone       = [dictionary objectForKey: @"phone"];
  if (!_phone)
    _phone = @"";
  _school      = [dictionary objectForKey: @"school"];
  if (!_school)
    _school = @"";
  _userType    = [dictionary objectForKey: @"user_type"];
  _uid         = [[dictionary objectForKey: @"id"] intValue];
  [_renterApplication readFromDictionary: 
    [dictionary objectForKey: @"renter_application"]];
}

- (void) readFromResidencesDictionary: (NSDictionary *) dictionary
{
  // Sample JSON
  // {
  //   residences: [
  //     {
  //       created: "2013-10-31 13:26:00 -0700",
  //       residence: {
  //         address: "8482 Fun Way"        
  //       }
  //     }
  //   ],
  //   success: 1
  // }
  NSArray *array = [dictionary objectForKey: @"residences"];
  for (NSDictionary *d in array) {
    NSDictionary *dict = [d objectForKey: @"residence"];
    NSString *address = [dict objectForKey: @"address"];
    float latitude, longitude;
    latitude  = [[dict objectForKey: @"latitude"] floatValue];
    longitude = [[dict objectForKey: @"longitude"] floatValue];
    // key = 32,-117-8550 fun street
    NSString *key = [NSString stringWithFormat: @"%f,%f-%@",
      latitude, longitude, address];
    OMBResidence *residence = 
      [[OMBResidenceStore sharedStore].residences objectForKey: key];
    if (!residence) {
      residence = [[OMBResidence alloc] init];
      [residence readFromResidenceDictionary: dict];
      [[OMBResidenceStore sharedStore] addResidence: residence];
    }
    else {
      [residence readFromResidenceDictionary: dict];
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat       = @"yyyy-MM-dd HH:mm:ss ZZZ";
    NSTimeInterval createdAt = [[dateFormatter dateFromString:
      [d objectForKey: @"created_at"]] timeIntervalSince1970];
    OMBFavoriteResidence *favoriteResidence = 
      [[OMBFavoriteResidence alloc] init];
    favoriteResidence.createdAt = createdAt;
    favoriteResidence.residence = residence;
    [self addFavoriteResidence: favoriteResidence];
  }
}

- (void) removeResidenceFromFavorite: (OMBResidence *) residence
{
  NSString *key = [NSString stringWithFormat: @"%i", residence.uid];
  OMBFavoriteResidence *favoriteResidence = [_favorites objectForKey: key];
  if (favoriteResidence) {
    int index = (int) [[self favoritesArray] indexOfObjectPassingTest:
      ^BOOL (OMBResidence* residence, NSUInteger idx, BOOL *stop) {
        return residence.uid == favoriteResidence.residence.uid;
      }
    ];
    [_favorites removeObjectForKey: key];
    [[NSNotificationCenter defaultCenter] postNotificationName:
      OMBCurrentUserChangedFavorite object: nil userInfo: @{
        @"index": [NSNumber numberWithInt: index]
      }];
  }
}

- (void) sessionStateChanged: (NSNotification *) notification
{
  void (^completion) (FBRequestConnection *connection, id <FBGraphUser> user,
    NSError *error) = ^(FBRequestConnection *connection, 
      id <FBGraphUser> user, NSError *error) {

    if (error) {
      OMBAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
      UIAlertView *alertView = [[UIAlertView alloc] initWithTitle: @"Facebook"
        message: @"Authentication failed" delegate: appDelegate
          cancelButtonTitle: @"Try again" otherButtonTitles: nil];
      [alertView show];
    }
    else {
      OMBUser *currentUser = [OMBUser currentUser];
      currentUser.email = [user objectForKey: @"email"];
      currentUser.facebookAccessToken = 
        [[[FBSession activeSession] accessTokenData] accessToken];
      currentUser.facebookId = [user objectForKey: @"id"];
      currentUser.firstName  = [user objectForKey: @"first_name"];
      currentUser.lastName   = [user objectForKey: @"last_name"];
      NSLog(@"Facebook active session is open");
      [currentUser authenticateWithServer: nil];
    }
  };
  if (FBSession.activeSession.isOpen)
    [FBRequestConnection startForMeWithCompletionHandler: completion];
}

@end
