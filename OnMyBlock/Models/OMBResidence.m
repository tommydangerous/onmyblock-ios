//
//  OMBResidence.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 10/21/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBResidence.h"

#import "NSString+Extensions.h"
#import "UIImage+Resize.h"

@implementation OMBResidence

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
@synthesize coverPhotoURL = _coverPhotoImageURL;
@synthesize images        = _images;

#pragma mark - Initializer

- (id) init
{
  self = [super init];
  if (self) {
    _images = [NSMutableDictionary dictionary];
  }
  return self;
}

#pragma mark - Methods

#pragma mark Instance Methods

- (UIImage *) coverPhoto
{
  if ([_images count] > 0) {
    return [[self imagesArray] objectAtIndex: 0];
  }
  return nil;
}

- (UIImage *) coverPhotoWithSize: (CGSize) size
{
  UIImage *img = [self coverPhoto];
  float newHeight, newWidth;
  if (img.size.width < img.size.height) {
    newHeight = size.height;
    newWidth  = (newHeight / img.size.height) * img.size.width;
  }
  else {
    newWidth  = size.width;
    newHeight = (newWidth / img.size.width) * img.size.height;
  }
  CGPoint point = CGPointMake(0, 0);
  // Center it horizontally
  if (newWidth > size.width)
    point.x = (newWidth - size.width) / -2.0;
  // Center it vertically
  if (newHeight > size.height)
    point.y = (newHeight - size.height) / -2.0;
  return [UIImage image: img size: CGSizeMake(newWidth, newHeight) 
    point: point];
}

- (NSString *) dictionaryKey
{
  return [NSString stringWithFormat: @"%f,%f-%@", _latitude, _longitude,
    _address];
}

- (NSArray *) imagesArray
{
  // keys are based on image position; e.g. 1-12
  NSArray *keys = [_images allKeys];
  keys = [keys sortedArrayUsingComparator: ^(id obj1, id obj2) {
    int key1 = [(NSString *) obj1 intValue];
    int key2 = [(NSString *) obj2 intValue];
    if (key1 > key2)
      return (NSComparisonResult) NSOrderedAscending;
    if (key1 < key2)
      return (NSComparisonResult) NSOrderedDescending;
    return (NSComparisonResult) NSOrderedSame;
  }];
  NSMutableArray *array = [NSMutableArray array];
  for (NSString *key in keys) {
    [array addObject: [_images objectForKey: key]];
  }
  return array;
}

- (void) readFromDictionary: (NSDictionary *) dictionary
{
  // Sample JSON
  //   {
  //     ad: 8550 fun street,  // Address
  //     available_on: "Soon", // Available on
  //     ba: 0,                // Bathrooms
  //     bd: 0,                // Bedrooms
  //     id: 10,               // ID
  //     lat: 32.79383,        // Latitude
  //     lease_months: null,   // Lease months
  //     lng: -117.07943,      // Longitude
  //     rt: 0                 // Rent
  //   }
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
    _leaseMonths = [[dictionary objectForKey: @"lease_months"] intValue];
  }
  _longitude = [[dictionary objectForKey: @"lng"] floatValue];
  _rent      = [[dictionary objectForKey: @"rt"] floatValue];
  _uid       = [[dictionary objectForKey: @"id"] intValue];
}

- (NSString *) rentToCurrencyString
{
  return [NSString numberToCurrencyString: (int) _rent];
}

@end
