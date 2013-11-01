//
//  OMBFavoriteResidence.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 10/31/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBFavoriteResidence.h"

#import "OMBResidence.h"

@implementation OMBFavoriteResidence

@synthesize createdAt = _createdAt;
@synthesize residence = _residence;

#pragma mark - Methods

#pragma mark - Instance Methods

- (NSString *) dictionaryKey
{
  return [NSString stringWithFormat: @"%i", _residence.uid];
}

@end
