//
//  OMBOffersAcceptedConnection.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 1/21/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBOffersAcceptedConnection.h"

@implementation OMBOffersAcceptedConnection

#pragma mark - Initializer

- (id) init
{
  if (!(self = [super init])) return nil;

  NSString *string = [NSString stringWithFormat: 
    @"%@/offers/accepted/?access_token=%@", 
      OnMyBlockAPIURL, [OMBUser currentUser].accessToken];
  [self setRequestWithString: string];

  return self;
}

#pragma mark - Protocol

#pragma mark - Protocol NSURLConnectionDataDelegate

- (void) connectionDidFinishLoading: (NSURLConnection *) connection
{
  // NSLog(@"OMBOffersAcceptedConnection\n%@", [self json]);

  [[OMBUser currentUser] readFromAcceptedOffersDictionary: [self json]];

  [super connectionDidFinishLoading: connection];
}

@end
