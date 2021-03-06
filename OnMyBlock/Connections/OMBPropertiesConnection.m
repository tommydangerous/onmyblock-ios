//
//  OMBPropertiesConnection.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 10/18/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBPropertiesConnection.h"
#import "OMBResidenceStore.h"

@implementation OMBPropertiesConnection

#pragma mark - Initializer

- (id) initWithParameters: (NSDictionary *) parameters
{
  self = [super init];
  if (self) {
    // http://localhost:3000/properties.json?
    NSString *string = [NSString stringWithFormat:
      @"%@/places/?", OnMyBlockAPIURL];
    // Add parameters to the end of string
    // e.g. bounds=[-117.0459,32.836,-117.2931,32.7687]
    for (NSString *key in [parameters allKeys]) {
      NSString *param = [NSString stringWithFormat:
        @"%@=%@&", key, [parameters objectForKey: key]];
      string = [string stringByAppendingString: param];
    }
    [self setRequestWithString: string];
  }
  return self;
}

#pragma mark - Protocol

#pragma mark - Protocol NSURLConnectionDataDelegate

- (void) connectionDidFinishLoading: (NSURLConnection *) connection
{
  NSDictionary *json = [NSJSONSerialization JSONObjectWithData: container
    options: 0 error: nil];
  [[OMBResidenceStore sharedStore] readFromDictionary: json];
  [super connectionDidFinishLoading: connection];
}

@end
