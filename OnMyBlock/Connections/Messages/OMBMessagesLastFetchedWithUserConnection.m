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

- (id) initWithLastFetched: (NSTimeInterval) lastFetched 
otherUser: (OMBUser *) otherUser
{
  if (!(self = [super init])) return nil;

  NSString *string = [NSString stringWithFormat: 
    @"%@/messages/last_fetched_with_user", OnMyBlockAPIURL];
  [self setRequestWithString: string parameters: @{
    @"access_token": [OMBUser currentUser].accessToken,
    @"last_fetched": [[NSDateFormatter JSONDateParser] stringFromDate:
      [NSDate dateWithTimeIntervalSince1970: lastFetched]],
    @"user_id": [NSString stringWithFormat: @"%i", otherUser.uid]
  }];

  return self;
}

#pragma mark - Protocol

#pragma mark - Protocol NSURLConnectionDataDelegate

- (void) connectionDidFinishLoading: (NSURLConnection *) connection
{
  [[OMBUser currentUser] readFromMessagesDictionary: [self json]];
  [super connectionDidFinishLoading: connection];
}

@end
