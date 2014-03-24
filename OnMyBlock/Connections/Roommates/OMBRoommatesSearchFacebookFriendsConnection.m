//
//  OMBRoommatesSearchFacebookFriendConnection.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 3/23/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBRoommatesSearchFacebookFriendsConnection.h"

@implementation OMBRoommatesSearchFacebookFriendsConnection

#pragma mark - Initializer

- (id) initWithQuery: (NSString *) query
{
  if (!(self = [super init])) return nil;

  NSString *string = [NSString stringWithFormat: 
    @"%@/roommates/search_facebook_friends", OnMyBlockAPIURL];
  [self setRequestWithString: string parameters: @{
    @"access_token": [OMBUser currentUser].accessToken,
    @"query": query
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
