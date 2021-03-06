//
//  OMBModelListConnection.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 3/22/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBModelListConnection.h"

@implementation OMBModelListConnection

#pragma mark - Initializer

- (id) initWithResourceName: (NSString *) resourceName 
userUID: (NSUInteger) userUID
{
  if (!(self = [super init])) return nil;

  self.resourceName = resourceName;
  NSString *string = [NSString stringWithFormat: @"%@/%@",
    OnMyBlockAPIURL, resourceName];
  [self setRequestWithString: string parameters: @{
    @"access_token": [OMBUser currentUser].accessToken,
    @"user_id":      [NSNumber numberWithInt: userUID]
  }];

  return self;
}

@end
