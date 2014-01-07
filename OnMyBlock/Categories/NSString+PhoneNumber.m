//
//  NSString+PhoneNumber.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/5/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "NSString+PhoneNumber.h"

@implementation NSString (PhoneNumber)

- (NSString *) phoneNumberString
{
  if (self && [self length] > 0) {
    NSRegularExpression *regex = 
      [NSRegularExpression regularExpressionWithPattern: @"([0-9]+)" 
        options: 0 error: nil];
    NSArray *matches = [regex matchesInString: self options: 0 
      range: NSMakeRange(0, [self length])];
    NSString *newPhone = @"";
    for (NSTextCheckingResult *result in matches) {
      newPhone = [newPhone stringByAppendingString: 
        [self substringWithRange: result.range]];
    }
    if ([newPhone length] >= 10) {
      NSString *areaCodeString = [newPhone substringWithRange: 
        NSMakeRange(0, 3)];
      NSString *phoneString1   = [newPhone substringWithRange: 
        NSMakeRange(3, 3)];
      NSString *phoneString2   = [newPhone substringWithRange: 
        NSMakeRange(6, 4)];
      return [NSString stringWithFormat: @"(%@) %@-%@", 
        areaCodeString, phoneString1, phoneString2];
    }
  }
  return @"";
}

@end
