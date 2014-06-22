//
//  OMBUserListingsConnection.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 2/3/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBUserListingsConnection.h"

@implementation OMBUserListingsConnection

#pragma mark - Initializer

- (id) initWithUser: (OMBUser *) object
{
  if (!(self = [super init])) return nil;

  user = object;

  NSString *string = [NSString stringWithFormat: 
    @"%@/users/%i/listings/?access_token=%@", 
      OnMyBlockAPIURL, user.uid, [self accessToken]];
  [self setRequestWithString: string];

  return self;
}

#pragma mark - Protocol

#pragma mark - Protocol NSURLConnectionDataDelegate

- (void) connectionDidFinishLoading: (NSURLConnection *) connection
{
  // NSLog(@"OMBUserListingsConnection\n%@", [self json]);

  [user readFromResidencesDictionary: [self json]];

  [super connectionDidFinishLoading: connection];
}

@end
