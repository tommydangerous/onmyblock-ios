//
//  OMBResidenceUpdateConnection.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 1/11/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBResidenceUpdateConnection.h"

#import "OMBResidence.h"
#import "OMBTemporaryResidence.h"

@implementation OMBResidenceUpdateConnection

#pragma mark - Initializer

- (id) initWithResidence: (OMBResidence *) object 
attributes: (NSArray *) attributes
{
  if (!(self = [super init])) return nil;

  NSString *resource    = @"places";
  NSString *resourceKey = @"residence";
  if ([object isKindOfClass: [OMBTemporaryResidence class]]) {
    resource    = @"temporary_residences";
    resourceKey = @"temporary_residence";
  }
  NSString *string = [NSString stringWithFormat: @"%@/%@/%i",
    OnMyBlockAPIURL, resource, object.uid];

  NSDateFormatter *dateFormatter = [NSDateFormatter new];
  dateFormatter.dateFormat       = @"yyyy-MM-dd HH:mm:ss ZZZ";

  NSMutableDictionary *attributeDictionary = [NSMutableDictionary dictionary];
  for (NSString *attribute in attributes) {
    NSString *key = attribute;
    id value = [object valueForKey: key];
    // Handle different naming between iOS app and web server
    if ([key isEqualToString: @"amenities"]) {
      NSMutableArray *amenitiesStringArray = [NSMutableArray array];
      for (NSString *amenitiesKey in [object.amenities allKeys]) {
        if ([[object.amenities valueForKey: amenitiesKey] intValue]) {
          [amenitiesStringArray addObject: amenitiesKey];
        }
      }
      value = [amenitiesStringArray componentsJoinedByString: @","];
    }
    // Bathrooms
    if ([key isEqualToString: @"bathrooms"])
      key = @"min_bathrooms";
    // Bedrooms
    if ([key isEqualToString: @"bedrooms"])
      key = @"min_bedrooms";
    // Cats
    if ([key isEqualToString: @"cats"]) {
      if (object.cats)
        value = @"true";
      else
        value = @"false";
    }
    // Description
    if ([key isEqualToString: @"description"])
      key = @"desc";
    // Dogs
    if ([key isEqualToString: @"dogs"]) {
      if (object.dogs)
        value = @"true";
      else
        value = @"false";
    }
    // Lease Months
    if ([key isEqualToString: @"leaseMonths"])
      key = @"lease_months";
    // Move-in Date
    if ([key isEqualToString: @"moveInDate"]) {
      key = @"move_in_date";
      value = [dateFormatter stringFromDate: 
        [NSDate dateWithTimeIntervalSince1970: object.moveInDate]];
    }
    // Property Type
    if ([key isEqualToString: @"propertyType"])
      key = @"property_type";
    // Square Feet
    if ([key isEqualToString: @"squareFeet"])
      key = @"min_sqft";
    [attributeDictionary setObject: value forKey: key];
  }
  
  NSDictionary *params = @{
    @"access_token": [OMBUser currentUser].accessToken,
    resourceKey: attributeDictionary
  };
  [self setRequestWithString: string method: @"PATCH" parameters: params];

  return self;
}

#pragma mark - Protocol

#pragma mark - Protocol NSURLConnectionDataDelegate

- (void) connectionDidFinishLoading: (NSURLConnection *) connection
{
  NSDictionary *json = [NSJSONSerialization JSONObjectWithData: container
    options: 0 error: nil];

  NSLog(@"OMBResidenceUpdateConnection\n%@", json);

  [super connectionDidFinishLoading: connection];
}

@end
