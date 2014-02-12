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
  if (!(self = [super init])) return nil;

  NSString *string = [NSString stringWithFormat: @"%@/places/?",
    OnMyBlockAPIURL];

  for (NSString *key in [dictionary allKeys]) {
    NSString *param = [NSString stringWithFormat:
      @"%@=%@&", key, [dictionary objectForKey: key]];
    string = [string stringByAppendingString: param];
  }
  NSLog(@"%@", string);
  [self setRequestWithString: string];

  return self;
}

#pragma mark - Protocol

#pragma mark - Protocol NSURLConnectionDataDelegate

- (void) connectionDidFinishLoading: (NSURLConnection *) connection
{
  NSDictionary *json = [NSJSONSerialization JSONObjectWithData: container
    options: 0 error: nil];

  // NSLog(@"OMBResidenceListConnection\n%@", json);

  [[OMBResidenceListStore sharedStore] readFromDictionary: json];

  [super connectionDidFinishLoading: connection];
}

@end
