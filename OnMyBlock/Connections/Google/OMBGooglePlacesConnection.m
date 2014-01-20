//
//  OMBGooglePlacesConnection.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 1/7/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBGooglePlacesConnection.h"

#import "OMBCreateListingViewController.h"

@implementation OMBGooglePlacesConnection

#pragma mark - Initializer

- (id) initWithString: (NSString *) string citiesOnly: (BOOL) citiesOnly
{
  if (!(self = [super init])) return nil;

  NSString *types = @"geocode";
  if (citiesOnly)
    types = @"(cities)";

  NSString *urlString = [NSString stringWithFormat: 
    @"https://maps.googleapis.com/maps/api/place/autocomplete/json?"
    @"components=country:us&"
    @"input=%@&"
    @"sensor=%@&"
    @"types=%@&"
    @"key=%@",
    string, @"true", types, @"AIzaSyA6HO4l5aN8Cpkvp_oe6QbZVuvivvObs7E"];

  [self setRequestWithString: urlString];

  return self;
}

#pragma mark - Protocol

#pragma mark - Protocol NSURLConnectionDataDelegate

- (void) connectionDidFinishLoading: (NSURLConnection *) connection
{
  NSDictionary *json = [NSJSONSerialization JSONObjectWithData: container
    options: 0 error: nil];

  NSLog(@"OMBGooglePlacesConnection\n%@", json);

  NSMutableArray *array = [NSMutableArray array];
  NSArray *predications = [json objectForKey: @"predictions"];
  for (NSDictionary *dict in predications) {
    NSString *description = [dict objectForKey: @"description"];
    if (description && [description length]) {
      [array addObject: description];
    }
  }
  // Create listing
  if ([self.delegate isKindOfClass: [OMBCreateListingViewController class]]) {
    OMBCreateListingViewController *vc = (OMBCreateListingViewController *)
      self.delegate;
    vc.citiesArray = array;
  }

  [super connectionDidFinishLoading: connection];
}

@end
