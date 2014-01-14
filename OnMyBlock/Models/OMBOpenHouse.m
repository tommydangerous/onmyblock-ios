//
//  OMBOpenHouse.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 1/13/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBOpenHouse.h"

@implementation OMBOpenHouse

#pragma mark - Methods

#pragma mark - Instace Methods

- (void) readFromDictionary: (NSDictionary *) dictionary
{
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  dateFormatter.dateFormat       = @"yyyy-MM-dd HH:mm:ss ZZZ";

  _duration = [[dictionary objectForKey: @"duration"] intValue];
  _startDate = [[dateFormatter dateFromString:
    [dictionary objectForKey: @"start_date"]] timeIntervalSince1970];
  _uid = [[dictionary objectForKey: @"id"] intValue];
}

@end
