//
//  OMBOffer.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 1/14/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import <Foundation/Foundation.h>

@class OMBPayoutTransaction;
@class OMBResidence;
@class OMBUser;

extern NSInteger kMaxHoursForStudentToConfirm;
extern NSInteger kWebServerTimeOffsetInSeconds;

extern NSString *const OMBOfferNotificationPaidWithVenmo;
extern NSString *const OMBOfferNotificationProcessingWithServer;
extern NSString *const OMBOfferNotificationVenmoAppSwitchCancelled;

typedef NS_ENUM(NSInteger, OMBOfferStatusForLandlord) {
  OMBOfferStatusForLandlordRejected,
  OMBOfferStatusForLandlordConfirmed,
  OMBOfferStatusForLandlordAccepted,
  OMBOfferStatusForLandlordOnHold,
  OMBOfferStatusForLandlordDeclined,
  OMBOfferStatusForLandlordResponseRequired,
  OMBOfferStatusForLandlordExpired,
  OMBOfferStatusForLandlordOfferPaid,
  OMBOfferStatusForLandlordOfferPaidExpired
};

typedef NS_ENUM(NSInteger, OMBOfferStatusForStudent) {
  OMBOfferStatusForStudentRejected,
  OMBOfferStatusForStudentConfirmed,
  OMBOfferStatusForStudentAccepted,
  OMBOfferStatusForStudentOnHold,
  OMBOfferStatusForStudentDeclined,
  OMBOfferStatusForStudentWaitingForLandlordResponse,
  OMBOfferStatusForStudentExpired,
  OMBOfferStatusForStudentOfferPaid,
  OMBOfferStatusForStudentOfferPaidExpired
};

@interface OMBOffer : NSObject

@property (nonatomic) BOOL accepted;
@property (nonatomic) BOOL onHold;
@property (nonatomic) BOOL confirmed;
@property (nonatomic) BOOL rejected;
@property (nonatomic) BOOL declined;
@property (nonatomic) NSTimeInterval acceptedDate;
@property (nonatomic) NSTimeInterval createdAt;
@property (nonatomic) NSTimeInterval moveInDate;
@property (nonatomic) NSTimeInterval moveOutDate;
@property (nonatomic) CGFloat amount;
@property (nonatomic, strong) NSString *note;
@property (nonatomic, strong) OMBPayoutTransaction *payoutTransaction;

@property (nonatomic) NSTimeInterval updatedAt;

@property (nonatomic, strong) OMBUser *landlordUser;
@property (nonatomic, strong) OMBResidence *residence;
@property (nonatomic) NSInteger uid;
@property (nonatomic, strong) OMBUser *user;

#pragma mark - Methods

#pragma mark - Class Methods

+ (CGFloat) downPaymentPercentage;

#pragma mark - Instance Methods

- (CGFloat) downPaymentAmount;
- (BOOL) isExpiredForLandlord;
- (BOOL) isExpiredForStudent;
- (void) readFromDictionary: (NSDictionary *) dictionary;
- (NSInteger) numberOfMonthsBetweenMovingDates;
- (CGFloat) remainingBalanceAmount;
- (OMBOfferStatusForLandlord) statusForLandlord;
- (OMBOfferStatusForStudent) statusForStudent;
- (NSString *) statusStringForLandlord;
- (NSString *) statusStringForStudent;
- (void) sendPushNotificationAccepted;
- (NSInteger) timeLeftForLandlord;
- (NSInteger) timeLeftForStudent;
- (CGFloat) timeLeftPercentageForLandlord;
- (CGFloat) timeLeftPercentageForStudent;
- (NSString *) timeLeftStringForLandlord;
- (NSString *) timeLeftStringForStudent;
- (NSString *) timelineStringForLandlord;
- (NSString *) timelineStringForStudent;
- (CGFloat) totalAmount;

@end
