//
//  OMBRenterApplicationUpdateConnection.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/6/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBRenterApplicationUpdateConnection.h"

#import "OMBRenterApplication.h"

@implementation OMBRenterApplicationUpdateConnection

- (id) init
{
  if (!(self = [super init])) return nil;

  NSString *string = [NSString stringWithFormat: 
    @"%@/renter-applications/update-renter-application", OnMyBlockAPIURL];
  NSURL *url = [NSURL URLWithString: string];
  NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL: url];
  NSString *cats = [NSString stringWithFormat: @"%i",
    [[NSNumber numberWithBool: 
      [OMBUser currentUser].renterApplication.cats] intValue]];
  NSString *dogs = [NSString stringWithFormat: @"%i",
    [[NSNumber numberWithBool: 
      [OMBUser currentUser].renterApplication.dogs] intValue]];
  NSDictionary *params = @{
    @"access_token": [OMBUser currentUser].accessToken,
    @"cats":         cats,
    @"dogs":         dogs
  };
  NSData *json = [NSJSONSerialization dataWithJSONObject: params
    options: 0 error: nil];
  [req addValue: @"application/json" forHTTPHeaderField: @"Content-Type"];
  [req setHTTPBody: json];
  [req setHTTPMethod: @"POST"];
  self.request = req;

  return self;
}

@end
