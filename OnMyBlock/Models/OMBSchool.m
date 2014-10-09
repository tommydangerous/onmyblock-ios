//
//  OMBSchool.m
//  OnMyBlock
//
//  Created by Paul Aguilar on 8/6/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBSchool.h"

@implementation OMBSchool

#pragma mark - Initializer

- (id)init
{
  if(!(self = [super init]))
    return nil;
  
  return self;
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void)readFromQBox:(NSDictionary *)dic
{
  // coordinates
  NSArray *coordinate = [[[dic objectForKey:@"payload"]
    objectForKey: @"latlon"] componentsSeparatedByString: @","];
  
  _coordinate = CLLocationCoordinate2DMake(
    [coordinate[0] doubleValue], [coordinate[1] doubleValue]);
  _displayName = [dic objectForKey:@"text"];
}

- (NSString *)realName
{
  if(_realName)
    return _realName;
  
  return _displayName;
}

@end
