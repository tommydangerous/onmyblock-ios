//
//  NSString+Extensions.m
//  SpadeTree
//
//  Created by Tommy DANGerous on 7/19/13.
//  Copyright (c) 2013 Quantum Ventures. All rights reserved.
//

#import "NSString+Extensions.h"

@implementation NSString (Extensions)

+ (NSString *) numberToCurrencyString: (int) number
{
  NSNumberFormatter *formatter = [NSNumberFormatter new];
  [formatter setMaximumFractionDigits: 0];
  [formatter setNumberStyle: NSNumberFormatterCurrencyStyle];
  return [formatter stringFromNumber: 
    [NSNumber numberWithInteger: number]];
}

+ (NSString *) stripLower: (NSString *) string
{
  return [[string stringByTrimmingCharactersInSet: 
    [NSCharacterSet whitespaceAndNewlineCharacterSet]] lowercaseString];
}

+ (NSString *) stringFromDateForJSON: (NSDate *) date
{
  if (!date)
    return @"";
  NSDateFormatter *dateFormatter = [NSDateFormatter new];
  dateFormatter.dateFormat = @"yyyy-MM-d";
  return [dateFormatter stringFromDate: date];
}

- (NSString *) stripWhiteSpace
{
  return [self stringByTrimmingCharactersInSet: 
    [NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

@end
