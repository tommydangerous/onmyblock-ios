//
//  OMBPayoutMethodCreateConnection.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 1/22/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBPayoutMethodCreateConnection.h"

#import "OMBPayoutMethod.h"

@implementation OMBPayoutMethodCreateConnection

#pragma mark - Initializer

- (id) initWithDictionary: (NSDictionary *) dictionary
{
  if (!(self = [super init])) return nil;

  NSString *string = [NSString stringWithFormat: @"%@/payout_methods",
    OnMyBlockAPIURL];
  NSDictionary *params = @{
    @"access_token": [OMBUser currentUser].accessToken,
    @"payout_method": @{
      @"active": [[dictionary objectForKey: @"active"] intValue] ? 
        @"true" : @"false",
      @"deposit": [[dictionary objectForKey: @"deposit"] intValue] ? 
        @"true" : @"false",
      @"email": [dictionary objectForKey: @"email"] != 
        [NSNull null] ? [dictionary objectForKey: @"email"] : @"",
      @"payout_type": [dictionary objectForKey: @"payoutType"],
      @"primary": [[dictionary objectForKey: @"primary"] intValue] ? 
        @"true" : @"false"
    }
  };
  [self setRequestWithString: string method: @"POST" parameters: params];

  return self;
}

#pragma mark - Protocol

#pragma mark - Protocol NSURLConnectionDataDelegate

- (void) connectionDidFinishLoading: (NSURLConnection *) connection
{
  NSLog(@"OMBPayoutMethodCreateConnection\n%@", [self json]);

  if ([self successful]) {
    [[OMBUser currentUser] readFromPayoutMethodsDictionary: @{
      @"objects": @[[self objectDictionary]]
    }];
  }

  [super connectionDidFinishLoading: connection];
}

@end
