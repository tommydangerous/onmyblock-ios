//
//  OMBResidenceOffersConnection.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 1/14/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBResidenceOffersConnection.h"

#import "OMBResidence.h"

@implementation OMBResidenceOffersConnection

#pragma mark - Initializer

- (id) initWithResidence: (OMBResidence *) object
{
  if (!(self = [super init])) return nil;

  residence = object;

  NSString *string = [NSString stringWithFormat: 
    @"%@/places/%i/offers/?access_token=%@", 
      OnMyBlockAPIURL, residence.uid, [OMBUser currentUser].accessToken];
  [self setRequestFromString: string];

  return self;
}

#pragma mark - Protocol

#pragma mark - Protocol NSURLConnectionDataDelegate

- (void) connectionDidFinishLoading: (NSURLConnection *) connection
{
  NSDictionary *json = [NSJSONSerialization JSONObjectWithData: container
    options: 0 error: nil];

  NSLog(@"OMBResidenceOffersConnection\n%@", json);

  [residence readFromOffersDictionary: json];

  [super connectionDidFinishLoading: connection];
}

@end
