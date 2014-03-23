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

- (id) initWithModel: (OMBObject *) object userUID: (NSUInteger) userUID
{
  if (!(self = [super initWithModel: object])) return nil;

  NSString *string = [NSString stringWithFormat: @"%@/%@",
    OnMyBlockAPIURL, [object resourceName]];
  [self setRequestWithString: string parameters: @{
    @"access_token": [OMBUser currentUser].accessToken,
    @"user_id": [NSNumber numberWithInt: userUID]
  }];

  return self;
}

@end
