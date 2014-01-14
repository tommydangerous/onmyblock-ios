//
//  OMBResidenceDeleteConnection.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 1/13/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBResidenceDeleteConnection.h"

#import "OMBResidence.h"
#import "OMBTemporaryResidence.h"

@implementation OMBResidenceDeleteConnection

#pragma mark - Initializer

- (id) initWithResidence: (OMBResidence *) object
{
  if (!(self = [super init])) return nil;

  residence = object;

  NSString *resource = @"places";
  if ([object isKindOfClass: [OMBTemporaryResidence class]])
    resource = @"temporary_residences";

  NSString *string = [NSString stringWithFormat: @"%@/%@/%i/delete_listing",
    OnMyBlockAPIURL, resource, residence.uid];
  NSDictionary *params = @{
    @"access_token": [OMBUser currentUser].accessToken
  };
  [self setRequestWithString: string method: @"POST" parameters: params];

  return self;
}

#pragma mark - Protocol

#pragma mark - Protocol NSURLConnectionDataDelegate

- (void) connectionDidFinishLoading: (NSURLConnection *) connection
{
  NSDictionary *json = [NSJSONSerialization JSONObjectWithData: container
    options: 0 error: nil];

  NSLog(@"OMBResidenceDeleteConnection\n%@", json);

  if ([[json objectForKey: @"success"] intValue] == 1) {
    [[OMBUser currentUser] removeResidence: residence];
  }

  [super connectionDidFinishLoading: connection];
}

@end
