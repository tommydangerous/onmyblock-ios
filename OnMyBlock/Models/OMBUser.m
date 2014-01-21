//
//  OMBUser.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 10/30/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBUser.h"

#import "OMBAppDelegate.h"
#import "OMBConversationMessageStore.h"
#import "OMBCosigner.h"
#import "OMBEmployment.h"
#import "OMBFavoritesListConnection.h"
#import "OMBFavoriteResidence.h"
#import "OMBIntroStillImagesViewController.h"
#import "OMBLegalAnswer.h"
#import "OMBMessage.h"
#import "OMBMessageDetailConnection.h"
#import "OMBMessagesUnviewedCountConnection.h"
#import "OMBOffer.h"
#import "OMBOfferUpdateConnection.h"
#import "OMBRenterApplication.h"
#import "OMBResidence.h"
#import "OMBResidenceStore.h"
#import "OMBPreviousRental.h"
#import "OMBTemporaryResidence.h"
#import "OMBUserFacebookAuthenticationConnection.h"
#import "OMBUserImageDownloader.h"
#import "OMBUserStore.h"
#import "OMBViewControllerContainer.h"
#import "UIImage+Resize.h"

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
// Login connection, sign up connection, and authenticate with server
// posts this notification
NSString *const OMBUserLoggedInNotification  = @"OMBUserLoggedInNotification";
// User posts this after sending current user logout message to itself
NSString *const OMBUserLoggedOutNotification = @"OMBUserLoggedOutNotification";

NSString *const OMBMessagesUnviewedCountNotification =
  @"OMBMessagesUnviewedCountNotification";

// Change the __ENVIRONMENT__ value in file OnMyBlock-Prefix.pch
#if __ENVIRONMENT__ == 1
  // Development server
  NSString *const OMBFakeUserAccessToken = @"cea246ff2139e0fa5b17ae255e9a946d";
#elif __ENVIRONMENT__ == 2
  // Staging server
  NSString *const OMBFakeUserAccessToken = @"60721b1691403ed9037b52f8816e351e";
#elif __ENVIRONMENT__ == 3
  // Production server
  NSString *const OMBFakeUserAccessToken = @"";
#endif

int kNotificationTimerInterval = 30;

@implementation OMBUser

#pragma mark - Initializer

