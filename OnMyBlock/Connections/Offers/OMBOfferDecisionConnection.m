//
//  OMBOfferDecisionConnection.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 1/21/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBOfferDecisionConnection.h"

#import "OMBOffer.h"
#import "OMBPayoutTransaction.h"

@implementation OMBOfferDecisionConnection

#pragma mark - Initializer

- (id) initWithOffer: (OMBOffer *) object 
decision: (OMBOfferDecisionConnectionType) type
{
  if (!(self = [super init])) return nil;

  offer = object;

  NSString *actionString;

  if (type == OMBOfferDecisionConnectionTypeAccept)
    actionString = @"accept";
  else if (type == OMBOfferDecisionConnectionTypeConfirm)
    actionString = @"confirm";
  else if (type == OMBOfferDecisionConnectionTypeDecline)
    actionString = @"decline";
  else if (type == OMBOfferDecisionConnectionTypeReject)
    actionString = @"reject";

  NSString *string = [NSString stringWithFormat: @"%@/offers/%i/%@",
    OnMyBlockAPIURL, offer.uid, actionString];
  NSDictionary *params = @{
    @"access_token": [OMBUser currentUser].accessToken
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
  // NSLog(@"OMBOfferDecisionConnection\n%@", [self json]);

  if ([self successful]) {
    [offer readFromDictionary: [self objectDictionary]];

    // Payout Transaction
    if ([[self json] objectForKey: @"payout_transaction"] != [NSNull null]) {
      NSDictionary *dict = [[self json] objectForKey: @"payout_transaction"];
      OMBPayoutTransaction *payoutTransaction = 
        [[OMBPayoutTransaction alloc] init];
      [payoutTransaction readFromDictionary: dict];
      offer.payoutTransaction = payoutTransaction;
    }
  }
  else {
    [self createInternalErrorWithDomain: OMBConnectionErrorDomainOffer
      code: OMBConnectionErrorDomainOfferCodeAcceptFailed];
  }

  [super connectionDidFinishLoading: connection];
}

@end
