//
//  OMBPayPalVerifyMobilePaymentConnection.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/12/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBPayPalVerifyMobilePaymentConnection.h"

#import "OMBOffer.h"
#import "OMBPayoutTransaction.h"

@implementation OMBPayPalVerifyMobilePaymentConnection

#pragma mark - Initializer

- (id) initWithOffer: (OMBOffer *) object 
paymentConfirmation: (NSDictionary *) dictionary
{
  if (!(self = [super init])) return nil;

  offer = object;

  NSString *string = [NSString stringWithFormat: @"%@/offers/%i/charge_paypal",
    OnMyBlockAPIURL, offer.uid];
  NSDictionary *params = @{
    @"access_token": [OMBUser currentUser].accessToken,
    @"confirmation": dictionary
  };
  [self setRequestWithString: string method: @"POST" parameters: params];

  return self;
}

- (void) start
{
  [self startWithTimeoutInterval: 120 onMainRunLoop: NO];
}

#pragma mark - Protocol

#pragma mark - Protocol NSURLConnectionDataDelegate

- (void) connectionDidFinishLoading: (NSURLConnection *) connection
{
  // NSLog(@"OMBPayPalVerifyMobilePaymentConnection\n%@", [self json]);

  if ([self successful]) {
    OMBPayoutTransaction *payoutTransaction = 
      [[OMBPayoutTransaction alloc] init];
    [payoutTransaction readFromDictionary: [self objectDictionary]];
    offer.payoutTransaction = payoutTransaction;
  }

  [super connectionDidFinishLoading: connection];
}

@end
