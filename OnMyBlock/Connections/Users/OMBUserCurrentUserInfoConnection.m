//
//  OMBUserCurrentUserInfoConnection.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 1/27/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBUserCurrentUserInfoConnection.h"

@implementation OMBUserCurrentUserInfoConnection

#pragma mark - Initializer

- (id) init
{
  if (!(self = [super init])) return nil;

  NSString *string = [NSString stringWithFormat:
    @"%@/users/current_user_info/?access_token=%@",
      OnMyBlockAPIURL, [OMBUser currentUser].accessToken];
  [self setRequestWithString: string];

  return self;
}

#pragma mark - Protocol

#pragma mark - Protocol NSURLConnectionDataDelegate

- (void) connectionDidFinishLoading: (NSURLConnection *) connection
{
  // NSLog(@"OMBUserCurrentUserInfoConnection\n%@", [self json]);

  [[OMBUser currentUser] readFromDictionary: [self objectDictionary]];

  [super connectionDidFinishLoading: connection];
}


@end
