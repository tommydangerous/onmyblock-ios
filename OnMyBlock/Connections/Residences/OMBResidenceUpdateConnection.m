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

  residence = object;

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
    // Auction Duration
    if ([key isEqualToString: @"auctionDuration"])
      key = @"auction_duration";
    // Auction Start Date
    if ([key isEqualToString: @"auctionStartDate"]) {
      key = @"auction_start_date";
      if (object.auctionStartDate)
        value = [dateFormatter stringFromDate: 
          [NSDate dateWithTimeIntervalSince1970: object.auctionStartDate]];
      else
        value = @"";
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
    // Deposit
    if ([key isEqualToString: @"deposit"]) {
      if (object.deposit) {
        value = [NSNumber numberWithFloat: object.deposit];
      }
      else {
        value = [NSNumber numberWithFloat: 0.0f];
      }
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
    // Is Auction
    if ([key isEqualToString: @"isAuction"]) {
      key = @"is_auction";
      if (object.isAuction)
        value = @"true";
      else
        value = @"false";
    }
    // Lease Months
    if ([key isEqualToString: @"leaseMonths"])
      key = @"lease_months";
    // Lease Type
    if ([key isEqualToString: @"leaseType"])
      key = @"lease_type";
    // Min Rent
    if ([key isEqualToString: @"minRent"])
      key = @"min_rent";
    // Move-in Date
    if ([key isEqualToString: @"moveInDate"]) {
      key = @"move_in_date";
      if (object.moveInDate)
        value = [dateFormatter stringFromDate: 
          [NSDate dateWithTimeIntervalSince1970: object.moveInDate]];
      else
        value = @"";
    }
    // Move-out Date
    if ([key isEqualToString: @"moveOutDate"]) {
      key = @"move_out_date";
      if (object.moveOutDate)
        value = [dateFormatter stringFromDate: 
          [NSDate dateWithTimeIntervalSince1970: object.moveOutDate]];
      else
        value = @"";
    }
    // Property Type
    if ([key isEqualToString: @"propertyType"])
      key = @"property_type";
    // Rent it Now Price
    if ([key isEqualToString: @"rentItNowPrice"])
      key = @"rent_it_now_price";
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

  NSDictionary *objectDict = [json objectForKey: @"object"];
  NSInteger inactive = [[objectDict objectForKey: @"inactive"] intValue];
  if (inactive == 0)
    residence.inactive = NO;
  else
    residence.inactive = YES;

  [super connectionDidFinishLoading: connection];
}

@end
