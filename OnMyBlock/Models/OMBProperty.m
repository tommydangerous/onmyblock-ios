//
//  OMBProperty.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 10/18/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBProperty.h"

@implementation OMBProperty

// Web app properties
@synthesize address     = _address;
@synthesize availableOn = _availableOn;
@synthesize bathrooms   = _bathrooms;
@synthesize bedrooms    = _bedrooms;
@synthesize latitude    = _latitude;
@synthesize leaseMonths = _leaseMonths;
@synthesize longitude   = _longitude;
@synthesize rent        = _rent;
@synthesize uid         = _uid;

// iOS app properties
@synthesize image = _image;

#pragma mark - Methods

#pragma mark Instance Methods

- (NSURL *) imageURL
{
  return nil;
}

- (NSString *) dictionaryKey
{
  return [NSString stringWithFormat: @"%f,%f-%@", _latitude, _longitude,
    _address];
}

- (void) readFromDictionary: (NSDictionary *) dictionary
{
  _address   = [dictionary objectForKey: @"ad"];
  // Available on example value: October 23, 2013
  NSString *dateString        = [dictionary objectForKey: @"available_on"];
  NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
  [dateFormat setDateFormat: @"MMMM d, yyyyy"];
  if ([dateString isEqualToString: @"Immediately"] || 
    [dateString isEqualToString: @"Soon"]) {
    _availableOn = [[NSDate date] timeIntervalSince1970];
  }
  else {
    _availableOn = [[dateFormat dateFromString: 
      dateString] timeIntervalSince1970];
  }
  _bathrooms = [[dictionary objectForKey: @"ba"] floatValue];
  _bedrooms  = [[dictionary objectForKey: @"bd"] floatValue];
  _latitude  = [[dictionary objectForKey: @"lat"] floatValue];
  if ([dictionary objectForKey: @"lease_months"] == [NSNull null]) {
    _leaseMonths = 0;
  }
  else {
    _leaseMonths = [[dictionary objectForKey: @"lease_months"] integerValue];
  }
  _longitude = [[dictionary objectForKey: @"lng"] floatValue];
  _rent      = [[dictionary objectForKey: @"rt"] floatValue];
  _uid       = [[dictionary objectForKey: @"id"] integerValue];
}

- (NSString *) rentToCurrencyString
{
  NSNumberFormatter *formatter = [NSNumberFormatter new];
  [formatter setMaximumFractionDigits: 0];
  [formatter setNumberStyle: NSNumberFormatterCurrencyStyle];
  return [formatter stringFromNumber: 
    [NSNumber numberWithInteger: (int) _rent]];
}

@end
