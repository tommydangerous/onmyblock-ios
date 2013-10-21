//
//  OMBPropertiesConnection.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 10/18/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBPropertiesConnection.h"
#import "OMBPropertiesStore.h"

@implementation OMBPropertiesConnection

#pragma mark - Initializer

- (id) initWithParameters: (NSDictionary *) parameters
{
  self = [super init];
  if (self) {
    NSString *string = [NSString stringWithFormat:
      @"%@/properties.json/?", OnMyBlockAPIURL];
    for (NSString *key in [parameters allKeys]) {
      NSString *param = [NSString stringWithFormat:
        @"%@=%@&", key, [parameters objectForKey: key]];
      string = [string stringByAppendingString: param];
    }
    [self setRequestFromString: string];
  }
  return self;
}

#pragma mark - Protocol

#pragma mark Protocol NSURLConnectionDataDelegate

- (void) connectionDidFinishLoading: (NSURLConnection *) connection
{
  NSDictionary *json = [NSJSONSerialization JSONObjectWithData: container
    options: 0 error: nil];
  // Returns an array of hashes
  [[OMBPropertiesStore sharedStore] readFromDictionary: json];
  [super connectionDidFinishLoading: connection];
}

@end
