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
  
  if([[dictionary objectForKey: @"email"]  length])
    _email = [dictionary objectForKey: @"email"];
  else
    _email = @"";
  
  if([[dictionary objectForKey: @"first_name"] length])
    _firstName = [dictionary objectForKey: @"first_name"];
  else
    _firstName = @"";
  
  if([[dictionary objectForKey: @"last_name"] length])
    _lastName = [dictionary objectForKey: @"last_name"];
  else
    _lastName = @"";
  
  _uid   = [[dictionary objectForKey: @"id"] intValue];
}

@end
