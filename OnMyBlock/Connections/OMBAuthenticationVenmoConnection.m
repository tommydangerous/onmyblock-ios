//
//  OMBAuthenticationVenmoConnection.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/18/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBAuthenticationVenmoConnection.h"

@implementation OMBAuthenticationVenmoConnection

#pragma mark - Initializer

- (id) initWithCode: (NSString *) code
{
  if (!(self = [super init])) return nil;

  NSString *string = [NSString stringWithFormat: @"%@/authentications/venmo",
    OnMyBlockAPIURL];
  NSURL *url = [NSURL URLWithString: string];
  NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL: url];
  NSDictionary *params = @{
    @"access_token": [OMBUser currentUser].accessToken,
    @"code":         code
  };
  NSData *json = [NSJSONSerialization dataWithJSONObject: params
    options: 0 error: nil];
  [req addValue: @"application/json" forHTTPHeaderField: @"Content-Type"];
  [req setHTTPBody: json];
  [req setHTTPMethod: @"POST"];
  self.request = req;

  return self;
}

#pragma mark - Protocol

#pragma mark - Protocol NSURLConnectionDataDelegate

- (void) connectionDidFinishLoading: (NSURLConnection *) connection
{
  NSDictionary *json = [NSJSONSerialization JSONObjectWithData: container
    options: 0 error: nil];
  if ([[json objectForKey: @"success"] intValue] == 1) {
    NSLog(@"SUCCESS");
  }
  [super connectionDidFinishLoading: connection];
}

@end
