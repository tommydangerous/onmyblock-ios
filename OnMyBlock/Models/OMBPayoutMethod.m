//
//  OMBPayoutMethod.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 1/22/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBPayoutMethod.h"

#import "NSDateFormatter+JSON.h"

// Notifications
NSString *const OMBPayoutMethodNotificationFirst =
  @"OMBPayoutMethodNotificationFirst";

@implementation OMBPayoutMethod

#pragma mark - Initializer

- (id) init
{
  if (!(self = [super init])) return nil;

  _uid = -9999 - arc4random_uniform(1000);

  return self;
}

#pragma mark - Methods

#pragma mark - Class Methods

+ (CGFloat) maximumVenmoTransfer
{
  return 3000.00;
}

#pragma mark - Instance Methods

- (BOOL) isPayPal
{
  return [self type] == OMBPayoutMethodPayoutTypePayPal;
}

- (BOOL) isVenmo
{
  return [self type] == OMBPayoutMethodPayoutTypeVenmo;
}

- (BOOL) isCreditCard
{
  return [self type] == OMBPayoutMethodPayoutTypeCreditCard;
}

- (void) readFromDictionary: (NSDictionary *) dictionary
{
  NSDateFormatter *dateFormatter = [NSDateFormatter JSONDateParser];

  // Active
  if ([dictionary objectForKey: @"active"] != [NSNull null]) {
    if ([[dictionary objectForKey: @"active"] intValue])
      _active = YES;
    else
      _active = NO;
  }

  // Created at
  if ([dictionary objectForKey: @"created_at"] != [NSNull null])
    _createdAt = [[dateFormatter dateFromString:
      [dictionary objectForKey: @"created_at"]] timeIntervalSince1970];

  // Deposit
  if ([dictionary objectForKey: @"deposit"] != [NSNull null]) {
    if ([[dictionary objectForKey: @"deposit"] intValue])
      _deposit = YES;
    else
      _deposit = NO;
  }

  // Email
  if ([dictionary objectForKey: @"email"] != [NSNull null])
    _email = [dictionary objectForKey: @"email"];

  // Payment
  if ([dictionary objectForKey: @"payment"] != [NSNull null]) {
    if ([[dictionary objectForKey: @"payment"] intValue]) {
      _payment = YES;
    }
    else {
      _payment = NO;
    }
  }

  // Payout Type
  if ([dictionary objectForKey: @"payout_type"] != [NSNull null])
    _payoutType = [dictionary objectForKey: @"payout_type"];

  // Primary
  if ([dictionary objectForKey: @"primary"] != [NSNull null]) {
    if ([[dictionary objectForKey: @"primary"] intValue])
      _primary = YES;
    else
      _primary = NO;
  }

  // Provider ID
  if ([dictionary objectForKey: @"provider_id"] != [NSNull null])
    _providerID = [[dictionary objectForKey: @"provider_id"] intValue];

  // UID
  if ([dictionary objectForKey: @"id"] != [NSNull null])
    _uid = [[dictionary objectForKey: @"id"] intValue];

  // Updated at
  if ([dictionary objectForKey: @"updated_at"] != [NSNull null])
    _updatedAt = [[dateFormatter dateFromString:
      [dictionary objectForKey: @"updated_at"]] timeIntervalSince1970];
}

- (OMBPayoutMethodPayoutType) type
{
  if ([[_payoutType lowercaseString] isEqualToString: @"paypal"]) {
    return OMBPayoutMethodPayoutTypePayPal;
  }
  else if ([[_payoutType lowercaseString] isEqualToString: @"venmo"]) {
    return OMBPayoutMethodPayoutTypeVenmo;
  }
  else if ([[_payoutType lowercaseString] isEqualToString: @"credit_card"]) {
    return OMBPayoutMethodPayoutTypeCreditCard;
  }
  return OMBPayoutMethodPayoutTypeVenmo;
}

@end
