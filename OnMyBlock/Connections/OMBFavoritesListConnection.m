//
//  OMBFavoritesListConnection.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 10/31/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBFavoritesListConnection.h"

#import "OMBUser.h"

@implementation OMBFavoritesListConnection

#pragma mark - Initializer

- (id) init
{
  if (!(self = [super init])) return nil;

  NSString *string = [NSString stringWithFormat: 
    @"%@/favorites?access_token=%@", 
      OnMyBlockAPIURL, [OMBUser currentUser].accessToken];
  [self setRequestFromString: string];

  return self;
}

#pragma mark - Protocol

#pragma mark - Protocol NSURLConnectionDataDelegate

- (void) connectionDidFinishLoading: (NSURLConnection *) connection
{
  NSDictionary *json = [NSJSONSerialization JSONObjectWithData: container
    options: 0 error: nil];
  [[OMBUser currentUser] readFromResidencesDictionary: json];
  [super connectionDidFinishLoading: connection];
}

@end
