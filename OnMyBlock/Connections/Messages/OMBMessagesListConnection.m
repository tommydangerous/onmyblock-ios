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

- (id) initWithPage: (NSInteger) page
{
  if (!(self = [super init])) return nil;

  NSString *string = [NSString stringWithFormat:
    @"%@/messages/?page=%i&access_token=%@",
      OnMyBlockAPIURL, page, [OMBUser currentUser].accessToken];
  [self setRequestWithString: string];

  return self;
}

#pragma mark - Protocol

#pragma mark - Protocol NSURLConnectionDataDelegate

- (void) connectionDidFinishLoading: (NSURLConnection *) connection
{
  NSDictionary *json = [NSJSONSerialization JSONObjectWithData: container
    options: 0 error: nil];

  // NSLog(@"OMBMessagesListConnection\n%@", json);

  OMBInboxViewController *vc = (OMBInboxViewController *) self.delegate;
  vc.maxPages = [[json objectForKey: @"pages"] intValue];

  [[OMBConversationMessageStore sharedStore] readFromDictionary: json];

  [super connectionDidFinishLoading: connection];
}

@end
