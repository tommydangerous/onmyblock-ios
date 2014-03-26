
//
//  OMBPayoutMethod.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 1/22/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import <Foundation/Foundation.h>

// Keys
// PayPal
extern NSString *const PayPalClientID;
extern NSString *const PayPalReceiverEmail;
// Venmo
extern NSString *const VenmoClientID;
extern NSString *const VenmoClientSecret;
// Notifications
extern NSString *const OMBPayoutMethodNotificationFirst;

typedef enum {
  OMBPayoutMethodPayoutTypePayPal,
  OMBPayoutMethodPayoutTypeVenmo,
  OMBPayoutMethodPayoutTypeCreditCard,
} OMBPayoutMethodPayoutType;

@interface OMBPayoutMethod : NSObject

@property (nonatomic) BOOL active;
@property (nonatomic) NSTimeInterval createdAt;
@property (nonatomic) BOOL deposit;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *payoutType;
@property (nonatomic) BOOL payment;
@property (nonatomic) BOOL primary;
@property (nonatomic) NSInteger providerID;
@property (nonatomic) NSTimeInterval updatedAt;

@property (nonatomic) NSInteger uid;

#pragma mark - Methods

#pragma mark - Class Methods

+ (CGFloat) maximumVenmoTransfer;

#pragma mark - Instance Methods

- (BOOL) isPayPal;
- (BOOL) isVenmo;
- (BOOL) isCreditCard;
- (void) readFromDictionary: (NSDictionary *) dictionary;
- (OMBPayoutMethodPayoutType) type;

@end
