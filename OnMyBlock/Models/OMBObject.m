//
//  OMBObject.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 3/22/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBObject.h"

@implementation OMBObject

#pragma mark - Methods

#pragma mark - Class Methods

+ (NSString *) modelName
{
  return @"object";
}

#pragma mark - Instance Methods

- (NSString *) modelName
{
  return [[[NSStringFromClass([self class]) componentsSeparatedByString: 
    @"OMB"] lastObject] lowercaseString];
}

- (NSString *) resourceName
{
  return [NSString stringWithFormat: @"%@s", [self modelName]];
}

@end
