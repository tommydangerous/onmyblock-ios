//
//  OMBSentApplicationRequirementsConnection.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 6/25/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBSentApplicationRequirementsConnection.h"

@implementation OMBSentApplicationRequirementsConnection

#pragma mark - Initializer

- (id) initWithUserUID: (NSUInteger) userUID
{
  if (!(self = [super init])) return nil;

  NSString *string = [NSString stringWithFormat: 
    @"%@/sent_applications/requirements", OnMyBlockAPIURL];
  [self setRequestWithString: string parameters: @{
    @"access_token": [OMBUser currentUser].accessToken,
    @"user_id":      @(userUID)
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
