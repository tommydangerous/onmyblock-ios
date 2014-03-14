//
//  OMBDeleteConnection.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 3/12/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBDeleteConnection.h"

@implementation OMBDeleteConnection

#pragma mark - Initializer

- (id) initWithModelString: (NSString *) modelString UID: (NSUInteger) UID
{
  if (!(self = [super init])) return nil;

  NSString *string = [NSString stringWithFormat: @"%@/%@/%i",
    OnMyBlockAPIURL, modelString, UID];
  [self setRequestWithString: string method: @"DELETE" parameters: @{
    @"access_token": [OMBUser currentUser].accessToken
  }];

  return self;
}

@end
