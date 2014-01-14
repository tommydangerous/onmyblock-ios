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

#pragma mark - Protocol

#pragma mark - Protocol NSURLConnectionDataDelegate

- (void) connectionDidFinishLoading: (NSURLConnection *) connection
{
  NSDictionary *json = [NSJSONSerialization JSONObjectWithData: container
    options: 0 error: nil];

  NSLog(@"OMBResidencePublishConnection\n%@", json);

  if ([[json objectForKey: @"success"] intValue]) {
    // Copy the temporary residence
    if ([residence isKindOfClass: [OMBTemporaryResidence class]]) {
      // OMBResidence *res = (OMBResidence *) residence;
      [[OMBUser currentUser] removeResidence: residence];
      // [[OMBUser currentUser] addResidence: res];
      // [[OMBUser currentUser].residences removeAllObjects];
    }
    // Remove the temporary residence from the user's residence

    // Add the new residence to the user's residence
  }

  [super connectionDidFinishLoading: connection];
}

@end
