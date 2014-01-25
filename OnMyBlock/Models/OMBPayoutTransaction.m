//
//  OMBPayoutTransaction.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 1/23/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBPayoutTransaction.h"

#import "OMBAllResidenceStore.h"
#import "OMBResidence.h"
#import "OMBUser.h"
#import "OMBUserStore.h"

@implementation OMBPayoutTransaction

#pragma mark - Initializer

- (id) init
{
  if (!(self = [super init])) return nil;

  _uid = -9999 + arc4random_uniform(9998);
  
  return self;
}


#pragma mark - Methods

#pragma mark - Instance Methods

- (void) readFromDictionary: (NSDictionary *) dictionary
{
  // Amount
  if ([dictionary objectForKey: @"amount"] != [NSNull null])
    _amount = [[dictionary objectForKey: @"amount"] intValue];

  // Charged
  if ([[dictionary objectForKey: @"charged"] intValue])
    _charged = YES;
  else
    _charged = NO;

  // Expired
  if ([[dictionary objectForKey: @"expired"] intValue])
    _expired = YES;
  else
    _expired = NO;

  // Offer

  // Paid
  if ([[dictionary objectForKey: @"paid"] intValue])
    _paid = YES;
  else
    _paid = NO;

  // Payee
  if ([dictionary objectForKey: @"payee"] != [NSNull null]) {
    NSDictionary *dict = [dictionary objectForKey: @"payee"];
    NSInteger oUID = [[dict objectForKey: @"id"] intValue];
    OMBUser *obj = [[OMBUserStore sharedStore] userWithUID: oUID];
    if (!obj) {
      obj = [[OMBUser alloc] init];
      [obj readFromDictionary: dict];
    }
    _payee = obj;
  }


  // Payer
  if ([dictionary objectForKey: @"payer"] != [NSNull null]) {
    NSDictionary *dict = [dictionary objectForKey: @"payer"];
    NSInteger oUID = [[dict objectForKey: @"id"] intValue];
    OMBUser *obj = [[OMBUserStore sharedStore] userWithUID: oUID];
    if (!obj) {
      obj = [[OMBUser alloc] init];
      [obj readFromDictionary: dict];
    }
    _payer = obj;
  }

  // Residence
  if ([dictionary objectForKey: @"residence"] != [NSNull null]) {
    NSDictionary *dict = [dictionary objectForKey: @"residence"];
    NSInteger oUID = [[dict objectForKey: @"id"] intValue];
    OMBResidence *obj = [[OMBAllResidenceStore sharedStore] residenceForUID:
      oUID];
    if (!obj) {
      obj = [[OMBResidence alloc] init];
      [obj readFromResidenceDictionary: dict];
    }
    _residence = obj;
  }

  // Verified
  if ([[dictionary objectForKey: @"verified"] intValue])
    _verified = YES;
  else
    _verified = NO;

  // ID
  if ([dictionary objectForKey: @"id"] != [NSNull null])
    _uid = [[dictionary objectForKey: @"id"] intValue];
}

@end
