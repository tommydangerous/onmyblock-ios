//
//  OMBUserProfileConnection.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 2/3/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBUserProfileConnection.h"

#import "OMBRenterApplication.h"

@implementation OMBUserProfileConnection

#pragma mark - Initializer

- (id) initWithUser: (OMBUser *) object
{
  if (!(self = [super init])) return nil;

  user = object;

  NSString *string = [NSString stringWithFormat: 
    @"%@/users/%i/?access_token=%@", 
      OnMyBlockAPIURL, user.uid, [self accessToken]];
  [self setRequestWithString: string];

  return self;
}

#pragma mark - Protocol

#pragma mark - Protocol NSURLConnectionDataDelegate

- (void) connectionDidFinishLoading: (NSURLConnection *) connection
{
  NSDictionary *dict = [[self json] objectForKey: @"renter_application"];
  [user.renterApplication readFromDictionary: dict];

  [super connectionDidFinishLoading: connection];
}

@end
