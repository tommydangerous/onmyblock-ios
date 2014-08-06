//
//  OMBUser.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 10/30/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBUser.h"

#import <Parse/Parse.h>

#import "NSString+Extensions.h"
#import "NSString+OnMyBlock.h"
#import "NSUserDefaults+OnMyBlock.h"
#import "OMBAppDelegate.h"
#import "OMBAuthenticationFacebookConnection.h"
#import "OMBAuthenticationLinkedInConnection.h"
#import "OMBAuthenticationVenmoConnection.h"
#import "OMBConfirmedTenantsConnection.h"
#import "OMBConversationStore.h"
#import "OMBCosigner.h"
#import "OMBOfferCreateConnection.h"
#import "OMBEmployment.h"
#import "OMBEmploymentListConnection.h"
#import "OMBFavoritesListConnection.h"
#import "OMBFavoriteResidence.h"
#import "OMBIntroStillImagesViewController.h"
#import "OMBLegalAnswer.h"
#import "OMBLegalAnswerListConnection.h"
#import "OMBLegalQuestionStore.h"
#import "OMBMessage.h"
#import "OMBMessageDetailConnection.h"
#import "OMBMessagesUnviewedCountConnection.h"
#import "OMBMovedInConnection.h"
#import "OMBOffer.h"
#import "OMBOfferDecisionConnection.h"
#import "OMBOffersAcceptedConnection.h"
#import "OMBOffersReceivedConnection.h"
#import "OMBPayoutMethod.h"
#import "OMBPayoutMethodCreateConnection.h"
#import "OMBPayoutMethodListConnection.h"
#import "OMBPayoutTransaction.h"
#import "OMBPayoutTransactionListConnection.h"
#import "OMBRenterApplication.h"
#import "OMBResidence.h"
#import "OMBResidenceStore.h"
#import "OMBPreviousRental.h"
#import "OMBSentApplication.h"
#import "OMBTemporaryResidence.h"
#import "OMBUserCurrentUserInfoConnection.h"
#import "OMBUserFacebookAuthenticationConnection.h"
#import "OMBUserImageDownloader.h"
#import "OMBUserListingsConnection.h"
#import "OMBUserProfileConnection.h"
#import "OMBUserStore.h"
#import "OMBUserUpdateConnection.h"
#import "OMBUserUploadImageConnection.h"
#import "OMBViewControllerContainer.h"
#import "UIFont+OnMyBlock.h"
#import "UIImage+Resize.h"

NSString *const OMBActivityIndicatorViewStartAnimatingNotification =
  @"OMBActivityIndicatorViewStartAnimatingNotification";
NSString *const OMBActivityIndicatorViewStopAnimatingNotification =
  @"OMBActivityIndicatorViewStopAnimatingNotification";
NSString *const OMBCurrentUserChangedFavorite =
  @"OMBCurrentUserChangedFavorite";
// Observers:
// - OMBViewControllerContainer
// - OMBUserMenu
NSString *const OMBCurrentUserLandlordTypeChangeNotification =
  @"OMBCurrentUserLandlordTypeChangeNotification";
// Menu view controller posts this, and user listens for it
// Unused
// NSString *const OMBCurrentUserLogoutNotification =
//   @"OMBCurrentUserLogoutNotification";
NSString *const OMBCurrentUserUploadedImage = @"OMBCurrentUserUploadedImage";
// When authenticating with Facebook while logged in
NSString *const OMBUserCreateAuthenticationForFacebookNotification =
  @"OMBUserCreateAuthenticationForFacebookNotification";
// Whenever the user logs in
// Login connection, sign up connection, and authenticate with server
// posts this notification
NSString *const OMBUserLoggedInNotification  = @"OMBUserLoggedInNotification";
// User posts this after sending current user logout message to itself
NSString *const OMBUserLoggedOutNotification = @"OMBUserLoggedOutNotification";

NSString *const OMBMessagesUnviewedCountNotification =
  @"OMBMessagesUnviewedCountNotification";

NSString *const OMBOffersLandordPendingCountNotification =
  @"OMBOffersLandordPendingCountNotification";
NSString *const OMBOffersRenterAcceptedCountNotification =
  @"OMBOffersRenterAcceptedCountNotification";

NSString *const OMBLandlordTypeSubletter = @"subletter";
NSString *const OMBUserTypeLandlord = @"landlord";

// Change the __ENVIRONMENT__ value in file OnMyBlock-Prefix.pch
#if __ENVIRONMENT__ == 1
  // Development server
  // #warning Change This!!!
  // Landlord (Fake User)
  NSString *const OMBFakeUserAccessToken =
    @"cea246ff2139e0fa5b17ae255e9a946d";
  // Student
  // NSString *const OMBFakeUserAccessToken =
  //   @"6591173fc1a1f1ac409c0efb3a0a05b1";
    int kNotificationTimerInterval = 10000;
#elif __ENVIRONMENT__ == 2
  // Staging server
  NSString *const OMBFakeUserAccessToken = @"60721b1691403ed9037b52f8816e351e";
  int kNotificationTimerInterval = 30;
#elif __ENVIRONMENT__ == 3
  // Production server
  NSString *const OMBFakeUserAccessToken = @"";
  int kNotificationTimerInterval = 60;
#endif

@implementation OMBUser

#pragma mark - Initializer

- (id) init
{
  if (!(self = [super init])) return nil;

  _acceptedOffers      = [NSMutableDictionary dictionary];
  _confirmedTenants    = [NSMutableDictionary dictionary];
  _depositPayoutTransactions = [NSMutableDictionary dictionary];
  _favorites           = [NSMutableDictionary dictionary];
  _imageSizeDictionary = [NSMutableDictionary dictionary];
  _messages            = [NSMutableDictionary dictionary];
  _movedIn             = [NSMutableDictionary dictionary];
  _movedInOut          = [NSMutableDictionary dictionary];
  _payoutMethods       = [NSMutableDictionary dictionary];
  _receivedOffers      = [NSMutableDictionary dictionary];
  _renterApplication   = [[OMBRenterApplication alloc] init];
  _residences          = [NSMutableDictionary dictionaryWithDictionary: @{
    @"residences":          [NSMutableDictionary dictionary],
    @"temporaryResidences": [NSMutableDictionary dictionary]
  }];
  _residencesVisited   = [NSMutableDictionary dictionary];
  _heightForAboutTextDictionary = [NSMutableDictionary dictionary];

  // [[NSNotificationCenter defaultCenter] addObserver: self
  //   selector: @selector(logout)
  //     name: OMBCurrentUserLogoutNotification object: nil];

  return self;
}

#pragma mark - Override

#pragma mark - Override NSObject

- (void) dealloc
{
  [[NSNotificationCenter defaultCenter] removeObserver: self];
}

#pragma mark - Methods

#pragma mark - Class Methods

