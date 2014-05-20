//
//  OMBSentApplicationListConnection.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 5/20/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBSentApplicationListConnection.h"

@implementation OMBSentApplicationListConnection

#pragma mark - Initializer

- (id) init
{
  if (!(self = [super init])) return nil;

  NSString *string = [NSString stringWithFormat: @"%@/sent_applications",
    OnMyBlockAPIURL];
  [self setRequestWithString: string parameters: @{
    @"access_token": [OMBUser currentUser].accessToken
  }];

  return self;
}

@end
