//
//  OMBPreviousRental.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/6/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBPreviousRental.h"

@implementation OMBPreviousRental

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) readFromDictionary: (NSDictionary *) dictionary
{
  _address          = [dictionary objectForKey: @"address"];
  _city             = [dictionary objectForKey: @"city"];
  _landlordEmail    = [dictionary objectForKey: @"landlord_email"];
  _landlordName     = [dictionary objectForKey: @"landlord_name"];
  _landlordLastName = [dictionary objectForKey: @"landlord_lastname"];
  _landlordPhone    = [dictionary objectForKey: @"landlord_phone"];
  _leaseMonths      = [[dictionary objectForKey: @"lease_months"] intValue];
  
  NSDateFormatter *dateFormatter = [NSDateFormatter new];
  dateFormatter.dateFormat = @"yyyy-MM-d HH:mm:ss ZZZ";
  if ([dictionary objectForKey: @"start_date"] != [NSNull null]) {
    _moveInDate = [[dictionary objectForKey: @"start_date"] timeIntervalSince1970];
  }
  if ([dictionary objectForKey: @"end_date"] != [NSNull null]) {
    _moveOutDate = [[dictionary objectForKey: @"end_date"] timeIntervalSince1970];
  }
  
  if ([dictionary objectForKey: @"rent"])
    _rent = [[dictionary objectForKey: @"rent"] floatValue];
  _school  = [dictionary objectForKey: @"school"];
  _state  = [dictionary objectForKey: @"state"];
  _zip    = [dictionary objectForKey: @"zip"];

  _uid = [[dictionary objectForKey: @"id"] intValue];
}

@end
