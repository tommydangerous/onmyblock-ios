//
//  OMBPreviousRental.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/6/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBPreviousRental.h"

@implementation OMBPreviousRental

#pragma mark - Protocol

#pragma mark - Protocol OMBConnectionProtocol

- (void) JSONDictionary: (NSDictionary *) dictionary
{
  if ([dictionary objectForKey: @"object"] == [NSNull null])
    [self readFromDictionary: dictionary];
  else
    [self readFromDictionary: [dictionary objectForKey: @"object"]];
}

#pragma mark - Methods

#pragma mark - Class Methods

+ (NSString *) modelName
{
  return @"previous_rental";
}

+ (NSString *) resourceName
{
  return [NSString stringWithFormat: @"%@s", [OMBPreviousRental modelName]];
}

#pragma mark - Instance Methods

- (void) readFromDictionary: (NSDictionary *) dictionary
{
  if ([dictionary objectForKey: @"address"] != [NSNull null])
    _address = [dictionary objectForKey: @"address"];

  if ([dictionary objectForKey: @"city"] != [NSNull null])
    _city = [dictionary objectForKey: @"city"];

  if ([dictionary objectForKey: @"landlord_email"] != [NSNull null])
    _landlordEmail = [dictionary objectForKey: @"landlord_email"];

  if ([dictionary objectForKey: @"landlord_name"] != [NSNull null])
    _landlordName = [dictionary objectForKey: @"landlord_name"];

  if ([dictionary objectForKey: @"landlord_phone"] != [NSNull null])
    _landlordPhone = [dictionary objectForKey: @"landlord_phone"];
  
  NSDateFormatter *dateFormatter = [NSDateFormatter new];
  dateFormatter.dateFormat = @"yyyy-MM-d HH:mm:ss ZZZ";
  if ([dictionary objectForKey: @"move_in_date"] != [NSNull null]) {
    _moveInDate = [[dateFormatter dateFromString:
      [dictionary objectForKey: @"move_in_date"]] timeIntervalSince1970];
  }
  if ([dictionary objectForKey: @"move_out_date"] != [NSNull null]) {
    _moveOutDate = [[dateFormatter dateFromString:
      [dictionary objectForKey: @"move_out_date"]] timeIntervalSince1970];
  }
  
  if ([dictionary objectForKey: @"rent"] != [NSNull null])
    _rent = [[dictionary objectForKey: @"rent"] floatValue];

  if ([dictionary objectForKey: @"school"] != [NSNull null])
    _school = [dictionary objectForKey: @"school"];

  if ([dictionary objectForKey: @"state"] != [NSNull null])
    _state = [dictionary objectForKey: @"state"];

  if ([dictionary objectForKey: @"zip"] != [NSNull null])
    _zip = [dictionary objectForKey: @"zip"];

  self.uid = [[dictionary objectForKey: @"id"] intValue];
}

@end
