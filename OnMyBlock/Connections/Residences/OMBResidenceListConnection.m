//
//  OMBResidenceListConnection.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 1/16/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBResidenceListConnection.h"

#import "OMBResidence.h"
#import "OMBResidenceListStore.h"

@implementation OMBResidenceListConnection

#pragma mark - Initializer

- (id) initWithParameters: (NSDictionary *) dictionary
{
  // This is used for fetching residences from the list view
  if (!(self = [super init])) return nil;

  NSString *string = [NSString stringWithFormat: @"%@/places/grid/?",
    OnMyBlockAPIURL];
  for (NSString *key in [dictionary allKeys]) {
    NSString *param = [NSString stringWithFormat:
      @"%@=%@&", key, [dictionary objectForKey: key]];
    string = [string stringByAppendingString: param];
  }
  // NSLog(@"%@", string);
  [self setRequestWithString: string];

  return self;
}

- (id) initWithParametersForMap: (NSDictionary *) dictionary
{
  // This is used for fetching residences from the map view
  if (!(self = [super init])) return nil;

  NSString *string = [NSString stringWithFormat: @"%@/places/?",
    OnMyBlockAPIURL];
  for (NSString *key in [dictionary allKeys]) {
    NSString *param = [NSString stringWithFormat:
      @"%@=%@&", key, [dictionary objectForKey: key]];
    string = [string stringByAppendingString: param];
  }
  [self setRequestWithString: string];

  return self;
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) start
{
  [self startWithTimeoutInterval: 15 onMainRunLoop: NO];
}

#pragma mark - Protocol

#pragma mark - Protocol NSURLConnectionDataDelegate

- (void) connectionDidFinishLoading: (NSURLConnection *) connection
{
  // Add the residences to the list store for the map's list view
  // [[OMBResidenceListStore sharedStore] readFromDictionary: [self json]];

  if ([self.delegate respondsToSelector: @selector(JSONDictionary:)]) {
    [self.delegate JSONDictionary: [self json]];
  }

  [super connectionDidFinishLoading: connection];
}

@end
