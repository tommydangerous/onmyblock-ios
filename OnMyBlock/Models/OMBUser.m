//
//  OMBUser.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 10/30/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBUser.h"

#import "OMBAppDelegate.h"
#import "OMBFavoritesListConnection.h"
#import "OMBFavoriteResidence.h"
#import "OMBResidence.h"
#import "OMBResidenceStore.h"
#import "OMBUserFacebookAuthenticationConnection.h"

NSString *const OMBCurrentUserChangedFavorite = 
  @"OMBCurrentUserChangedFavorite";
NSString *const OMBCurrentUserLogoutNotification = 
  @"OMBCurrentUserLogoutNotification";
NSString *const OMBUserLoggedInNotification  = @"OMBUserLoggedInNotification";
NSString *const OMBUserLoggedOutNotification = @"OMBUserLoggedOutNotification";

@implementation OMBUser

@synthesize accessToken         = _accessToken;
@synthesize email               = _email;
@synthesize facebookAccessToken = _facebookAccessToken;
@synthesize facebookId          = _facebookId;
@synthesize name                = _name;
@synthesize userType            = _userType;

@synthesize favorites           = _favorites;
@synthesize uid                 = _uid;

#pragma mark - Initializer

- (id) init
{
  if (!(self = [super init])) return nil;

  _favorites = [NSMutableDictionary dictionary];

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

- (void) addFavoriteResidence: (OMBFavoriteResidence *) favoriteResidence
{
  if (![_favorites objectForKey: [favoriteResidence dictionaryKey]]) {
    [_favorites setObject: favoriteResidence forKey: 
      [favoriteResidence dictionaryKey]];
    [[NSNotificationCenter defaultCenter] postNotificationName:
      OMBCurrentUserChangedFavorite object: nil];
  }
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
      [self fetchFavorites];
      [[NSNotificationCenter defaultCenter] postNotificationName: 
        OMBUserLoggedInNotification object: nil];
    }
  };
  [connection start];
  NSLog(@"Authenticate with server");
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
  [OMBUser currentUser].name                = nil;
  [OMBUser currentUser].userType            = nil;
  [OMBUser currentUser].uid                 = 0;
  [[OMBUser currentUser].favorites removeAllObjects];
  [[NSNotificationCenter defaultCenter] postNotificationName: 
    OMBUserLoggedOutNotification object: nil];
}

- (void) readFromDictionary: (NSDictionary *) dictionary
{
  _accessToken = [dictionary objectForKey: @"access_token"];
  _email       = [dictionary objectForKey: @"email"];
  _name        = [dictionary objectForKey: @"name"];
  _userType    = [dictionary objectForKey: @"user_type"];
  _uid         = [[dictionary objectForKey: @"id"] intValue];
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
      currentUser.name = [NSString stringWithFormat: @"%@ %@", 
        [user objectForKey: @"first_name"], [user objectForKey: @"last_name"]];
      NSLog(@"Facebook active session is open");
      [currentUser authenticateWithServer: nil];
    }
  };
  if (FBSession.activeSession.isOpen)
    [FBRequestConnection startForMeWithCompletionHandler: completion];
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

@end
