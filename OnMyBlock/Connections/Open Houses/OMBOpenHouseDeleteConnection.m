//
//  OMBOpenHouseDeleteConnection.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 1/13/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBOpenHouseDeleteConnection.h"

#import "OMBOpenHouse.h"

@implementation OMBOpenHouseDeleteConnection

#pragma mark - Initializer

- (id) initWithOpenHouse: (OMBOpenHouse *) object
{
  if (!(self = [super init])) return nil;

  NSString *string = [NSString stringWithFormat: @"%@/open_houses/%i",
    OnMyBlockAPIURL, object.uid];
  NSDictionary *params = @{
    @"access_token": [OMBUser currentUser].accessToken
  };
  [self setRequestWithString: string method: @"DELETE" parameters: params];

  return self;
}

@end
