//
//  OMBRoommate.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 3/17/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBRoommate.h"

@implementation OMBRoommate

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) readFromDictionary: (NSDictionary *) dictionary
{
  NSDateFormatter *dateFormatter = [NSDateFormatter new];
  dateFormatter.dateFormat = @"yyyy-MM-d HH:mm:ss ZZZ";
  if ([dictionary objectForKey: @"createdAt"] != [NSNull null]) {
    _createdAt = [[dateFormatter dateFromString:
                   [dictionary objectForKey: @"createdAt"]] timeIntervalSince1970];
  }
  
  _email = [dictionary objectForKey: @"email"];
  _firstName = [dictionary objectForKey: @"first_name"];
  _lastName = [dictionary objectForKey: @"last_name"];
  
  _uid   = [[dictionary objectForKey: @"id"] intValue];
}

@end
