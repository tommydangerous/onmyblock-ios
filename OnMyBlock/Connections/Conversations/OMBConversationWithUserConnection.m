//
//  OMBConversationWithUserConnection.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 2/25/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBConversationWithUserConnection.h"

@implementation OMBConversationWithUserConnection

#pragma mark - Initializer

- (id) initWithUserUID: (NSUInteger) uid
{
  if (!(self = [super init])) return nil;

  NSString *string = [NSString stringWithFormat:
    @"%@/conversations/conversation_with_user", OnMyBlockAPIURL];
  NSDictionary *params = @{
    @"access_token": [OMBUser currentUser].accessToken,
    @"user_id":      [NSNumber numberWithInt: uid]
  };
  [self setRequestWithString: string parameters: params];

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
