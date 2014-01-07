//
//  OMBCosigner.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/5/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBCosigner.h"

@implementation OMBCosigner

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) readFromDictionary: (NSDictionary *) dictionary
{
  _email     = [dictionary objectForKey: @"email"];
  _firstName = [dictionary objectForKey: @"first_name"];
  _lastName  = [dictionary objectForKey: @"last_name"];
  _phone     = [dictionary objectForKey: @"phone"];
  _uid       = [[dictionary objectForKey: @"id"] intValue];
}

@end
