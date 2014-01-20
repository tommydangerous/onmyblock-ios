//
//  OMBOffersReceivedConnection.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 1/20/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBOffersReceivedConnection.h"

@implementation OMBOffersReceivedConnection

#pragma mark - Initializer

- (id) init
{
  if (!(self = [super init])) return nil;

  NSString *string = [NSString stringWithFormat: 
    @"%@/offers/received/?access_token=%@", 
      OnMyBlockAPIURL, [OMBUser currentUser].accessToken];
  [self setRequestWithString: string];

  return self;
}

#pragma mark - Protocol

#pragma mark - Protocol NSURLConnectionDataDelegate

- (void) connectionDidFinishLoading: (NSURLConnection *) connection
{
  [[OMBUser currentUser] readFromReceivedOffersDictionary: [self json]];

  [super connectionDidFinishLoading: connection];
}

@end
