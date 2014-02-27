//
//  OMBConversationWithResidenceConnection.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 2/26/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBConversationWithResidenceConnection.h"

@implementation OMBConversationWithResidenceConnection

#pragma mark - Initializer

- (id) initWithUID: (NSUInteger) uid
{
  NSString *string = [NSString stringWithFormat: 
    @"%@/conversations/conversation_with_residence", OnMyBlockAPIURL];
  NSDictionary *params = @{
    @"access_token": [OMBUser currentUser].accessToken,
    @"residence_id": [NSNumber numberWithInt: uid]
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
