//
//  OMBOfferVerifyVenmoConnection.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 2/12/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBOfferVerifyVenmoConnection.h"

#import "OMBOffer.h"

@implementation OMBOfferVerifyVenmoConnection

#pragma mark - Initializer

- (id) initWithOffer: (OMBOffer *) object 
dictionary: (NSDictionary *) dictionary
{
  if (!(self = [super init])) return nil;

  offer = object;

  NSString *string = [NSString stringWithFormat: 
    @"%@/offers/%i/verify_venmo", OnMyBlockAPIURL, offer.uid];
  NSDictionary *params = @{
    @"access_token":   [OMBUser currentUser].accessToken,
    @"amount":         [dictionary objectForKey: @"amount"],
    @"note":           [dictionary objectForKey: @"note"],
    @"transaction_id": [dictionary objectForKey: @"transactionID"]
  };
  [self setRequestWithString: string method: @"POST" parameters: params];

  return self;
}

#pragma mark - Protocol

#pragma mark - Protocol NSURLConnectionDataDelegate

- (void) connectionDidFinishLoading: (NSURLConnection *) connection
{
  if ([self successful]) {
    [offer readFromDictionary: [self objectDictionary]];
  }
  else {
    [self createInternalErrorWithDomain: VenmoErrorDomain
      code: VenmoErrorDomainCodeTransactionWebServerGenericError];
  }

  [super connectionDidFinishLoading: connection];
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) start
{
  [self startWithTimeoutInterval: 60 onMainRunLoop: NO];
}

@end
