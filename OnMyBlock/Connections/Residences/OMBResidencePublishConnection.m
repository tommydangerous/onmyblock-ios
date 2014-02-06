//
//  OMBResidencePublishConnection.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 1/13/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBResidencePublishConnection.h"

#import "OMBResidence.h"
#import "OMBTemporaryResidence.h"

@implementation OMBResidencePublishConnection

#pragma mark - Initializer

- (id) initWithResidence: (OMBResidence *) object
{
  if (!(self = [super init])) return nil;

  residence = object;

  NSString *resource = @"places";
  if ([object isKindOfClass: [OMBTemporaryResidence class]])
    resource = @"temporary_residences";

  NSString *string = [NSString stringWithFormat: @"%@/%@/%i/publish", 
    OnMyBlockAPIURL, resource, residence.uid];
  NSDictionary *params = @{
    @"access_token": [OMBUser currentUser].accessToken
  };
  [self setRequestWithString: string method: @"POST" parameters: params];

  return self;
}

- (id) initWithResidence: (OMBResidence *) object
newResidence: (OMBResidence *) object2
{
  newResidence = object2;
  return [self initWithResidence: object];
}

#pragma mark - Protocol

#pragma mark - Protocol NSURLConnectionDataDelegate

- (void) connectionDidFinishLoading: (NSURLConnection *) connection
{
  // NSLog(@"OMBResidencePublishConnection\n%@", [self json]);

  if ([self successful]) {
    // Copy the temporary residence
    if ([residence isKindOfClass: [OMBTemporaryResidence class]]) {
      [[OMBUser currentUser] removeResidence: residence];

      [newResidence readFromResidenceDictionary: [self objectDictionary]];
      [[OMBUser currentUser] addResidence: newResidence];
    }
    else {
      residence.inactive = NO;
    }
  }

  [super connectionDidFinishLoading: connection];
}

@end
