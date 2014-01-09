//
//  OMBResidenceImageDeleteConnection.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 1/8/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBResidenceImageDeleteConnection.h"

#import "OMBResidenceImage.h"

@implementation OMBResidenceImageDeleteConnection

#pragma mark - Initializer

- (id) initWithResidenceImage: (OMBResidenceImage *) object
{
  if (!(self = [super init])) return nil;

  NSString *string = [NSString stringWithFormat: @"%@/residence_images/%i",
    OnMyBlockAPIURL, object.uid];
  NSDictionary *params = @{
    @"access_token": [OMBUser currentUser].accessToken
  };
  [self setRequestWithString: string method: @"DELETE" parameters: params];

  return self;
}

#pragma mark - Protocol

#pragma mark - Protocol NSURLConnectionDataDelegate

- (void) connectionDidFinishLoading: (NSURLConnection *) connection
{
  NSDictionary *json = [NSJSONSerialization JSONObjectWithData: container
    options: 0 error: nil];

  NSLog(@"%@\n%@", [OMBResidenceImageDeleteConnection class], json);

  [super connectionDidFinishLoading: connection];
}

@end