- (id) init
{
  if (!(self = [super init])) return nil;

  _favorites           = [NSMutableDictionary dictionary];
  _imageSizeDictionary = [NSMutableDictionary dictionary];
  _messages            = [NSMutableDictionary dictionary];
  _receivedOffers      = [NSMutableDictionary dictionary];
  _renterApplication   = [[OMBRenterApplication alloc] init];
  _residences          = [NSMutableDictionary dictionaryWithDictionary: @{
    @"residences":          [NSMutableDictionary dictionary],
    @"temporaryResidences": [NSMutableDictionary dictionary]
  }];

  [[NSNotificationCenter defaultCenter] addObserver: self
    selector: @selector(sessionStateChanged:)
      name: FBSessionStateChangedNotification object: nil];
  // [[NSNotificationCenter defaultCenter] addObserver: self
  //   selector: @selector(logout)
  //     name: OMBCurrentUserLogoutNotification object: nil];

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

+ (void) fakeLogin
{
  [OMBUser currentUser].about = @"About me? Well I like to do cool stuff. "
    @"I love watching movies! One of my favorite movies is Equilibrium.";
  [OMBUser currentUser].accessToken = OMBFakeUserAccessToken;
  [OMBUser currentUser].email     = @"fake_user@gmail.com";
  [OMBUser currentUser].firstName = @"fake";
  [OMBUser currentUser].lastName  = @"user";
  [OMBUser currentUser].phone     = @"4088581234";
  [OMBUser currentUser].school    = @"university of california - berkeley";
  [OMBUser currentUser].image     = [UIImage imageNamed: @"edward_d.jpg"];
  [OMBUser currentUser].uid       = 61;

  [OMBUser currentUser].renterApplication.cats = YES;
  [OMBUser currentUser].renterApplication.dogs = YES;

  // Post notification for logging in
  [[NSNotificationCenter defaultCenter] postNotificationName: 
    OMBUserLoggedInNotification object: nil];
}

+ (OMBUser *) fakeUser
{
  static OMBUser *user = nil;
  if (!user) {
    user             = [[OMBUser alloc] init];
    user.about       = @"I am a cool guy.";
    user.accessToken = @"cea246ff2139e0fa5b17ae255e9a946d";
    user.email       = @"edward_d@gmail.com";
    user.firstName   = @"edward";
    user.lastName    = @"david";
    user.phone       = @"4088581234";
    user.school      = @"university of california - berkeley";
    user.image       = [UIImage imageNamed: @"edward_d.jpg"];
    user.uid         = 9999;
  }
  return user;
}

+ (OMBUser *) landlordUser
{
  static OMBUser *user = nil;
  if (!user) {
    user             = [[OMBUser alloc] init];
    user.about       = @"Please contact me if you are "
      @"interested in this wonderful place.";
    user.email       = @"info@onmyblock.com";
    user.firstName   = @"land";
    user.lastName    = @"lord";
    user.phone       = @"6504555789";
    user.image       = [UIImage imageNamed: @"user_icon_default.png"];
    user.uid         = 31;
  }
  return user;
}

#pragma mark - Instance Methods

- (void) acceptOffer: (OMBOffer *) offer 
withCompletion: (void (^) (NSError *error)) block
{
  offer.accepted = YES;
  offer.declined = NO;
  // Offer update connection
  OMBOfferUpdateConnection *conn = 
    [[OMBOfferUpdateConnection alloc] initWithOffer: offer 
      attributes: @[@"accepted", @"declined"]];
  conn.completionBlock = block;
  [conn start];
}

- (void) addCosigner: (OMBCosigner *) cosigner
{
  [_renterApplication addCosigner: cosigner];
}

- (void) addEmployment: (OMBEmployment *) employment
{
  [_renterApplication addEmployment: employment];
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

- (void) addLegalAnswer: (OMBLegalAnswer *) object
{
  [_renterApplication addLegalAnswer: object];
}

- (void) addMessage: (OMBMessage *) message
{
  NSNumber *number = [NSNumber numberWithInt: message.recipient.uid];
  NSMutableArray *array = [_messages objectForKey: number];
  if (!array) {
    array = [NSMutableArray array];
  }
  NSPredicate *predicate = [NSPredicate predicateWithFormat: @"%K == %i",
    @"uid", message.uid];
  if ([[array filteredArrayUsingPredicate: predicate] count] == 0) {
    [message calculateSizeForMessageCell];
    [array addObject: message];
  }
  [_messages setObject: array forKey: number];
}

- (void) addReceivedOffer: (OMBOffer *) offer
{
  NSNumber *key = [NSNumber numberWithInt: offer.uid];
  if (![_receivedOffers objectForKey: key])
    [_receivedOffers setObject: offer forKey: key];
}

- (void) addPreviousRental: (OMBPreviousRental *) previousRental
{
  [_renterApplication addPreviousRental: previousRental];
}

- (void) addResidence: (OMBResidence *) residence
{
  NSString *classString;
  if ([residence isKindOfClass: [OMBTemporaryResidence class]]) {
    classString = @"temporaryResidences";
  }
  else {
    classString = @"residences";
  }
  NSMutableDictionary *dict = [_residences objectForKey: classString];
  NSNumber *key = [NSNumber numberWithInt: residence.uid];
  if ([dict objectForKey: key]) {
    [[dict objectForKey: key] updateResidenceWithResidence: residence];
  }
  else {
    [dict setObject: residence forKey: key];
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

- (void) declineOffer: (OMBOffer *) offer
withCompletion: (void (^) (NSError *error)) block
{
  offer.accepted = NO;
  offer.declined = YES;
  OMBOfferUpdateConnection *conn = 
    [[OMBOfferUpdateConnection alloc] initWithOffer: offer 
      attributes: @[@"accepted", @"declined"]];
  conn.completionBlock = block;
  [conn start];
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
  return [favoriteResidences sortedArrayUsingDescriptors: @[sort]];
}

- (void) fetchFavorites
{
  [[[OMBFavoritesListConnection alloc] init] start];
}

- (void) fetchMessagesAtPage: (NSInteger) page withUser: (OMBUser *) user
delegate: (id) delegate completion: (void (^) (NSError *error)) block
{
  OMBMessageDetailConnection *conn = 
    [[OMBMessageDetailConnection alloc] initWithPage: page withUser: user];
  conn.completionBlock = block;
  conn.delegate        = delegate;
  [conn start];
}

- (void) fetchNotificationCounts: (NSTimer *) timer
{
  OMBMessagesUnviewedCountConnection *conn =
    [[OMBMessagesUnviewedCountConnection alloc] init];
  [conn start];
}

- (NSString *) fullName
{
  NSString *nameString = @"";
  if (_firstName && [_firstName length])
    nameString = [nameString stringByAppendingString: 
      [_firstName capitalizedString]];
  if (_lastName && [_lastName length])
    nameString = [nameString stringByAppendingString: 
      [NSString stringWithFormat: @" %@", [_lastName capitalizedString]]];
  return nameString;
}

- (UIImage *) imageForSize: (CGSize) size
{
  return [self imageForSizeKey: [NSString stringWithFormat: @"%f,%f", 
    size.width, size.height]];
}

- (UIImage *) imageForSizeKey: (NSString *) string
{
  UIImage *img = [_imageSizeDictionary objectForKey: string];
  if (!img) {
    NSArray *words = [string componentsSeparatedByString: @","];
    if ([words count] >= 2) {
      NSInteger width  = [[words objectAtIndex: 0] floatValue];
      NSInteger height = [[words objectAtIndex: 1] floatValue];
      // Leave it up to the object that uses this to set the image
      // into the dictionary; e.g. the OMBMangeListingsCell 
      // resizes this image in it's OMBCenteredImageView then sets 
      // the object for key in the imagesSizedictionary
      img = [UIImage image: self.image size: CGSizeMake(width, height)];
      if (width == height)
        [_imageSizeDictionary setObject: img forKey: string];
    }
  }
  return img;
}

- (BOOL) loggedIn
{
  if ([OMBUser currentUser].accessToken)
    return YES;
  return NO;
}

- (void) logout
{
  [OMBUser currentUser].about               = @"";
  [OMBUser currentUser].accessToken         = @"";
  [OMBUser currentUser].email               = @"";
  [OMBUser currentUser].facebookAccessToken = @"";
  [OMBUser currentUser].facebookId          = @"";
  [OMBUser currentUser].firstName           = @"";
  [OMBUser currentUser].lastName            = @"";
  [OMBUser currentUser].phone               = @"";
  [OMBUser currentUser].school              = @"";
  [OMBUser currentUser].userType            = @"";

  [[OMBUser currentUser].favorites removeAllObjects];
  [OMBUser currentUser].image    = nil;
  [[OMBUser currentUser].imageSizeDictionary removeAllObjects];
  [OMBUser currentUser].imageURL = nil;
  [[OMBUser currentUser].messages removeAllObjects];
  [[OMBUser currentUser].notificationFetchTimer invalidate];
  [[OMBUser currentUser].receivedOffers removeAllObjects];
  [[OMBUser currentUser].renterApplication removeAllObjects];

  // Clear residences
  for (NSString *key in [[OMBUser currentUser].residences allKeys]) {
    NSMutableDictionary *dict = [[OMBUser currentUser].residences objectForKey:
      key];
    [dict removeAllObjects];
  }
  
  [OMBUser currentUser].uid = 0;

  // Clear conversations
  [[OMBConversationMessageStore sharedStore].messages removeAllObjects];

  [[NSNotificationCenter defaultCenter] postNotificationName: 
    OMBUserLoggedOutNotification object: nil];
}

- (NSArray *) messagesWithUser: (OMBUser *) user
{
  return [_messages objectForKey: [NSNumber numberWithInt: user.uid]];
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
  NSArray *array = [dictionary objectForKey: @"objects"];
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
  if ([dictionary objectForKey: @"access_token"])
    _accessToken = [dictionary objectForKey: @"access_token"];
  else
    _accessToken = @"";
  _email       = [dictionary objectForKey: @"email"];
  if ([dictionary objectForKey: @"first_name"] != [NSNull null])
    _firstName = [dictionary objectForKey: @"first_name"];
  else
    _firstName = @"";

  // Image URL
  NSString *string = [dictionary objectForKey: @"image_url"];
  
  // If URL is something like this //ombrb-prod.s3.amazonaws.com
  if ([string hasPrefix: @"//"]) {
    string = [@"http:" stringByAppendingString: string];
  }
  else if (![string hasPrefix: @"http"]) {
    NSString *baseURLString = [[OnMyBlockAPIURL componentsSeparatedByString: 
      OnMyBlockAPI] objectAtIndex: 0];
    if ([string isEqualToString: @"default_user_image.png"]) {
      string = [string stringByAppendingString: @"/"];
    }
    string = [NSString stringWithFormat: @"%@%@", baseURLString, string];
  }
  _imageURL = [NSURL URLWithString: string];

  if ([dictionary objectForKey: @"last_name"] != [NSNull null])
    _lastName = [dictionary objectForKey: @"last_name"];
  else
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

  // Add to the OMBUserStore
  [[OMBUserStore sharedStore] addUser: self];

  // If this user instance is the current user using the app
  if ([_accessToken length] > 0) {
    _notificationFetchTimer = [NSTimer timerWithTimeInterval: 
      kNotificationTimerInterval target: self
        selector: @selector(fetchNotificationCounts:) userInfo: nil 
          repeats: YES];
    // NSRunLoopCommonModes, mode used for tracking events
    [[NSRunLoop currentRunLoop] addTimer: _notificationFetchTimer
      forMode: NSRunLoopCommonModes];
  }
}

- (void) readFromEmploymentDictionary: (NSDictionary *) dictionary
{
  NSArray *array = [dictionary objectForKey: @"objects"];
  for (NSDictionary *dict in array) {
    OMBEmployment *employment = [[OMBEmployment alloc] init];
    [employment readFromDictionary: dict];
    [self addEmployment: employment];
  }
}

- (void) readFromFavoriteResidencesDictionary: (NSDictionary *) dictionary
{
  // Sample JSON
  // {
  //   objects: [
  //     {
  //       created: "2013-10-31 13:26:00 -0700",
  //       residence: {
  //         address: "8482 Fun Way"        
  //       },
  //       user: {
  //
  //       }
  //     }
  //   ],
  //   success: 1
  // }
  NSArray *array = [dictionary objectForKey: @"objects"];
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

    // User
    NSDictionary *userDict = [d objectForKey: @"user"];
    int userUID = [[userDict objectForKey: @"id"] intValue];
    OMBUser *user = [[OMBUserStore sharedStore] userWithUID: userUID];
    if (!user)
      [user readFromDictionary: userDict];

    // Favorite residence
    OMBFavoriteResidence *favoriteResidence = 
      [[OMBFavoriteResidence alloc] init];
    favoriteResidence.createdAt = createdAt;
    favoriteResidence.residence = residence;
    favoriteResidence.user      = user;
    [self addFavoriteResidence: favoriteResidence];
  }
}

- (void) readFromLegalAnswerDictionary: (NSDictionary *) dictionary
{
  NSArray *array = [dictionary objectForKey: @"objects"];
  for (NSDictionary *dict in array) {
    OMBLegalAnswer *legalAnswer = [[OMBLegalAnswer alloc] init];
    [legalAnswer readFromDictionary: dict];
    [self addLegalAnswer: legalAnswer];
  }
}

- (void) readFromMessagesDictionary: (NSDictionary *) dictionary
{
  NSDictionary *userDict = [dictionary objectForKey: @"user"];
  NSInteger userUID = [[userDict objectForKey: @"id"] intValue];
  OMBUser *user = [[OMBUserStore sharedStore] userWithUID: userUID];
  if (!user) {
    user = [[OMBUser alloc] init];
    [user readFromDictionary: userDict];
  }
  NSMutableArray *array = [_messages objectForKey: 
    [NSNumber numberWithInt: user.uid]];
  if (!array) {
    array = [NSMutableArray array];
  }
  for (NSDictionary *messageDict in [dictionary objectForKey: @"objects"]) {
    NSPredicate *predicate = [NSPredicate predicateWithFormat: @"%K == %i",
      @"uid", [[messageDict objectForKey: @"id"] intValue]];
    if ([[array filteredArrayUsingPredicate: predicate] count] == 0) {
      OMBMessage *message = [[OMBMessage alloc] init];
      [message readFromDictionary: messageDict];
      [array addObject: message];
    }
  }
  [_messages setObject: array forKey: [NSNumber numberWithInt: user.uid]];
}

- (void) readFromPreviousRentalDictionary: (NSDictionary *) dictionary
{
  NSArray *array = [dictionary objectForKey: @"objects"];
  for (NSDictionary *dict in array) {
    OMBPreviousRental *previousRental = [[OMBPreviousRental alloc] init];
    [previousRental readFromDictionary: dict];
    [self addPreviousRental: previousRental];
  }
}

- (void) readFromReceivedOffersDictionary: (NSDictionary *) dictionary
{
  NSArray *array = [dictionary objectForKey: @"objects"];
  for (NSDictionary *dict in array) {
    NSInteger objectUID = [[dict objectForKey: @"id"] intValue];
    if (![_receivedOffers objectForKey: [NSNumber numberWithInt: objectUID]]) {
      OMBOffer *offer = [[OMBOffer alloc] init];
      [offer readFromDictionary: dict];
      offer.landlordUser = [OMBUser currentUser];
      [self addReceivedOffer: offer];
    }
  }
}

- (void) readFromResidencesDictionary: (NSDictionary *) dictionary;
{
  NSArray *array = [dictionary objectForKey: @"objects"];
  for (NSDictionary *dict in array) {
    NSString *className = [dict objectForKey: @"class_name"];
    if ([className isEqualToString: @"residence"]) {
      OMBResidence *residence = [[OMBResidence alloc] init];
      [residence readFromResidenceDictionary: dict];

      [self addResidence: residence];

      [[OMBResidenceStore sharedStore] addResidence: residence];
    }
    else {
      OMBTemporaryResidence *temporaryResidence = 
        [[OMBTemporaryResidence alloc] init];
      [temporaryResidence readFromResidenceDictionary: dict];

      [self addResidence: temporaryResidence];
    }
  }
}

- (void) removeAllReceivedOffersWithOffer: (OMBOffer *) offer
{
  NSPredicate *predicate = [NSPredicate predicateWithFormat: @"%K == %i",
    @"residence.uid", offer.residence.uid];
  NSArray *array = [[_receivedOffers allValues] filteredArrayUsingPredicate: 
    predicate];
  for (OMBOffer *o in array) {
    [_receivedOffers removeObjectForKey: [NSNumber numberWithInt: o.uid]];
  }
}

- (void) removeReceivedOffer: (OMBOffer *) offer
{
  [_receivedOffers removeObjectForKey: [NSNumber numberWithInt: offer.uid]];
}

- (void) removeResidence: (OMBResidence *) residence
{
  NSString *classString;
  if ([residence isKindOfClass: [OMBTemporaryResidence class]])
    classString = @"temporaryResidences";
  else
    classString = @"residences";
  NSMutableDictionary *dict = [_residences objectForKey: classString];
  [dict removeObjectForKey: [NSNumber numberWithInt: residence.uid]];
}

- (void) removeResidenceFromFavorite: (OMBResidence *) residence
{
  NSString *key = [NSString stringWithFormat: @"%i", residence.uid];
  OMBFavoriteResidence *favoriteResidence = [_favorites objectForKey: key];
  if (favoriteResidence) {
    int index = (int) [[self favoritesArray] indexOfObjectPassingTest:
      ^BOOL (OMBFavoriteResidence* favorite, NSUInteger idx, BOOL *stop) {
        return favorite.residence.uid == favoriteResidence.residence.uid;
      }
    ];
    [_favorites removeObjectForKey: key];
    [[NSNotificationCenter defaultCenter] postNotificationName:
      OMBCurrentUserChangedFavorite object: nil userInfo: @{
        @"index": [NSNumber numberWithInt: index]
      }
    ];
  }
}

- (NSArray *) residencesSortedWithKey: (NSString *) key 
ascending: (BOOL) ascending
{
  NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey: key
    ascending: ascending];
  NSMutableArray *array = [NSMutableArray array];
  for (NSDictionary *dict in [_residences allValues]) {
    [array addObjectsFromArray: [dict allValues]];
  }
  return [array sortedArrayUsingDescriptors: @[sort]];
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

- (NSString *) shortName
{
  return [NSString stringWithFormat: @"%@ %@.",
    [self.firstName capitalizedString], 
      [[self.lastName substringToIndex: 1] capitalizedString]];
}

- (NSArray *) sortedReceivedOffersWithKey: (NSString *) key 
ascending: (BOOL) ascending
{
  NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey: key
    ascending: ascending];
  return [[_receivedOffers allValues] sortedArrayUsingDescriptors: @[sort]];
}

@end
