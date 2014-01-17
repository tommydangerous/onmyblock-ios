//
//  OMBMessageDetailConnection.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 1/16/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBMessageDetailConnection.h"

#import "OMBMessageDetailViewController.h"

@implementation OMBMessageDetailConnection

#pragma mark - Initializer

- (id) initWithPage: (NSInteger) page withUser: (OMBUser *) user
{
  if (!(self = [super init])) return nil;

  NSString *string = [NSString stringWithFormat: 
    @"%@/messages/with_user/?"
    @"user_id=%i&"
    @"page=%i&"
    @"access_token=%@", 
    OnMyBlockAPIURL, 
    user.uid,
    page, 
    [OMBUser currentUser].accessToken];
  [self setRequestFromString: string];

  return self;
}

#pragma mark - Protocol

#pragma mark - Protocol NSURLConnectionDataDelegate

- (void) connectionDidFinishLoading: (NSURLConnection *) connection
{
  NSDictionary *json = [NSJSONSerialization JSONObjectWithData: container
    options: 0 error: nil];

  NSLog(@"OMBMessageDetailConnection\n%@", json);

  if (self.delegate && 
    [self.delegate isKindOfClass: [OMBMessageDetailViewController class]]) {

    OMBMessageDetailViewController *vc = 
      (OMBMessageDetailViewController *) self.delegate;
    vc.maxPages = [[json objectForKey: @"pages"] intValue];
  }

  [[OMBUser currentUser] readFromMessagesDictionary: json];

  [super connectionDidFinishLoading: connection];
}

@end
