//
//  OMBFavoriteResidenceConnection.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 11/1/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBFavoriteResidenceConnection.h"

#import "OMBResidence.h"

@implementation OMBFavoriteResidenceConnection

#pragma mark - Initializer

- (id) initWithResidence: (OMBResidence *) residence
{
  if (!(self = [super init])) return nil;

  NSString *string = [NSString stringWithFormat:
    @"%@/places/%i/favorite/", OnMyBlockAPIURL, residence.uid];
  [self setRequestWithString: string method: @"POST" parameters: @{
    @"access_token":   [OMBUser currentUser].accessToken,
    @"created_source": @"ios"
  }];

  return self;
}

@end
