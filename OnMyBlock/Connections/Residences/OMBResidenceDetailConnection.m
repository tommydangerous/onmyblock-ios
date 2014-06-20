//
//  OMBResidenceDetailConnection.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 10/29/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBResidenceDetailConnection.h"

#import "OMBResidence.h"
#import "OMBTemporaryResidence.h"

@implementation OMBResidenceDetailConnection

#pragma mark - Initializer

- (id) initWithResidence: (OMBResidence *) object
{
  if (!(self = [super init])) return nil;

  residence = object;

  NSString *resource = @"places";
  if ([object isKindOfClass: [OMBTemporaryResidence class]])
    resource = @"temporary_residences";

  NSString *string = [NSString stringWithFormat:
    @"%@/%@/%i", OnMyBlockAPIURL, resource, residence.uid];

  if ([[OMBUser currentUser] loggedIn]) {
    string = [string stringByAppendingString:
      [NSString stringWithFormat: @"/?access_token=%@",
        [OMBUser currentUser].accessToken]];
  }

  [self setRequestWithString: string];

  return self;
}

#pragma mark - Protocol

#pragma mark - Protocol NSURLConnectionDataDelegate

- (void) connectionDidFinishLoading: (NSURLConnection *) connection
{
  [residence readFromResidenceDictionary: [self json]];
  [super connectionDidFinishLoading: connection];
}

@end
