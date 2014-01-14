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

  if ([object isKindOfClass: [OMBTemporaryResidence class]])
    string = [string stringByAppendingString: 
      [NSString stringWithFormat: @"/?access_token=%@", 
        [OMBUser currentUser].accessToken]];

  [self setRequestFromString: string];

  return self;
}

#pragma mark - Protocol

#pragma mark - Protocol NSURLConnectionDataDelegate

- (void) connectionDidFinishLoading: (NSURLConnection *) connection
{
  // Sample JSON
  // {
  //   address: "3915 Broadlawn Street ",
  //   available_on: "2013-11-14 00:00:00 +0000",
  //   bathrooms: "2.0",
  //   bedrooms: "4.0",
  //   city: "San Diego",
  //   created_at: "2013-10-11 17:34:06 -0700",
  //   description: "Address of Available Listing",
  //   email: null,
  //   id: 3415,
  //   landlord_name: null,
  //   latitude: 32.815313,
  //   lease_months: null,
  //   longitude: -117.168185,
  //   phone: "(858) 695-9400",
  //   rent: 2505,
  //   sqft: 1466,
  //   state: "CA",
  //   updated_at: "2013-10-11 17:34:06 -0700",
  //   zip: "92111"
  // }
  NSDictionary *json = [NSJSONSerialization JSONObjectWithData: container
    options: 0 error: nil];

  NSLog(@"OMBResidenceDetailConnection\n%@", json);
  
  [residence readFromResidenceDictionary: json];
  [super connectionDidFinishLoading: connection];
}

@end
