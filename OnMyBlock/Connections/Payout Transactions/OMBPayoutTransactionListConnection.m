//
//  OMBPayoutTransactionListConnection.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 1/24/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBPayoutTransactionListConnection.h"

@implementation OMBPayoutTransactionListConnection

#pragma mark - Initializer

- (id) initForDeposits: (BOOL) deposit
{
  if (!(self = [super init])) return nil;

  deposits = deposit;

  NSString *s = @"deposits";
  if (!deposit)
    s = @"payments";
  NSString *string = [NSString stringWithFormat: 
    @"%@/payout_transactions/%@/?access_token=%@",
      OnMyBlockAPIURL, s, [OMBUser currentUser].accessToken];
  [self setRequestWithString: string];

  return self;
}

#pragma mark - Protocol

#pragma mark - Protocol NSURLConnectionDataDelegate

- (void) connectionDidFinishLoading: (NSURLConnection *) connection
{
  if (deposits) {
    [[OMBUser currentUser] readFromDepositPayoutTransactionDictionary:
      [self json]];
  }
  else {

  }
  [super connectionDidFinishLoading: connection]; 
}

@end
