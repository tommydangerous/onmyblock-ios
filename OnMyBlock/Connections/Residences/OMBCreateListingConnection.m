//
//  OMBCreateListingConnection.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 1/7/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBCreateListingConnection.h"

#import "OMBTemporaryResidence.h"

@implementation OMBCreateListingConnection

#pragma mark - Initializer

- (id) initWithDictionary: (NSDictionary *) dictionary
{
  if (!(self = [super init])) return nil;

  NSString *string = [NSString stringWithFormat: 
    @"%@/temporary_residences/create_listing", OnMyBlockAPIURL];
  NSArray *words = [[dictionary objectForKey: 
    @"city"] componentsSeparatedByString: @","];
  NSString *city = @"";
  NSString *state = @"";
  if ([words count] > 0) {
    city = [words objectAtIndex: 0];
  }
  if ([words count] > 1) {
    state = [words objectAtIndex: 1];
  }
  NSDictionary *objectParams = @{
    @"city": city,
    @"lease_months":  [dictionary objectForKey: @"leaseMonths"],
    @"min_bathrooms": [dictionary objectForKey: @"bathrooms"],
    @"min_bedrooms":  [dictionary objectForKey: @"bedrooms"],
    @"property_type": [dictionary objectForKey: @"propertyType"],
    @"state": state,
  };
  NSDictionary *params = @{
    @"access_token":        [OMBUser currentUser].accessToken,
    @"temporary_residence": objectParams
  };
  [self setPostRequestWithString: string withParameters: params];

  return self;
}

#pragma mark - Protocol

#pragma mark - Protocol NSURLConnectionDataDelegate

- (void) connectionDidFinishLoading: (NSURLConnection *) connection
{
  NSDictionary *json = [NSJSONSerialization JSONObjectWithData: container
    options: 0 error: nil];
  if ([[json objectForKey: @"success"] intValue] == 1) {
    OMBTemporaryResidence *temporaryResidence = 
      [[OMBTemporaryResidence alloc] init];
    [temporaryResidence readFromResidenceDictionary: 
      [json objectForKey: @"object"]];
    [[OMBUser currentUser] addResidence: temporaryResidence];
  }
  [super connectionDidFinishLoading: connection];
}

@end
