//
//  OMBPayoutTransaction.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 1/23/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBPayoutTransaction.h"

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

  // Payer

  // Residence

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
