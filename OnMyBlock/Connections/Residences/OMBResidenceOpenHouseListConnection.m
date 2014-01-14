//
//  OMBResidenceOpenHouseListConnection.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 1/13/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBResidenceOpenHouseListConnection.h"

#import "OMBResidence.h"
#import "OMBTemporaryResidence.h"

@implementation OMBResidenceOpenHouseListConnection

#pragma mark - Initializer

- (id) initWithResidence: (OMBResidence *) object
{
  if (!(self = [super init])) return nil;

  residence = object;

  NSString *resource = @"places";
  if ([object isKindOfClass: [OMBTemporaryResidence class]])
    resource = @"temporary_residences";

  NSString *string = [NSString stringWithFormat: 
    @"%@/%@/%i/open_houses/?access_token=%@",
      OnMyBlockAPIURL, resource, residence.uid, 
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

  NSLog(@"OMBResidenceOpenHouseListConnection\n%@", json);

  [residence readFromOpenHouseDictionary: json];

  [super connectionDidFinishLoading: connection];
}

@end
