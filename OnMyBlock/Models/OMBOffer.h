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

typedef NS_ENUM(NSInteger, OMBOfferStatusForLandlord) {
  OMBOfferStatusForLandlordRejected,
  OMBOfferStatusForLandlordConfirmed,
  OMBOfferStatusForLandlordAccepted,
  OMBOfferStatusForLandlordOnHold,
  OMBOfferStatusForLandlordDeclined,
  OMBOfferStatusForLandlordResponseRequired,
  OMBOfferStatusForLandlordExpired
};

typedef NS_ENUM(NSInteger, OMBOfferStatusForStudent) {
  OMBOfferStatusForStudentRejected,
  OMBOfferStatusForStudentConfirmed,
  OMBOfferStatusForStudentAccepted,
  OMBOfferStatusForStudentOnHold,
  OMBOfferStatusForStudentDeclined,
  OMBOfferStatusForStudentWaitingForLandlordResponse,
  OMBOfferStatusForStudentExpired
};

@interface OMBOffer : NSObject

@property (nonatomic) BOOL accepted;
@property (nonatomic) NSTimeInterval acceptedDate;
@property (nonatomic) CGFloat amount;
@property (nonatomic) BOOL confirmed;
@property (nonatomic) NSTimeInterval createdAt;
@property (nonatomic) BOOL declined;
@property (nonatomic, strong) NSString *note;
@property (nonatomic) BOOL onHold;
@property (nonatomic) BOOL rejected;
@property (nonatomic) NSTimeInterval updatedAt;

@property (nonatomic, strong) OMBUser *landlordUser;
@property (nonatomic, strong) OMBPayoutTransaction *payoutTransaction;
@property (nonatomic, strong) OMBResidence *residence;
@property (nonatomic) NSInteger uid;
@property (nonatomic, strong) OMBUser *user;

#pragma mark - Methods

#pragma mark - Instance Methods

- (BOOL) isExpiredForLandlord;
- (BOOL) isExpiredForStudent;
- (void) readFromDictionary: (NSDictionary *) dictionary;
- (OMBOfferStatusForLandlord) statusForLandlord;
- (OMBOfferStatusForStudent) statusForStudent;
- (NSString *) statusStringForLandlord;
- (NSString *) statusStringForStudent;
- (NSInteger) timeLeftForLandlord;
- (NSInteger) timeLeftForStudent;
- (CGFloat) timeLeftPercentageForLandlord;
- (CGFloat) timeLeftPercentageForStudent;
- (NSString *) timeLeftStringForLandlord;
- (NSString *) timeLeftStringForStudent;
- (CGFloat) totalAmount;

@end
