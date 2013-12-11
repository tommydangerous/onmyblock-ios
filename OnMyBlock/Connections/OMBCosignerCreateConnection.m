//
//  OMBCosignerCreateConnection.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/5/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBCosignerCreateConnection.h"

#import "OMBCosigner.h"

@implementation OMBCosignerCreateConnection

#pragma mark - Initializer

- (id) initWithCosigner: (OMBCosigner *) object
{
  if (!(self = [super init])) return nil;

  cosigner = object;

  NSString *string = [NSString stringWithFormat: @"%@/cosigners",
    OnMyBlockAPIURL];
  NSURL *url = [NSURL URLWithString: string];
  NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL: url];
  NSDictionary *objectParams = @{
    @"email":      cosigner.email,
    @"first_name": cosigner.firstName,
    @"last_name":  cosigner.lastName,
    @"phone":      cosigner.phone
  };
  NSDictionary *params = @{
    @"access_token": [OMBUser currentUser].accessToken,
    @"cosigner":     objectParams
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
    NSDictionary *dict = [json objectForKey: @"object"];
    cosigner.uid = [[dict objectForKey: @"id"] intValue];
  }
  [super connectionDidFinishLoading: connection];
}

@end
