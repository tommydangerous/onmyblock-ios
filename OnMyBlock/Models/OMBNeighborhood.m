//
//  OMBNeighborhood.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 10/22/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBNeighborhood.h"

@implementation OMBNeighborhood

#pragma mark - Methods

#pragma mark - Instance Methods

- (NSString *) nameKey
{
  return [self.name lowercaseString];
}

- (void) readFromQBox:(NSDictionary *)dic
{
  // coordinates
  NSArray *coordinate = [[[dic objectForKey:@"payload"]
    objectForKey: @"latlon"] componentsSeparatedByString: @","];
  
  _coordinate = CLLocationCoordinate2DMake(
     [coordinate[0] doubleValue], [coordinate[1] doubleValue]);
  _name = [dic objectForKey:@"text"];
}

@end
