//
//  OMBPayPalVerifyMobilePaymentConnection.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/12/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBPayPalVerifyMobilePaymentConnection.h"

@implementation OMBPayPalVerifyMobilePaymentConnection

#pragma mark - Initializer

- (id) initWithPaymentConfirmation: (NSDictionary *) dictionary;
{
  if (!(self = [super init])) return nil;

  NSString *string = [NSString stringWithFormat: 
    @"%@/payouts/paypal/charge", OnMyBlockAPIURL];
  NSURL *url = [NSURL URLWithString: string];
  NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL: url];
  NSDictionary *params = @{
    @"access_token": [OMBUser currentUser].accessToken,
    @"confirmation": dictionary
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
  if ([[json objectForKey: @"success"] intValue]) {
    NSLog(@"SUCCESS");
  }
  NSLog(@"%@", json);
  [super connectionDidFinishLoading: connection];
}

@end
