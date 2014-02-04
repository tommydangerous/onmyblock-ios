//
//  OMBAuthenticationLinkedInConnection.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 1/29/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBAuthenticationLinkedInConnection.h"

@implementation OMBAuthenticationLinkedInConnection

#pragma mark - Initializer

- (id) initWithLinkedInAccessToken: (NSString *) accessToken
{
  if (!(self = [super init])) return nil;

  NSString *string = [NSString stringWithFormat: @"%@/authentications/linkedin",
    OnMyBlockAPIURL];
  NSDictionary *params = @{
    @"access_token": [OMBUser currentUser].accessToken,
    @"linkedin_access_token": accessToken
  };
  [self setRequestWithString: string method: @"POST" parameters: params];

  return self;
}

#pragma mark - Protocol

#pragma mark - Protocol NSURLConnectionDataDelegate

- (void) connectionDidFinishLoading: (NSURLConnection *) connection
{
  NSLog(@"OMBAuthenticationLinkedInConnection\n%@", [self json]);

  if ([self successful]) {

  }
  else {
    [self createInternalErrorWithDomain: OMBConnectionErrorDomainAuthentication
      code: OMBConnectionErrorDomainAuthenticationCodeLinkedInFailed];
  }

  [super connectionDidFinishLoading: connection];
}

@end
