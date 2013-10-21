//
//  OMBProperty.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 10/18/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBProperty.h"

@implementation OMBProperty

@synthesize address     = _address;
@synthesize availableOn = _availableOn;
@synthesize bathrooms   = _bathrooms;
@synthesize bedrooms    = _bedrooms;
@synthesize latitude    = _latitude;
@synthesize leaseMonths = _leaseMonths;
@synthesize longitude   = _longitude;
@synthesize rent        = _rent;
@synthesize uid         = _uid;

#pragma mark - Methods

#pragma mark Instance Methods

- (NSString *) latitudeLongitudeKey
{
  return [NSString stringWithFormat: @"%f,%f", _latitude, _longitude];
}

- (void) readFromDictionary: (NSDictionary *) dictionary
{
  _address   = [dictionary objectForKey: @"ad"];
  // _availableOn
  _bathrooms = [[dictionary objectForKey: @"ba"] floatValue];
  _bedrooms  = [[dictionary objectForKey: @"bd"] floatValue];
  _latitude  = [[dictionary objectForKey: @"lat"] floatValue];
  _longitude = [[dictionary objectForKey: @"lng"] floatValue];
  _rent      = [[dictionary objectForKey: @"rt"] floatValue];
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
