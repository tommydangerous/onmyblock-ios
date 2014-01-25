//
//  OMBConfirmedTenantsConnection.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 1/24/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBConfirmedTenantsConnection.h"

@implementation OMBConfirmedTenantsConnection

#pragma mark - Init

- (id) init
{
  if (!(self = [super init])) return nil;

  NSString *string = [NSString stringWithFormat: 
    @"%@/offers/confirmed_tenants/?access_token=%@",
      OnMyBlockAPIURL, [OMBUser currentUser].accessToken];
  [self setRequestWithString: string];

  return self;
}

#pragma mark - Protocol

#pragma mark - Protocol NSURLConnectionDataDelegate

- (void) connectionDidFinishLoading: (NSURLConnection *) connection
{
  [[OMBUser currentUser] readFromConfirmedTenantsDictionary: [self json]];
  [super connectionDidFinishLoading: connection]; 
}

@end
