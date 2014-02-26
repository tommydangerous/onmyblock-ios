//
//  OMBConversationDetailConnection.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 2/25/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBConversationDetailConnection.h"

@implementation OMBConversationDetailConnection

#pragma mark - Initializer

- (id) initWithConversationUID: (NSUInteger) uid page: (NSUInteger) page
{
  if (!(self = [super init])) return nil;

  NSString *string = [NSString stringWithFormat: @"%@/conversations/%i",
    OnMyBlockAPIURL, uid];
  NSDictionary *params = @{
    @"access_token": [OMBUser currentUser].accessToken,
    @"page": [NSNumber numberWithInt: page]
  };
  [self setRequestWithString: string parameters: params];

  return self;
}

#pragma mark - Protocol

#pragma mark - Protocol NSURLConnectionDataDelegate

- (void) connectionDidFinishLoading: (NSURLConnection *) connection
{
  if ([self.delegate respondsToSelector: @selector(numberOfPages:)]) {
    [self.delegate numberOfPages: [self numberOfPages]];
  }
  if ([self.delegate respondsToSelector: @selector(JSONDictionary:)]) {
    [self.delegate JSONDictionary: [self json]];
  }
  [super connectionDidFinishLoading: connection];
}

@end
