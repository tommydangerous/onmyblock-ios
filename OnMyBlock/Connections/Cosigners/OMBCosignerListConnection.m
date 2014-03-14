//
//  OMBCosignerListConnection.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/5/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBCosignerListConnection.h"

@implementation OMBCosignerListConnection

#pragma mark - Initializer

- (id) initWithUserUID: (NSUInteger) userUID
{
  if (!(self = [super init])) return self;

  NSString *string = [NSString stringWithFormat: @"%@/cosigners",
    OnMyBlockAPIURL];
  [self setRequestWithString: string parameters: @{
    @"access_token": [OMBUser currentUser].accessToken,
    @"user_id": [NSNumber numberWithInt: userUID]
  }];

  return self;
}

#pragma mark - Protocol

#pragma mark - Protocol NSURLConnectionDataDelegate

- (void) connectionDidFinishLoading: (NSURLConnection *) connection
{
  if ([self.delegate respondsToSelector: @selector(JSONDictionary:)]) {
    [self.delegate JSONDictionary: [self json]];
  }

  [super connectionDidFinishLoading: connection];
}

@end
