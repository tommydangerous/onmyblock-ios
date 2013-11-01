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
  NSURL *url = [NSURL URLWithString: string];
  NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL: url];
  NSString *params = [NSString stringWithFormat:
    @"access_token=%@", 
    [OMBUser currentUser].accessToken
  ];
  [req setHTTPBody: [params dataUsingEncoding: NSUTF8StringEncoding]];
  [req setHTTPMethod: @"POST"];
  self.request = req;

  return self;
}

@end
