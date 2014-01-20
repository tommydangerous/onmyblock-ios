//
//  OMBGoogleMapsReverseGeocodingConnection.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/16/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBGoogleMapsReverseGeocodingConnection.h"

#import "OMBCreateListingViewController.h"
#import "OMBFinishListingAddressViewController.h"

@implementation OMBGoogleMapsReverseGeocodingConnection

#pragma mark - Initializer

- (id) initWithAddress: (NSString *) address
{
  if (!(self = [super init])) return nil;

  NSString *string = [NSString stringWithFormat: 
    @"http://maps.googleapis.com/maps/api/geocode/json?" 
      @"address=%@&sensor=true", address];

  NSLog(@"STRING: %@", string);
  [self setRequestWithString: string];

  return self;
}

- (id) initWithCoordinate: (CLLocationCoordinate2D) coordinate
{
  if (!(self = [super init])) return nil;

  NSString *string = [NSString stringWithFormat: 
    @"http://maps.googleapis.com/maps/api/geocode/json?" 
      @"latlng=%f,%f&sensor=true", coordinate.latitude, coordinate.longitude];
  [self setRequestWithString: string];

  return self;
}

#pragma mark - Protocol

#pragma mark - Protocol NSURLConnectionDataDelegate

- (void) connectionDidFinishLoading: (NSURLConnection *) connection
{
  NSDictionary *json = [NSJSONSerialization JSONObjectWithData: container
    options: 0 error: nil];

  NSLog(@"OMBGoogleMapsReverseGeocodingConnection\n%@", json);

  NSArray *array = [json objectForKey: @"results"];
  
  if ([array count]) {
    NSString *address = @"";
    NSString *city    = @"";
    NSString *state   = @"";
    NSString *zip     = @"";

    // Address
    NSString *string = [[array objectAtIndex: 0] objectForKey: 
      @"formatted_address"];
    NSArray *words = [string componentsSeparatedByString: @","];
    if ([words count] >= 1) {
      address = [words objectAtIndex: 0];
    }
    if ([words count] >= 2) {
      city = [words objectAtIndex: 1];
    }
    if ([words count] >= 3) {
      NSString *stateZip = [words objectAtIndex: 2];
      // State
      NSRegularExpression *stateRegEx =
        [NSRegularExpression regularExpressionWithPattern: @"([A-Za-z]+)"
          options: 0 error: nil];
      NSArray *stateMatches = [stateRegEx matchesInString: stateZip
        options: 0 range: NSMakeRange(0, [stateZip length])];
      if ([stateMatches count]) {
        NSTextCheckingResult *stateResult = [stateMatches objectAtIndex: 0];
        state = [stateZip substringWithRange: stateResult.range];
      }

      // Zip
      NSRegularExpression *zipRegEx =
        [NSRegularExpression regularExpressionWithPattern: @"([0-9-]+)"
          options: 0 error: nil];
      NSArray *zipMatches = [zipRegEx matchesInString: stateZip
        options: 0 range: NSMakeRange(0, [stateZip length])];
      if ([zipMatches count]) {
        NSTextCheckingResult *zipResult = [zipMatches objectAtIndex: 0];
        zip = [stateZip substringWithRange: zipResult.range];
      }
    }

    // Coordinate
    NSDictionary *geometry = [[array objectAtIndex: 0] objectForKey: 
      @"geometry"];
    if (geometry) {
      NSDictionary *location = [geometry objectForKey: @"location"];
      CGFloat latitude  = [[location objectForKey: @"lat"] floatValue];
      CGFloat longitude = [[location objectForKey: @"lng"] floatValue];
      CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(
        latitude, longitude);
      if ([self.delegate isKindOfClass: 
        [OMBFinishListingAddressViewController class]]) {

        [(OMBFinishListingAddressViewController *)
          self.delegate setMapViewRegion: coordinate withMiles: 10 
            animated: YES];
      }
    }

    if ([self.delegate isKindOfClass: [OMBCreateListingViewController class]]) {
      [(OMBCreateListingViewController *) 
        self.delegate setCityTextFieldTextWithString: 
          [NSString stringWithFormat: @"%@, %@", city, state]];
    }
  }

  // Finish Listing address, create an array of dictionaries
  if ([self.delegate isKindOfClass:
    [OMBFinishListingAddressViewController class]]) {

    NSMutableArray *addressArray = [NSMutableArray array];
    for (NSDictionary *dict in array) {
      NSDictionary *addressDict = @{
        @"formatted_address": [dict objectForKey: @"formatted_address"],
        @"geometry":          [dict objectForKey: @"geometry"]
      };
      [addressArray addObject: addressDict];
    }
    OMBFinishListingAddressViewController *vc =
      (OMBFinishListingAddressViewController *) self.delegate;
    vc.addressArray = (NSArray *) addressArray;
  }
  [super connectionDidFinishLoading: connection];
}

@end
