//
//  NSString+Extensions.m
//  SpadeTree
//
//  Created by Tommy DANGerous on 7/19/13.
//  Copyright (c) 2013 Quantum Ventures. All rights reserved.
//

#import "NSString+Extensions.h"

@implementation NSString (Extensions)

#pragma mark - Methods

#pragma mark - Class Methods

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

#pragma mark - Instance Methods

- (NSAttributedString *) attributedStringWithFont: (UIFont *) font
lineHeight: (CGFloat) lineHeight
{
  NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
  style.maximumLineHeight = lineHeight;
  style.minimumLineHeight = lineHeight;
  return [[NSMutableAttributedString alloc] initWithString: self attributes: 
    @{
      NSFontAttributeName: font,
      NSParagraphStyleAttributeName: style
    }
  ];
}

- (NSAttributedString *) attributedStringWithString: (NSString *) string 
primaryColor: (UIColor *) primaryColor 
secondaryColor: (UIColor *) secondayColor
{  
  NSMutableAttributedString *string1 = 
    [[NSMutableAttributedString alloc] initWithString: self attributes: @{
      NSForegroundColorAttributeName: primaryColor
    }
  ];
  NSAttributedString *string2 = [[NSAttributedString alloc] initWithString: 
    string attributes: @{
      NSForegroundColorAttributeName: secondayColor
    }
  ];
  [string1 appendAttributedString: string2];
  return string1;
}

- (NSAttributedString *) attributedStringWithLineHeight: (CGFloat) lineHeight
{
  NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
  style.maximumLineHeight = lineHeight;
  style.minimumLineHeight = lineHeight;
  return [[NSMutableAttributedString alloc] initWithString: self attributes: 
    @{
      NSParagraphStyleAttributeName: style
    }
  ];
}

- (CGRect) boundingRectWithSize: (CGSize) size font: (UIFont *) font
{
  return [self boundingRectWithSize: size 
    options: NSStringDrawingUsesLineFragmentOrigin
      attributes: @{ NSFontAttributeName: font } context: nil];
}

- (NSDictionary *) dictionaryFromString
{
  NSArray *array = [self componentsSeparatedByString: @"?"];
  NSString *parameterString = [array objectAtIndex: [array count] - 1];
  NSArray *parameterArray = [parameterString componentsSeparatedByString: @"&"];
  NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
  for (NSString *string in parameterArray) {
    NSString *key = 
      [[string componentsSeparatedByString: @"="] objectAtIndex: 0];
    NSString *value =
      [[string componentsSeparatedByString: @"="] objectAtIndex: 1];
    [parameters setObject: value forKey: key];
  }
  return parameters;
}

- (NSString *) stripWhiteSpace
{
  return [self stringByTrimmingCharactersInSet: 
    [NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

@end