+ (OMBUser *) currentUser
{
  static OMBUser *user = nil;
  if (!user) {
    user = [[OMBUser alloc] init];
    [[NSNotificationCenter defaultCenter] addObserver: user
      selector: @selector(sessionStateChanged:)
        name: FBSessionStateChangedNotification object: nil];
    // Fetch favorites, fetch payout methods
    [[NSNotificationCenter defaultCenter] addObserver: user
      selector: @selector(performInitialLoginSetup)
        name: OMBUserLoggedInNotification object: nil];

    // Subscribe to push notifications channel
    [[NSNotificationCenter defaultCenter] addObserver: user
      selector: @selector(subscribeToPushNotificationChannels)
        name: OMBUserSubscribeToPushNotificationChannels object: nil];
  }
  return user;
}

+ (UIImage *) defaultUserImage
{
  return [UIImage imageNamed: @"profile_default_pic.png"];
}

+ (void) fakeLogin
{
  [OMBUser currentUser].about = @"About me? Well I like to do cool stuff. "
    @"I love watching movies! One of my favorite movies is Equilibrium.";
  [OMBUser currentUser].accessToken = OMBFakeUserAccessToken;
  [OMBUser currentUser].email     = @"fake_user@gmail.com";
  [OMBUser currentUser].firstName = @"fake";
  [OMBUser currentUser].imageURL  = [NSURL URLWithString:
    @"http://localhost:3000/user_image.png"];
  [OMBUser currentUser].lastName  = @"user";
  [OMBUser currentUser].phone     = @"4088581234";
  [OMBUser currentUser].school    = @"University of California - Berkeley";
  [OMBUser currentUser].image     = [UIImage imageNamed: @"edward_d.jpg"];
  // [OMBUser currentUser].userType  = OMBUserTypeLandlord;
  [OMBUser currentUser].uid       = 61;

  // [OMBUser currentUser].renterApplication.cats = YES;
  // [OMBUser currentUser].renterApplication.dogs = YES;

  [[OMBUserStore sharedStore] addUser: [OMBUser currentUser]];

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
    user.image       = [UIImage imageNamed: @"profile_default_pic.png"];
    user.uid         = 31;
  }
  return user;
}

+ (UIImage *) placeholderImage
{
  return [UIImage imageNamed: @"profile_default_pic.png"];
}

+ (NSString *) pushNotificationChannelForConversations: (NSUInteger) userUID
{
  return [NSString stringWithFormat: @"user_%i_conversations", userUID];
}

+ (NSString *) pushNotificationChannelForOffersPlaced: (NSUInteger) userUID
{
  return [NSString stringWithFormat: @"user_%i_offersplaced", userUID];
}

+ (NSString *) pushNotificationChannelForOffersReceived: (NSUInteger) userUID
{
  return [NSString stringWithFormat: @"user_%i_offersreceived", userUID];
}

#pragma mark - Instance Methods

- (void) acceptOffer: (OMBOffer *) offer
withCompletion: (void (^) (NSError *error)) block
{
  OMBOfferDecisionConnection *conn =
    [[OMBOfferDecisionConnection alloc] initWithOffer: offer
      decision: OMBOfferDecisionConnectionTypeAccept];
  conn.completionBlock = block;
  [conn start];
}

- (void) addAcceptedOffer: (OMBOffer *) offer
{
  NSNumber *key = [NSNumber numberWithInt: offer.uid];
  if (![_acceptedOffers objectForKey: key])
    [_acceptedOffers setObject: offer forKey: key];
}

- (void) addConfirmedTenant: (OMBOffer *) object
{
  NSNumber *key = [NSNumber numberWithInt: object.uid];
  if (![_confirmedTenants objectForKey: key])
    [_confirmedTenants setObject: object forKey: key];
}

