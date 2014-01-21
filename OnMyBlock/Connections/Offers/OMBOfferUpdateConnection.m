//
//  OMBOfferUpdateConnection.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 1/20/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBOfferUpdateConnection.h"

#import "OMBOffer.h"

@implementation OMBOfferUpdateConnection

#pragma mark - Initializer

- (id) initWithOffer: (OMBOffer *) object attributes: (NSArray *) attributes
{
  if (!(self = [super init])) return nil;

  offer = object;

  NSString *string = [NSString stringWithFormat: @"%@/offers/%i", 
    OnMyBlockAPIURL, offer.uid];

  NSMutableDictionary *attributesDictionary = [NSMutableDictionary dictionary];
  for (NSString *attribute in attributes) {
    NSString *key = attribute;
    id value = [offer valueForKey: key];
    // Accepted
    if ([key isEqualToString: @"accepted"]) {
      if (offer.accepted) {
        value = @"true";
      }
      else {
        value = @"false";
      }
    }
    // Confirmed
    if ([key isEqualToString: @"confirmed"]) {
      if (offer.confirmed) {
        value = @"true";
      }
      else {
        value = @"false";
      }
    }
    // Declined
    if ([key isEqualToString: @"declined"]) {
      if (offer.declined) {
        value = @"true";
      }
      else {
        value = @"false";
      }
    }
    // Rejected
    if ([key isEqualToString: @"rejected"]) {
      if (offer.rejected) {
        value = @"true";
      }
      else {
        value = @"false";
      }
    }
    [attributesDictionary setObject: value forKey: key];
  }

  NSDictionary *params = @{
    @"access_token": [OMBUser currentUser].accessToken,
    @"offer": attributesDictionary
  };
  [self setRequestWithString: string method: @"PATCH" parameters: params];

  return self;
}

#pragma mark - Protocol

#pragma mark - Protocol NSURLConnectionDataDelegate

- (void) connectionDidFinishLoading: (NSURLConnection *) connection
{
  NSLog(@"OMBOfferUpdateConnection\n%@", [self json]);

  if ([self successful]) {
    [offer readFromDictionary: [self objectDictionary]];
  }

  [super connectionDidFinishLoading: connection];
}

@end
