//
//  OMBPayoutMethodListConnection.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 1/22/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBPayoutMethodListConnection.h"

@implementation OMBPayoutMethodListConnection

#pragma mark - Initializer

- (id) init
{
  if (!(self = [super init])) return nil;

  NSString *string = [NSString stringWithFormat: 
    @"%@/payout_methods/?access_token=%@", 
      OnMyBlockAPIURL, [OMBUser currentUser].accessToken];
  [self setRequestWithString: string];

  return self;
}

#pragma mark - Protocol

#pragma mark - Protocol NSURLConnectionDataDelegate

- (void) connectionDidFinishLoading: (NSURLConnection *) connection
{
  NSLog(@"OMBPayoutMethodListConnection\n%@", [self json]);

  [[OMBUser currentUser] readFromPayoutMethodsDictionary: [self json]];

  [super connectionDidFinishLoading: connection];
}

@end