- (void) addDepositPayoutTransaction: (OMBPayoutTransaction *) object
{
  NSNumber *key = [NSNumber numberWithInt: object.uid];
  if (![_depositPayoutTransactions objectForKey: key])
    [_depositPayoutTransactions setObject: object forKey: key];
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

// - (void) addMessage: (OMBMessage *) message
// {
//   NSNumber *number = [NSNumber numberWithInt: message.recipient.uid];
//   NSMutableArray *array = [_messages objectForKey: number];
//   if (!array) {
//     array = [NSMutableArray array];
//   }
//   NSPredicate *predicate = [NSPredicate predicateWithFormat: @"%K == %i",
//     @"uid", message.uid];
//   if ([[array filteredArrayUsingPredicate: predicate] count] == 0) {
//     [message calculateSizeForMessageCell];
//     [array addObject: message];
//   }
//   [_messages setObject: array forKey: number];
// }

- (void) addMovedIn: (OMBOffer *) object
{
  NSNumber *key = [NSNumber numberWithInt: object.uid];
  if (![_movedIn objectForKey: key])
    [_movedIn setObject: object forKey: key];
  NSLog(@"%@", _movedIn);
}

- (void) addMovedInOutDates: (OMBOffer *) object;
{
  //NSNumber *key = [NSNumber numberWithInt: object.residence.uid];
  [_movedInOut setObject: object forKey: @1];
}

- (void) addPayoutMethod: (OMBPayoutMethod *) object
{
  NSNumber *key = [NSNumber numberWithInt: object.uid];
  if (![_payoutMethods objectForKey: key])
    [_payoutMethods setObject: object forKey: key];
}

- (void) addReceivedOffer: (OMBOffer *) offer
{
  NSNumber *key = [NSNumber numberWithInt: offer.uid];
  if (![_receivedOffers objectForKey: key])
    [_receivedOffers setObject: offer forKey: key];
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
  NSLog(@"%@", residence);
}

- (void) addResidenceVisited:(OMBResidence *)residence
{
  NSNumber *key = [NSNumber numberWithInt: residence.uid];
  // This object just need residence's uid.
  // Maybe could use residence object for store it.
  if (![_residencesVisited objectForKey: key])
    [_residencesVisited setObject: @(residence.uid) forKey: key];
}

- (BOOL) alreadyFavoritedResidence: (OMBResidence *) residence
{
  if ([_favorites objectForKey: [NSString stringWithFormat: @"%i",
    residence.uid]])
    return YES;
  return NO;
}

- (void) authenticateVenmoWithCode: (NSString *) code
depositMethod: (BOOL) deposit withCompletion: (void (^) (NSError *error)) block
{
  OMBAuthenticationVenmoConnection *conn =
    [[OMBAuthenticationVenmoConnection alloc] initWithCode: code
      depositMethod: deposit];
  conn.completionBlock = block;
  [conn start];
}

- (void) authenticateWithServer: (void (^) (NSError *error)) block
{
  OMBUserFacebookAuthenticationConnection *connection =
    [[OMBUserFacebookAuthenticationConnection alloc] initWithUser: self];
  connection.completionBlock = ^(NSError *error) {
    if ([[OMBUser currentUser] loggedIn]) {
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

- (void) changeOtherSamePrimaryPayoutMethods: (OMBPayoutMethod *) payoutMethod
{
  // NSPredicate *predicate = [NSPredicate predicateWithFormat:
  //   @"%K == %@ && %K == %@ && %K != %i",
  //     @"deposit", [NSNumber numberWithBool: payoutMethod.deposit],
  //       @"primary", [NSNumber numberWithBool: payoutMethod.primary],
  //         @"uid", payoutMethod.uid];
  NSPredicate *predicate = [NSPredicate predicateWithFormat:
    @"%K == %@ && %K != %i",
      @"primary", [NSNumber numberWithBool: payoutMethod.primary],
        @"uid", payoutMethod.uid];
  for (OMBPayoutMethod *object in
    [[_payoutMethods allValues] filteredArrayUsingPredicate: predicate]) {

    object.primary = NO;
  }
}

- (void) checkForUserDefaultsAPIKey
{
  // Store the access token in the user defaults
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  NSMutableDictionary *apiKeyDict = [defaults objectForKey:
    OMBUserDefaultsAPIKey];
  if (apiKeyDict) {
    if ([apiKeyDict objectForKey: OMBUserDefaultsAPIKeyExpiresAt]) {
      NSTimeInterval expiresAt =
        [[apiKeyDict objectForKey: OMBUserDefaultsAPIKeyExpiresAt] floatValue];
      NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
      // If it has not expired
      if (expiresAt > now) {
        id previousAccessToken =
          [apiKeyDict objectForKey: OMBUserDefaultsAPIKeyAccessToken];
        if (previousAccessToken && previousAccessToken != [NSNull null]) {
          _accessToken = (NSString *) previousAccessToken;
          [self fetchCurrentUserInfo];
        }
      }
      // If it has expired
      else {
        // Clear the user defaults for the api key
        apiKeyDict = [NSMutableDictionary dictionary];
        [[NSUserDefaults standardUserDefaults] setObject: apiKeyDict
          forKey: OMBUserDefaultsAPIKey];
        [defaults synchronize];
      }
    }
  }
}

- (BOOL) compareUser: (OMBUser *) user
{
  return _uid == user.uid;
}

- (void) confirmOffer: (OMBOffer *) offer
withCompletion: (void (^) (NSError *error)) block
{
  OMBOfferDecisionConnection *conn =
    [[OMBOfferDecisionConnection alloc] initWithOffer: offer
      decision: OMBOfferDecisionConnectionTypeConfirm];
  conn.completionBlock = block;
  [conn start];
}

- (void) createAuthenticationForFacebookWithCompletion:
  (void (^) (NSError *error)) block
{
  OMBAuthenticationFacebookConnection *conn =
    [[OMBAuthenticationFacebookConnection alloc] init];
  conn.completionBlock = block;
  [conn start];
}

- (void) createAuthenticationForLinkedInWithAccessToken: (NSString *) string
completion: (void (^) (NSError *error)) block
{
  OMBAuthenticationLinkedInConnection *conn =
    [[OMBAuthenticationLinkedInConnection alloc] initWithLinkedInAccessToken:
      string];
  conn.completionBlock = block;
  [conn start];
}

- (void) createOffer: (OMBOffer *) offer
completion: (void (^) (NSError *error)) block
{
  OMBOfferCreateConnection *conn =
    [[OMBOfferCreateConnection alloc] initWithOffer: offer];
  conn.completionBlock = block;
  [conn start];
}

- (void) createPayoutMethodWithDictionary: (NSDictionary *) dictionary
withCompletion: (void (^) (NSError *error)) block
{
  OMBPayoutMethodCreateConnection *conn =
    [[OMBPayoutMethodCreateConnection alloc] initWithDictionary:
      dictionary];
  conn.completionBlock = block;
  [conn start];
}

- (void) declineAndPutOtherOffersOnHold: (OMBOffer *) offer;
{
  NSPredicate *predicate = [NSPredicate predicateWithFormat: @"%K == %i",
    @"residence.uid", offer.residence.uid];
  NSArray *array = [[_receivedOffers allValues] filteredArrayUsingPredicate:
    predicate];
  for (OMBOffer *o in array) {
    if (o.uid != offer.uid) {
      if (!o.declined) {
        o.onHold  = YES;
      }
      o.declined = YES;
    }
  }
}

- (void) declineOffer: (OMBOffer *) offer
withCompletion: (void (^) (NSError *error)) block
{
  OMBOfferDecisionConnection *conn =
    [[OMBOfferDecisionConnection alloc] initWithOffer: offer
      decision: OMBOfferDecisionConnectionTypeDecline];
  conn.completionBlock = block;
  [conn start];
}

- (NSArray *) depositPayoutMethods
{
  NSPredicate *predicate =
    [NSPredicate predicateWithFormat: @"%K == %@ && %K == %@",
      @"deposit", [NSNumber numberWithBool: YES],
        @"primary", [NSNumber numberWithBool: YES]];
  return [[_payoutMethods allValues] filteredArrayUsingPredicate: predicate];
}

- (void) downloadImageFromImageURLWithCompletion:
(void (^) (NSError *error)) block
{
  OMBUserImageDownloader *downloader =
    [[OMBUserImageDownloader alloc] initWithUser: self];
  downloader.completionBlock = block;
  [downloader startDownload];
}

- (BOOL) emailContactPermission
{
  if ([[_email matchingResultsWithRegularExpression:
    @"(landlord_user_[0-9]+@gmail.com)"] count])
    return NO;
  return YES;
}

- (NSArray *) favoritesArray
{
  NSArray *favoriteResidences = [_favorites allValues];
  NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey: @"createdAt"
    ascending: NO];
  return [favoriteResidences sortedArrayUsingDescriptors: @[sort]];
}

- (void) fetchAcceptedOffersWithCompletion: (void (^) (NSError *error)) block
{
  OMBOffersAcceptedConnection *conn =
    [[OMBOffersAcceptedConnection alloc] init];
  conn.completionBlock = block;
  [conn start];
}

- (void) fetchConfirmedTenantsWithCompletion: (void (^) (NSError *error)) block
{
  OMBConfirmedTenantsConnection *conn =
    [[OMBConfirmedTenantsConnection alloc] init];
  conn.completionBlock = block;
  [conn start];
}

- (void) fetchCurrentUserInfo
{
  OMBUserCurrentUserInfoConnection *conn =
    [[OMBUserCurrentUserInfoConnection alloc] init];
  conn.completionBlock = ^(NSError *error) {
    if (_uid && !error) {
      [[NSNotificationCenter defaultCenter] postNotificationName:
        OMBUserLoggedInNotification object: nil];
    }
  };
  [conn start];
}

- (void) fetchDepositPayoutTransactionsWithCompletion:
(void (^) (NSError *error)) block
{
  OMBPayoutTransactionListConnection *conn =
    [[OMBPayoutTransactionListConnection alloc] initForDeposits: YES];
  conn.completionBlock = block;
  [conn start];
}

- (void) fetchEmploymentsWithCompletion: (void (^) (NSError *error)) block
{
  OMBEmploymentListConnection *conn =
    [[OMBEmploymentListConnection alloc] initWithUser: self];
  conn.completionBlock = block;
  [conn start];
}

- (void) fetchFavorites
{
  [[[OMBFavoritesListConnection alloc] init] start];
}

- (void) fetchLegalAnswersWithCompletion: (void (^) (NSError *error)) block
{
  [[OMBLegalQuestionStore sharedStore] fetchLegalQuestionsWithCompletion:
    ^(NSError *error) {
      OMBLegalAnswerListConnection *connection =
        [[OMBLegalAnswerListConnection alloc] initWithUser: self];
      connection.completionBlock = block;
      [connection start];
    }
  ]; 
}

- (void) fetchListingsWithCompletion: (void (^) (NSError *error)) block
{
  OMBUserListingsConnection *conn =
    [[OMBUserListingsConnection alloc] initWithUser: self];
  conn.completionBlock = block;
  [conn start];
}

- (void) fetchMessagesAtPage: (NSInteger) page withUser: (OMBUser *) user
delegate: (id) delegate completion: (void (^) (NSError *error)) block
{
  OMBMessageDetailConnection *conn =
    [[OMBMessageDetailConnection alloc] initWithPage: page withUser: user];
  conn.completionBlock = block;
  conn.delegate = delegate;
  [conn start];
}

- (void) fetchMovedInWithCompletion: (void (^) (NSError *error)) block
{
  OMBMovedInConnection *conn = [[OMBMovedInConnection alloc] init];
  conn.completionBlock = block;
  [conn start];
}

- (void) fetchNotificationCounts: (NSTimer *) timer
{
  OMBMessagesUnviewedCountConnection *conn =
    [[OMBMessagesUnviewedCountConnection alloc] init];
  [conn start];
  // [[[OMBOffersReceivedConnection alloc] init] start];
  // [[[OMBOffersAcceptedConnection alloc] init] start];
}

- (void) fetchPayoutMethodsWithCompletion: (void (^) (NSError *error)) block
{
  OMBPayoutMethodListConnection *conn =
    [[OMBPayoutMethodListConnection alloc] init];
  conn.completionBlock = block;
  [conn start];
}

- (void) fetchReceivedOffersWithCompletion: (void (^) (NSError *error)) block
{
  OMBOffersReceivedConnection *conn =
    [[OMBOffersReceivedConnection alloc] init];
  conn.completionBlock = block;
  [conn start];
}

- (void) fetchUserProfileWithCompletion: (void (^) (NSError *error)) block
{
  OMBUserProfileConnection *conn =
    [[OMBUserProfileConnection alloc] initWithUser: self];
  conn.completionBlock = block;
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

- (BOOL) hasLandlordType
{
  if (_landlordType && [_landlordType length])
    return YES;
  return NO;
}

- (BOOL) hasPhone
{
  if ([[self phoneString] length]) {
    return YES;
  }
  return NO;
}

- (CGFloat) heightForAboutTextWithWidth: (CGFloat) width
{
  // This only stores the about text with [UIFont normalFontText] and
  // line height of 22.0f
  NSNumber *key = [NSNumber numberWithFloat: width];
  NSNumber *height = [_heightForAboutTextDictionary objectForKey: key];
  if (!height || [height floatValue] == 0.0f) {
    NSAttributedString *aString = [_about attributedStringWithFont:
      [UIFont normalTextFont] lineHeight: 22.0f];
    CGRect rect = [aString boundingRectWithSize:
      CGSizeMake(width, 9999) options: NSStringDrawingUsesLineFragmentOrigin
        context: nil];
    height = [NSNumber numberWithFloat: rect.size.height];
    [_heightForAboutTextDictionary setObject: height forKey: key];
  }
  return [height floatValue];
}

- (UIImage *) imageForSize: (CGSize) size
{
  return [self imageForSizeKey: [NSString stringWithFormat: @"%f,%f",
    size.width, size.height]];
}

- (UIImage *) imageForSizeKey: (NSString *) string
{
  if (!_image)
    return nil;
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
      img = [UIImage image: _image proportionatelySized:
        CGSizeMake(width, height)];
      if (width == height)
        [_imageSizeDictionary setObject: img forKey: string];
    }
  }
  return img;
}

- (BOOL) isCurrentUser
{
  return _uid == [OMBUser currentUser].uid;
}

- (BOOL) isLandlord
{
  if (_userType && [_userType isEqualToString: OMBUserTypeLandlord])
    return YES;
  return NO;
}

- (BOOL) isStudent
{
  if ([self isLandlord] && ![self isSubletter]) {
    return NO;
  }
  return YES;
}

- (BOOL) isSubletter
{
  return self.landlordType && 
    [self.landlordType isEqualToString: OMBLandlordTypeSubletter];
}

- (BOOL) loggedIn
{
  if ([OMBUser currentUser].accessToken &&
    [[OMBUser currentUser].accessToken length] && [OMBUser currentUser].uid)
    return YES;
  return NO;
}

- (void) logout
{
  // Remove user from shared store
  [[OMBUserStore sharedStore] removeUser: [OMBUser currentUser]];

  [OMBUser currentUser].about               = @"";
  [OMBUser currentUser].accessToken         = @"";
  [OMBUser currentUser].email               = @"";
  [OMBUser currentUser].facebookAccessToken = @"";
  [OMBUser currentUser].facebookId          = @"";
  [OMBUser currentUser].firstName           = @"";
  [OMBUser currentUser].landlordType        = @"";
  [OMBUser currentUser].lastName            = @"";
  [OMBUser currentUser].phone               = @"";
  [OMBUser currentUser].school              = @"";
  [OMBUser currentUser].userType            = @"";

  [[OMBUser currentUser].acceptedOffers removeAllObjects];
  [[OMBUser currentUser].confirmedTenants removeAllObjects];
  [[OMBUser currentUser].depositPayoutTransactions removeAllObjects];
  [[OMBUser currentUser].favorites removeAllObjects];
  [OMBUser currentUser].image = nil;
  [[OMBUser currentUser].imageSizeDictionary removeAllObjects];
  [OMBUser currentUser].imageURL = nil;
  // Messages
  [[OMBUser currentUser].messages removeAllObjects];
  // Moved in
  [[OMBUser currentUser].movedIn removeAllObjects];
  // Notification
  [[OMBUser currentUser].notificationFetchTimer invalidate];
  // Payout methods
  [[OMBUser currentUser].payoutMethods removeAllObjects];
  // Received offers
  [[OMBUser currentUser].receivedOffers removeAllObjects];
  // Renter application
  [[OMBUser currentUser].renterApplication removeAllObjects];
  [[OMBUser currentUser].heightForAboutTextDictionary removeAllObjects];

  // Clear residences
  for (NSString *key in [[OMBUser currentUser].residences allKeys]) {
    NSMutableDictionary *dict = [[OMBUser currentUser].residences objectForKey:
      key];
    [dict removeAllObjects];
  }
  [[OMBUser currentUser].residencesVisited removeAllObjects];

  [OMBUser currentUser].uid = 0;

  // Clear conversations
  [[OMBConversationStore sharedStore] removeAllObjects];

  // Delete the user defaults for the api key storage
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  NSMutableDictionary *apiKeyDict = [NSMutableDictionary dictionary];
  // Set the dictionary in the defaults
  [[NSUserDefaults standardUserDefaults] setObject: apiKeyDict
    forKey: OMBUserDefaultsAPIKey];
  [[NSUserDefaults standardUserDefaults] setObject:
    [NSMutableDictionary dictionary] forKey: OMBUserDefaultsRenterApplication];
  [defaults synchronize];

  [[NSNotificationCenter defaultCenter] postNotificationName:
    OMBUserLoggedOutNotification object: nil];

  // Clear Facebook token information
  OMBAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
  [appDelegate clearFacebookTokenInformation];

  // Unsubscribe from all push notification channels
  PFInstallation *currentInstallation = [PFInstallation currentInstallation];
  currentInstallation.channels = [NSArray array];
  [currentInstallation saveEventually];
}

- (NSArray *) messagesWithUser: (OMBUser *) user
{
  return [_messages objectForKey: [NSNumber numberWithInt: user.uid]];
}

- (NSArray *) paymentPayoutMethods
{
  // NSPredicate *predicate =
  //   [NSPredicate predicateWithFormat: @"%K == %@ && %K == %@",
  //     @"deposit", [NSNumber numberWithBool: NO],
  //       @"primary", [NSNumber numberWithBool: YES]];
  NSPredicate *predicate =
    [NSPredicate predicateWithFormat: @"%K == %@ && %K == %@",
      @"payment", [NSNumber numberWithBool: YES],
        @"primary", [NSNumber numberWithBool: YES]];
  return [[_payoutMethods allValues] filteredArrayUsingPredicate: predicate];
}

- (void) performInitialLoginSetup
{
  // Load the user's favorites
  [self fetchFavorites];
  // Load the user's payout methods
  [self fetchPayoutMethodsWithCompletion: nil];

  // Store the access token in the user defaults
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  NSDictionary *apiKeyDict = (NSMutableDictionary *)
    [defaults objectForKey: OMBUserDefaultsAPIKey];
  if (!apiKeyDict) {
    apiKeyDict = [NSMutableDictionary dictionary];
  }

  BOOL refreshExpiresAt = YES;
  // Access token
  if (_accessToken) {
    id previousAccessToken =
      [apiKeyDict objectForKey: OMBUserDefaultsAPIKeyAccessToken];
    if (previousAccessToken && previousAccessToken != [NSNull null]) {
      // If the old key matches the new key, don't refresh the expires at
      if ([(NSString *) previousAccessToken isEqualToString: _accessToken]) {
        refreshExpiresAt = NO;
      }
    }
  }
  else {

  }
  // Expires at
  NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
  NSTimeInterval threeDays = 60 * 60 * 24 * 3;
  if (refreshExpiresAt) {
    apiKeyDict = @{
      OMBUserDefaultsAPIKeyAccessToken: _accessToken,
      OMBUserDefaultsAPIKeyExpiresAt: [NSNumber numberWithFloat:
        now + threeDays]
    };
  }
  else {
    NSTimeInterval expiresAt = [[NSDate date] timeIntervalSince1970];
    if ([apiKeyDict objectForKey: OMBUserDefaultsAPIKeyExpiresAt])
      expiresAt = [[apiKeyDict objectForKey:
        OMBUserDefaultsAPIKeyExpiresAt] floatValue];
    apiKeyDict = @{
      OMBUserDefaultsAPIKeyAccessToken: _accessToken,
      OMBUserDefaultsAPIKeyExpiresAt: [NSNumber numberWithFloat: expiresAt]
    };
  }
  // Set the dictionary in the defaults
  [[NSUserDefaults standardUserDefaults] setObject: apiKeyDict
    forKey: OMBUserDefaultsAPIKey];
  [defaults synchronize];

  // Timer for fetching notifications
  _notificationFetchTimer = [NSTimer timerWithTimeInterval:
    kNotificationTimerInterval target: self
      selector: @selector(fetchNotificationCounts:) userInfo: nil
        repeats: YES];
  // NSRunLoopCommonModes, mode used for tracking events
  [[NSRunLoop currentRunLoop] addTimer: _notificationFetchTimer
    forMode: NSRunLoopCommonModes];

  // Update landlord type visuals in the view controller container
  // and the user menus
  [self postLandlordTypeChangeNotification];

  // Subscribe to push notification channels
  [[NSNotificationCenter defaultCenter] postNotificationName:
    OMBUserSubscribeToPushNotificationChannels object: nil
      userInfo: nil];
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

- (void) postLandlordTypeChangeNotification
{
  // NSLog(@"POST!!!!");
  [[NSNotificationCenter defaultCenter] postNotificationName:
    OMBCurrentUserLandlordTypeChangeNotification object: nil
      userInfo: @{
        @"landlordType" : _landlordType ? _landlordType : [NSNull null],
        @"userType"     : _userType     ? _userType     : [NSNull null]
      }
    ];
  // NSLog(@"POST: %@", _landlordType);
}

- (OMBPayoutMethod *) primaryDepositPayoutMethod
{

  return [[self depositPayoutMethods] firstObject];
}

- (OMBPayoutMethod *) primaryPaymentPayoutMethod
{
  return [[self paymentPayoutMethods] firstObject];
}

- (NSInteger) profilePercentage
{
  CGFloat count = 0.0f;
  CGFloat total = 7.0f;
  // Image
  if (_image && _imageURL) {
    NSRegularExpression *regex =
      [NSRegularExpression regularExpressionWithPattern: @"default_user_image"
        options: 0 error: nil];
    NSArray *matches = [regex matchesInString: _imageURL.absoluteString
      options: 0 range: NSMakeRange(0, [_imageURL.absoluteString length])];
    if (![matches count])
      count += 1;
  }
  if ([_firstName length])
    count += 1;
  if ([_lastName length])
    count += 1;
  if ([_school length])
    count += 1;
  if ([_email length])
    count += 1;
  if ([_phone length])
    count += 1;
  if ([_about length])
    count += 1;
  CGFloat percent = count / total;
  percent *= 100.0f;
  return (NSInteger) percent;
}

- (void) readFromAcceptedOffersDictionary: (NSDictionary *) dictionary
{
  NSMutableSet *newSet = [NSMutableSet set];
  for (NSDictionary *dict in [dictionary objectForKey: @"objects"]) {
    NSInteger offerUID = [[dict objectForKey: @"id"] intValue];
    OMBOffer *offer = [_acceptedOffers objectForKey:
      [NSNumber numberWithInt: offerUID]];
    if (!offer) {
      offer = [[OMBOffer alloc] init];
      [offer readFromDictionary: dict];
      [self addAcceptedOffer: offer];
    }
    else {
      [offer readFromDictionary: dict];
    }

    [newSet addObject: [NSNumber numberWithInt: offer.uid]];
  }

  // Remove the offers that are no longer suppose to be there
  NSMutableSet *oldSet = [NSMutableSet setWithArray:
    [[_acceptedOffers allValues] valueForKey: @"uid"]];
  [oldSet minusSet: newSet];
  for (NSNumber *number in [oldSet allObjects]) {
    [_acceptedOffers removeObjectForKey: number];
  }

    if (_acceptedOffers.count > 0) {
        NSArray *offers = [_acceptedOffers allValues];
        __block int waitingOffers = 0;
        [offers enumerateObjectsUsingBlock:^(OMBOffer *obj, NSUInteger idx, BOOL *stop) {
            if ( obj.accepted == YES && !(obj.onHold || obj.confirmed || obj.rejected || obj.declined)) {
                waitingOffers++;
            }
        }];

        [[NSNotificationCenter defaultCenter] postNotificationName:OMBOffersRenterAcceptedCountNotification object:@(waitingOffers)];
    }
}

- (void) readFromConfirmedTenantsDictionary: (NSDictionary *) dictionary
{
  NSMutableSet *newSet = [NSMutableSet set];
  for (NSDictionary *dict in [dictionary objectForKey: @"objects"]) {
    NSInteger oUID = [[dict objectForKey: @"id"] intValue];
    OMBOffer *obj = [_depositPayoutTransactions objectForKey:
      [NSNumber numberWithInt: oUID]];
    if (!obj) {
      obj = [[OMBOffer alloc] init];
      [obj readFromDictionary: dict];
      [self addConfirmedTenant: obj];
    }
    else {
      [obj readFromDictionary: dict];
    }

    [newSet addObject: [NSNumber numberWithInt: obj.uid]];
  }

  // Remove the offers that are no longer suppose to be there
  NSMutableSet *oldSet = [NSMutableSet setWithArray:
    [[_confirmedTenants allValues] valueForKey: @"uid"]];
  [oldSet minusSet: newSet];
  for (NSNumber *number in [oldSet allObjects]) {
    [_confirmedTenants removeObjectForKey: number];
  }
}

- (void) readFromDepositPayoutTransactionDictionary: (NSDictionary *) dictionary
{
  NSMutableSet *newSet = [NSMutableSet set];
  for (NSDictionary *dict in [dictionary objectForKey: @"objects"]) {
    NSInteger oUID = [[dict objectForKey: @"id"] intValue];
    OMBPayoutTransaction *obj = [_depositPayoutTransactions objectForKey:
      [NSNumber numberWithInt: oUID]];
    if (!obj) {
      obj = [[OMBPayoutTransaction alloc] init];
      [obj readFromDictionary: dict];
      [self addDepositPayoutTransaction: obj];
    }
    else {
      [obj readFromDictionary: dict];
    }

    [newSet addObject: [NSNumber numberWithInt: obj.uid]];
  }

  // Remove the offers that are no longer suppose to be there
  NSMutableSet *oldSet = [NSMutableSet setWithArray:
    [[_depositPayoutTransactions allValues] valueForKey: @"uid"]];
  [oldSet minusSet: newSet];
  for (NSNumber *number in [oldSet allObjects]) {
    [_depositPayoutTransactions removeObjectForKey: number];
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
  NSInteger userUID = 0;
  if ([dictionary objectForKey: @"id"] != [NSNull null]) {
    userUID = [[dictionary objectForKey: @"id"] intValue];
    _uid = userUID;
  }
  // Make sure readFromDictionary doesn't overwrite the
  // current user's access token
  if ([OMBUser currentUser].uid && [OMBUser currentUser].uid == userUID) {
    if ([dictionary objectForKey: @"access_token"]) {
      _accessToken = [dictionary objectForKey: @"access_token"];
    }
  }

  // About
  _about = [dictionary objectForKey: @"about"];
  if (!_about)
    _about = @"";
  // Email
  _email = [dictionary objectForKey: @"email"];
  // First name
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
    // If user has no image
    if ([string isEqualToString: @"default_user_image.png"]) {
      string = [string stringByAppendingString: @"/"];
      _image = [UIImage imageNamed: @"profile_default_pic.png"];
      self.hasDefaultImage = YES;
    }
    else {
      self.hasDefaultImage = NO;
    }
    string = [NSString stringWithFormat: @"%@%@", baseURLString, string];
  }
  _imageURL = [NSURL URLWithString: string];

  // Landlord type
  if ([dictionary objectForKey: @"landlord_type"] != [NSNull null])
    _landlordType = [dictionary objectForKey: @"landlord_type"];

  // Last name
  if ([dictionary objectForKey: @"last_name"] != [NSNull null])
    _lastName = [dictionary objectForKey: @"last_name"];
  else
    _lastName = @"";

  // Offer price threshold
  if ([dictionary objectForKey: @"offer_price_threshold"]) {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults offerPriceThresholdSet:
      [[dictionary objectForKey: @"offer_price_threshold"] floatValue]];
  }

  // Phone
  _phone = [dictionary objectForKey: @"phone"];
  if (!_phone)
    _phone = @"";
  _school = [dictionary objectForKey: @"school"];
  // Scrool
  if (!_school)
    _school = @"";
  // User type
  _userType = [dictionary objectForKey: @"user_type"];

  // Renter application
  if ([dictionary objectForKey: @"renter_application"]) {
    [_renterApplication readFromDictionary:
      [dictionary objectForKey: @"renter_application"]];
  }

  // Add to the OMBUserStore
  // [[OMBUserStore sharedStore] addUser: self];
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

- (void) readFromMovedInDictionary: (NSDictionary *) dictionary
{
  NSMutableSet *newSet = [NSMutableSet set];
  for (NSDictionary *dict in [dictionary objectForKey: @"objects"]) {
    NSInteger oUID = [[dict objectForKey: @"id"] intValue];
    OMBOffer *obj = [_movedIn objectForKey: [NSNumber numberWithInt: oUID]];
    if (!obj) {
      obj = [[OMBOffer alloc] init];
      [obj readFromDictionary: dict];
      [self addMovedIn: obj];
    }
    else {
      [obj readFromDictionary: dict];
    }

    [newSet addObject: [NSNumber numberWithInt: obj.uid]];
  }

  // Remove the offers that are no longer suppose to be there
  NSMutableSet *oldSet = [NSMutableSet setWithArray:
    [[_movedIn allValues] valueForKey: @"uid"]];
  [oldSet minusSet: newSet];
  for (NSNumber *number in [oldSet allObjects]) {
    [_movedIn removeObjectForKey: number];
  }
}

- (void) readFromPayoutMethodsDictionary: (NSDictionary *) dictionary
{
  NSMutableSet *newSet = [NSMutableSet set];
  for (NSDictionary *dict in [dictionary objectForKey: @"objects"]) {
    NSInteger payoutMethodUID = [[dict objectForKey: @"id"] intValue];
    OMBPayoutMethod *payoutMethod = [_payoutMethods objectForKey:
      [NSNumber numberWithInt: payoutMethodUID]];
    if (!payoutMethod) {
      payoutMethod = [[OMBPayoutMethod alloc] init];
      [payoutMethod readFromDictionary: dict];
      [self addPayoutMethod: payoutMethod];
    }
    else {
      [payoutMethod readFromDictionary: dict];
    }

    [newSet addObject: [NSNumber numberWithInt: payoutMethod.uid]];
  }

  // Remove the offers that are no longer suppose to be there
  NSMutableSet *oldSet = [NSMutableSet setWithArray:
    [[_payoutMethods allValues] valueForKey: @"uid"]];
  [oldSet minusSet: newSet];
  for (NSNumber *number in [oldSet allObjects]) {
    [_payoutMethods removeObjectForKey: number];
  }
}

- (void) readFromReceivedOffersDictionary: (NSDictionary *) dictionary
{
  NSMutableSet *newSet = [NSMutableSet set];
  for (NSDictionary *dict in [dictionary objectForKey: @"objects"]) {
    NSInteger offerUID = [[dict objectForKey: @"id"] intValue];
    OMBOffer *offer = [_receivedOffers objectForKey:
      [NSNumber numberWithInt: offerUID]];
    if (!offer) {
      offer = [[OMBOffer alloc] init];
      [offer readFromDictionary: dict];
      [self addReceivedOffer: offer];
    }
    else {
      [offer readFromDictionary: dict];
    }

    [newSet addObject: [NSNumber numberWithInt: offer.uid]];
  }

  // Remove the offers that are no longer suppose to be there
  NSMutableSet *oldSet = [NSMutableSet setWithArray:
    [[_receivedOffers allValues] valueForKey: @"uid"]];
  [oldSet minusSet: newSet];
  for (NSNumber *number in [oldSet allObjects]) {
    [_receivedOffers removeObjectForKey: number];
  }
    if (_receivedOffers.count > 0) {
        NSArray *offers = [_receivedOffers allValues];
        __block int waitingOffers = 0;
        [offers enumerateObjectsUsingBlock:^(OMBOffer *obj, NSUInteger idx, BOOL *stop) {
            if (!(obj.accepted || obj.onHold || obj.confirmed || obj.rejected || obj.declined)) {
                waitingOffers++;
            }
        }];

        [[NSNotificationCenter defaultCenter] postNotificationName:OMBOffersLandordPendingCountNotification object:@(waitingOffers)];
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

- (void) rejectOffer: (OMBOffer *) offer
withCompletion: (void (^) (NSError *error)) block
{
  OMBOfferDecisionConnection *conn =
    [[OMBOfferDecisionConnection alloc] initWithOffer: offer
      decision: OMBOfferDecisionConnectionTypeReject];
  conn.completionBlock = block;
  [conn start];
}

- (void) removeAllReceivedOffersWithOffer: (OMBOffer *) offer
{
  NSPredicate *predicate = [NSPredicate predicateWithFormat: @"%K == %i",
    @"residence.uid", offer.residence.uid];
  NSArray *array = [[_receivedOffers allValues] filteredArrayUsingPredicate:
    predicate];
  for (OMBOffer *o in array) {
    if (o.uid != offer.uid)
      [_receivedOffers removeObjectForKey: [NSNumber numberWithInt: o.uid]];
  }
}

- (void) removeOffer: (OMBOffer *) offer type: (OMBUserOfferType) type
{
  NSNumber *key = [NSNumber numberWithInt: offer.uid];
  if (type == OMBUserOfferTypeAccepted)
    [_acceptedOffers removeObjectForKey: key];
  else if (type == OMBUserOfferTypeReceived)
    [_receivedOffers removeObjectForKey: key];
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

- (NSArray *) residencesActive: (BOOL) active sortedWithKey: (NSString *) key
ascending: (BOOL) ascending
{
  NSPredicate *predicate = [NSPredicate predicateWithFormat: @"%K == %@",
    @"inactive", active ? [NSNumber numberWithBool: NO] :
      [NSNumber numberWithBool: YES]];
  NSArray *array = [[_residences objectForKey: @"residences"] allValues];
  array = [array filteredArrayUsingPredicate: predicate];
  NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey: key
    ascending: ascending];
  return [array sortedArrayUsingDescriptors: @[sort]];
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
      NSLog(@"Facebook active session is open\n%@", user);
      [OMBUser currentUser].facebookAccessToken =
        [[[FBSession activeSession] accessTokenData] accessToken];
      [OMBUser currentUser].facebookId = [user objectForKey: @"id"];
      // If user is logged in already; this is usually done
      // from the renter profile, become verified
      if ([[OMBUser currentUser] loggedIn]) {
        // If the user successfully has a facebook access token
        // and a facebook id
        if ([OMBUser currentUser].facebookAccessToken &&
          [OMBUser currentUser].facebookId) {
          // Create an authentication model for provider Facebook
          // in the database on the web server
          [[OMBUser currentUser] createAuthenticationForFacebookWithCompletion:
            ^(NSError *error) {
              NSMutableDictionary *userInfoDict =
                [NSMutableDictionary dictionary];
              if (error)
                [userInfoDict setObject: error forKey: @"error"];
              [[NSNotificationCenter defaultCenter] postNotificationName:
                OMBUserCreateAuthenticationForFacebookNotification
                  object: nil userInfo: (NSDictionary *) userInfoDict];
            }
          ];
        }
      }
      else {
        [[OMBUser currentUser] parseFacebookUserData: user];
        [[OMBUser currentUser] authenticateWithServer: nil];
      }
    }
  };
  if (FBSession.activeSession.isOpen)
    [FBRequestConnection startForMeWithCompletionHandler: completion];
}

- (void) parseFacebookUserData: (id <FBGraphUser>) user
{
  _email     = [user objectForKey: @"email"];
  _firstName = [user objectForKey: @"first_name"];
  _lastName  = [user objectForKey: @"last_name"];

  // Education - School
  NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:
    NSGregorianCalendar];
  NSDateComponents *dateComponents = [gregorian components: NSYearCalendarUnit
    fromDate: [NSDate date]];

  NSInteger thisYear = [dateComponents year];
  NSInteger schoolYear = 0;
  NSInteger currentSchoolYear = 1;
  BOOL currentlyInSchool = NO;
  if ([user objectForKey: @"education"]) {
    for (NSDictionary *dict in [user objectForKey: @"education"]) {
      NSString *type = [dict objectForKey: @"type"];
      if (type && [type length]) {
        // If it is college
        if ([[type lowercaseString] isEqualToString: @"college"]) {
          // Year
          currentSchoolYear = thisYear;
          if ([dict objectForKey: @"year"]) {
            if ([[dict objectForKey: @"year"] objectForKey: @"name"]) {
              currentSchoolYear = [[[dict objectForKey: @"year"] objectForKey:
                @"name"] intValue];
            }
            currentlyInSchool = NO;
          }
          else {
            currentlyInSchool = YES;
          }
          NSDictionary *schoolDict = [dict objectForKey: @"school"];
          if (schoolDict) {
            if (currentSchoolYear > schoolYear) {
              NSString *schoolName = [schoolDict objectForKey: @"name"];
              _school = schoolName;

              schoolYear = currentSchoolYear;
            }
          }
        }
      }
    }
  }

  // Hometown
  NSString *location;
  if ([user objectForKey: @"hometown"]) {
    location = [[user objectForKey: @"hometown"] objectForKey: @"name"];
  }

  // Location
  if (!location && [user objectForKey: @"location"]) {
    location = [[user objectForKey: @"location"] objectForKey: @"name"];
  }

  // Work - Job title
  NSString *employer;
  NSString *position;
  NSTimeInterval today = [[NSDate date] timeIntervalSince1970];
  NSTimeInterval workDate = 0;
  NSTimeInterval currentWorkDate = 1;
  if ([user objectForKey: @"work"]) {
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    for (NSDictionary *dict in [user objectForKey: @"work"]) {
      // Start date
      currentWorkDate = today;
      if ([dict objectForKey: @"start_date"]) {
        currentWorkDate = [[dateFormatter dateFromString:
          [dict objectForKey: @"start_date"]] timeIntervalSince1970];
      }
      // If this is the most recent job
      if (currentWorkDate > workDate) {
        // Employer
        if ([dict objectForKey: @"employer"]) {
          employer = [[dict objectForKey: @"employer"] objectForKey: @"name"];
        }
        // Position
        if ([dict objectForKey: @"position"]) {
          position = [[dict objectForKey: @"position"] objectForKey: @"name"];
        }
        workDate = currentWorkDate;
      }
    }
  }

  // About
  // Name
  NSString *aboutString = [NSString stringWithFormat: @"Hello, I am %@",
    [self fullName]];
  // Location
  if (location && [location length]) {
    aboutString = [aboutString stringByAppendingString:
      [NSString stringWithFormat: @" from %@.", location]];
  }
  else {
    aboutString = [aboutString stringByAppendingString: @"."];
  }
  // School
  if (_school && [_school length]) {
    NSString *studyString = @"studied";
    if (currentlyInSchool)
      studyString = @"study";
    aboutString = [aboutString stringByAppendingString:
      [NSString stringWithFormat: @" I %@ at %@.", studyString, _school]];
  }
  // Work
  if (employer && [employer length]) {
    if (position && [position length]) {
      NSString *aString = @"a";
      NSString *firstLetter = [position substringToIndex: 1];
      if ([[[firstLetter lowercaseString] matchingResultsWithRegularExpression:
        @"[aeiouy]"] count]) {

        aString = @"an";
      }
      aboutString = [aboutString stringByAppendingString:
        [NSString stringWithFormat: @" I am %@ %@ at %@.",
          aString, position, employer]];
    }
    else {
      aboutString = [aboutString stringByAppendingString:
        [NSString stringWithFormat: @" I work at %@.", employer]];
    }
  }
  _about = aboutString;
}

- (NSString *) shortName
{
  if (_firstName && [_firstName length] && _lastName && [_lastName length])
    return [NSString stringWithFormat: @"%@ %@.",
      [self.firstName capitalizedString],
        [[self.lastName substringToIndex: 1] capitalizedString]];
  return @"";
}

- (NSArray *) sortedOffersType: (OMBUserOfferType) type
withKeys: (NSArray *) keys ascending: (BOOL) ascending
{
  NSMutableArray *arrayOfKeys = [NSMutableArray array];
  for (NSString *key in keys) {
    [arrayOfKeys addObject: [NSSortDescriptor sortDescriptorWithKey: key
      ascending: ascending]];
  }
  NSArray *array;
  if (type == OMBUserOfferTypeAccepted)
    array = [_acceptedOffers allValues];
  else if (type == OMBUserOfferTypeReceived)
    array = [_receivedOffers allValues];
  return [array sortedArrayUsingDescriptors: arrayOfKeys];
}

- (NSArray *) sortedPayoutMethodsWithKey: (NSString *) key
ascending: (BOOL) ascending
{
  NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey: key
    ascending: ascending];
  return [[_payoutMethods allValues] sortedArrayUsingDescriptors: @[sort]];
}

- (void) subscribeToPushNotificationChannels
{
  PFInstallation *currentInstallation = [PFInstallation currentInstallation];
  // Conversations
  [currentInstallation addUniqueObject:
    [OMBUser pushNotificationChannelForConversations: self.uid]
      forKey: ParseChannelsKey];
  [currentInstallation saveInBackground];
  // Offers placed
  [currentInstallation addUniqueObject:
    [OMBUser pushNotificationChannelForOffersPlaced: self.uid]
      forKey: ParseChannelsKey];
  [currentInstallation saveInBackground];
  // Offers received
  [currentInstallation addUniqueObject:
    [OMBUser pushNotificationChannelForOffersReceived: self.uid]
      forKey: ParseChannelsKey];
  [currentInstallation saveInBackground];
}

- (void) updateWithDictionary: (NSDictionary *) dictionary
completion: (void (^) (NSError *error)) block
{
  OMBUserUpdateConnection *conn =
    [[OMBUserUpdateConnection alloc] initWithDictionary: dictionary];
  conn.completionBlock = block;
  [conn start];
}

- (void) uploadImage: (UIImage *) img
withCompletion: (void (^) (NSError *error)) block
{
  CGSize newSize = CGSizeMake(640.0f, 320.0f);

  UIImage *image = [UIImage image: img proportionatelySized: newSize];
  [OMBUser currentUser].image = image;

  OMBUserUploadImageConnection *conn =
    [[OMBUserUploadImageConnection alloc] init];
  conn.completionBlock = block;
  [conn start];

  // Observers:
  // OMBViewControllerContainer
  [[NSNotificationCenter defaultCenter] postNotificationName:
    OMBCurrentUserUploadedImage object: nil];
}

- (BOOL) visited:(int)uid
{
  NSNumber *key = [NSNumber numberWithInt: uid];
  if([_residencesVisited objectForKey: key])
    return YES;
  
  return NO;
}

@end
