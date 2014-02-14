//
//  OMBAuthenticationVenmoConnection.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/18/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBAuthenticationVenmoConnection.h"

@implementation OMBAuthenticationVenmoConnection

#pragma mark - Initializer

- (id) initWithCode: (NSString *) code depositMethod: (BOOL) deposit
{
  if (!(self = [super init])) return nil;

  NSString *string = [NSString stringWithFormat: @"%@/authentications/venmo",
    OnMyBlockAPIURL];
  NSDictionary *params = @{
    @"access_token": [OMBUser currentUser].accessToken,
    @"code":    code,
    @"deposit": deposit ? @"true" : @"false"
  };
  [self setRequestWithString: string method: @"POST" parameters: params];

  return self;
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) start
{
  [self startWithTimeoutInterval: 30 onMainRunLoop: NO];
}

#pragma mark - Protocol

#pragma mark - Protocol NSURLConnectionDataDelegate

- (void) connectionDidFinishLoading: (NSURLConnection *) connection
{
  if ([self successful]) {
    [[OMBUser currentUser] readFromPayoutMethodsDictionary: @{
      @"objects": @[[self objectDictionary]]
    }];
  }
  [super connectionDidFinishLoading: connection];
}

@end
