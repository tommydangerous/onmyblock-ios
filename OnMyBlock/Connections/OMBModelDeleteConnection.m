//
//  OMBModelDeleteConnection.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 3/22/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBModelDeleteConnection.h"

@implementation OMBModelDeleteConnection

#pragma mark - Initializer

- (id) initWithModel: (OMBObject *) object
{
  if (!(self = [super initWithModel: object])) return nil;

  NSString *string = [NSString stringWithFormat: @"%@/%@/%i",
    OnMyBlockAPIURL, [object resourceName], [object uid]];
  [self setRequestWithString: string method: @"DELETE" parameters: @{
    @"access_token": [OMBUser currentUser].accessToken
  }];

  return self;
}

@end
