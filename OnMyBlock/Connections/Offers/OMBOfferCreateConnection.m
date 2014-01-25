//
//  OMBOfferCreateConnection.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 1/20/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBOfferCreateConnection.h"

#import "NSString+Extensions.h"
#import "OMBOffer.h"
#import "OMBResidence.h"

@implementation OMBOfferCreateConnection

#pragma mark - Initializer

- (id) initWithOffer: (OMBOffer *) object
{
  if (!(self = [super init])) return nil;

  offer = object;

  NSString *string = [NSString stringWithFormat: @"%@/offers", OnMyBlockAPIURL];
  CGFloat amount = offer.amount;
  if (!amount)
    amount = 0;
  NSString *note = offer.note;
  if (!offer.note || ![[offer.note stripWhiteSpace] length])
    note = @"";
  NSInteger residenceID = object.residence.uid;
  if (!residenceID)
    residenceID = 0;
  NSDictionary *params = @{
    @"access_token": [OMBUser currentUser].accessToken,
    @"offer": @{
      @"amount": [NSNumber numberWithFloat: amount],
      @"note": note,
      @"residence_id": [NSNumber numberWithInt: residenceID]
    }
  };
  [self setRequestWithString: string method: @"POST" parameters: params];

  return self;
}

#pragma mark - Protocol

#pragma mark - Protocol NSURLConnectionDataDelegate

- (void) connectionDidFinishLoading: (NSURLConnection *) connection
{
  NSLog(@"OMBOfferCreateConnection\n%@", [self json]);
  if ([self successful]) {
    offer.uid = [self objectUID];
  }
  [super connectionDidFinishLoading: connection];
}

@end
