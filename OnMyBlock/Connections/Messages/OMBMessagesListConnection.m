//
//  OMBMessagesListConnection.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 1/15/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBMessagesListConnection.h"

#import "OMBInboxViewController.h"
#import "OMBConversationMessageStore.h"

@implementation OMBMessagesListConnection

#pragma mark - Initializer

- (id) initWithPage: (NSUInteger) page
{
  if (!(self = [super init])) return nil;

  NSString *string = [NSString stringWithFormat: 
    @"%@/messages/", OnMyBlockAPIURL];
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
