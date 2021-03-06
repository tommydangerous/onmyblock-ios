//
//  OMBMessagesLastFetchedWithUserConnection.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 2/13/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBMessagesLastFetchedWithUserConnection.h"

#import "NSDateFormatter+JSON.h"

@implementation OMBMessagesLastFetchedWithUserConnection

#pragma mark - Initializer

- (id) initWithConversationUID: (NSUInteger) uid 
lastFetched: (NSTimeInterval) lastFetched
{
  if (!(self = [super init])) return nil;

  NSString *string = [NSString stringWithFormat: 
    @"%@/conversations/%i/last_fetched", OnMyBlockAPIURL, uid];
  NSDictionary *params = @{
    @"access_token": [OMBUser currentUser].accessToken,
    @"last_fetched": [[NSDateFormatter JSONDateParser] stringFromDate:
      [NSDate dateWithTimeIntervalSince1970: lastFetched]]
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
