//
//  OMBContactResidenceLandlordConnection.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 10/30/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBContactResidenceLandlordConnection.h"

#import "OMBResidence.h"

@implementation OMBContactResidenceLandlordConnection

#pragma mark - Initializer

- (id) initWithResidence: (OMBResidence *) residence 
message: (NSString *) message
{
  if (!(self = [super init])) return nil;

  NSString *string = [NSString stringWithFormat:
    @"%@/leads/", OnMyBlockAPIURL];
  NSURL *url = [NSURL URLWithString: string];
  NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL: url];
  NSString *params = [NSString stringWithFormat: 
    @"access_token=%@&"
    @"message=%@&"
    @"residence_id=%i",
    [OMBUser currentUser].accessToken,
    message,
    residence.uid
  ];
  [req setHTTPBody: [params dataUsingEncoding: NSUTF8StringEncoding]];
  [req setHTTPMethod: @"POST"];
  self.request = req;

  return self;
}

@end
