//
//  OMBMovedInConnection.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 2/5/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBMovedInConnection.h"

@implementation OMBMovedInConnection

#pragma mark - Init

- (id) init
{
  if (!(self = [super init])) return nil;

  NSString *string = [NSString stringWithFormat: 
    @"%@/offers/moved_in/?access_token=%@",
      OnMyBlockAPIURL, [OMBUser currentUser].accessToken];
  [self setRequestWithString: string];

  return self;
}

#pragma mark - Protocol

#pragma mark - Protocol NSURLConnectionDataDelegate

- (void) connectionDidFinishLoading: (NSURLConnection *) connection
{
  [[OMBUser currentUser] readFromMovedInDictionary: [self json]];

  [super connectionDidFinishLoading: connection]; 
}


@end
