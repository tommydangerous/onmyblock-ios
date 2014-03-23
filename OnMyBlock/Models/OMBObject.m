//
//  OMBObject.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 3/22/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBObject.h"

#import "NSString+Extensions.h"

@implementation OMBObject

#pragma mark - Methods

#pragma mark - Class Methods

+ (NSString *) modelName
{
  return @"object";
}

+ (NSString *) resourceName
{
  return [NSString stringWithFormat: @"%@s", [OMBObject modelName]];
}

#pragma mark - Instance Methods

- (NSString *) modelName
{
  NSString *string = [[NSStringFromClass([self class])
    componentsSeparatedByString: @"OMB"] lastObject];
  return [[[string stringSeparatedByUppercaseStrings] componentsJoinedByString: 
    @"_"] lowercaseString];
}

- (NSString *) resourceName
{
  return [NSString stringWithFormat: @"%@s", [self modelName]];
}

@end
