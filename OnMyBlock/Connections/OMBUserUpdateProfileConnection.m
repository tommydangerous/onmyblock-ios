//
//  OMBUserUpdateProfileConnection.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/3/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBUserUpdateProfileConnection.h"

@implementation OMBUserUpdateProfileConnection

#pragma mark - Initializer

- (id) init
{
  if (!(self = [super init])) return self;

  NSString *string = [NSString stringWithFormat: @"%@/users/update_profile",
    OnMyBlockAPIURL];
  NSURL *url = [NSURL URLWithString: string];
  NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL: url];
  NSDictionary *params = @{
    @"access_token": [OMBUser currentUser].accessToken,

    @"about":      [OMBUser currentUser].about,
    @"email":      [OMBUser currentUser].email,
    @"first_name": [OMBUser currentUser].firstName,
    @"last_name":  [OMBUser currentUser].lastName,
    @"phone":      [OMBUser currentUser].phone,
    @"school":     [OMBUser currentUser].school
  };
  NSData *jsonData = [NSJSONSerialization dataWithJSONObject: params
    options: 0 error: nil];

  [req addValue: @"application/json" forHTTPHeaderField: @"Content-Type"];
  [req setHTTPBody: jsonData];
  [req setHTTPMethod: @"POST"];
  self.request = req;

  return self;
}

@end
