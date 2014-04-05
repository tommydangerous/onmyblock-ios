//
//  OMBModelDetailConnection.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 4/5/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBModelDetailConnection.h"

@implementation OMBModelDetailConnection

- (id) initWithModel: (OMBObject *) object
{
  if (!(self = [super initWithModel: object])) return nil;

  NSString *string = [NSString stringWithFormat: @"%@/%@/%i",
    OnMyBlockAPIURL, [object resourceName], [object uid]];
  [self setRequestWithString: string parameters: @{
    @"access_token": [OMBUser currentUser].accessToken
  }];

  return self;
}

@end
