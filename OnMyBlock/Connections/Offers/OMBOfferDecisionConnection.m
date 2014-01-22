//
//  OMBOfferDecisionConnection.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 1/21/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBOfferDecisionConnection.h"

#import "OMBOffer.h"

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

#pragma mark - Protocol

#pragma mark - Protocol NSURLConnectionDataDelegate

- (void) connectionDidFinishLoading: (NSURLConnection *) connection
{
  NSLog(@"OMBOfferDecisionConnection\n%@", [self json]);

  if ([self successful]) {
    [offer readFromDictionary: [self objectDictionary]];
  }

  [super connectionDidFinishLoading: connection];
}

@end
