//
//  OMBUserFacebookAuthenticationConnection.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 10/31/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBUserFacebookAuthenticationConnection.h"

@implementation OMBUserFacebookAuthenticationConnection

#pragma mark - Initializer

- (id) initWithUser: (OMBUser *) object
{
  if (!(self = [super init])) return nil;

  user = object;

  NSString *string = [NSString stringWithFormat: 
    @"%@/auth/facebook/", OnMyBlockAPIURL];
  NSDictionary *params = @{
    @"email":                 user.email,
    @"facebook_access_token": user.facebookAccessToken,
    @"facebook_id":           user.facebookId,
    @"first_name":            user.firstName,
    @"last_name":             user.lastName
  };
  [self setRequestWithString: string method: @"POST" parameters: params];

  return self;
}

#pragma mark - Override

#pragma mark - Override OMBConnection

- (void) start
{
  [self startWithTimeoutInterval: 0 onMainRunLoop: YES];
}

#pragma mark - Protocol

#pragma mark - Protocol NSURLConnectionDataDelegate

- (void) connectionDidFinishLoading: (NSURLConnection *) connection
{
  if ([self successful]) {
    [[OMBUser currentUser] readFromDictionary: [self objectDictionary]];
  }
  else{

  }

  [super connectionDidFinishLoading: connection];
}

@end
