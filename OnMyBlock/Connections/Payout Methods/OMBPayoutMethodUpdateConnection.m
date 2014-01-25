//
//  OMBPayoutMethodUpdateConnection.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 1/22/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBPayoutMethodUpdateConnection.h"

#import "OMBPayoutMethod.h"

@implementation OMBPayoutMethodUpdateConnection

#pragma mark - Initializer

- (id) initWithPayoutMethod: (OMBPayoutMethod *) object 
attributes: (NSArray *) attributes
{
  if (!(self = [super init])) return nil;

  payoutMethod = object;

  NSString *string = [NSString stringWithFormat: @"%@/payout_methods/%i",
    OnMyBlockAPIURL, payoutMethod.uid];

  NSMutableDictionary *attributeDictionary = [NSMutableDictionary dictionary];
  for (NSString *attribute in attributes) {
    NSString *key = attribute;
    id value = [object valueForKey: key];
    // Deposit, primary
    if ([key isEqualToString: @"deposit"] || 
      [key isEqualToString: @"primary"]) {
      value = [value intValue] ? @"true" : @"false";
    }
    [attributeDictionary setObject: value forKey: key];
  }

  NSDictionary *params = @{
    @"access_token": [OMBUser currentUser].accessToken,
    @"payout_method": attributeDictionary
  };
  [self setRequestWithString: string method: @"PATCH" parameters: params];

  return self;
}

#pragma mark - Protocol

#pragma mark - Protocol NSURLConnectionDataDelegate

- (void) connectionDidFinishLoading: (NSURLConnection *) connection
{
  // NSLog(@"OMBPayoutMethodUpdateConnection\n%@", [self json]);

  [payoutMethod readFromDictionary: [self objectDictionary]];

  [super connectionDidFinishLoading: connection];
}

@end
