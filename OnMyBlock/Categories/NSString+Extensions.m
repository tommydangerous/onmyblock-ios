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

+ (NSString *) timeAgoInShortFormatWithTimeInterval: (NSTimeInterval) interval
{
  // 5h
  // Sun
  // Jan 4
  // 11/4/13

  NSDateFormatter *dateFormatter = [NSDateFormatter new];
  NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
  CGFloat secondsInADay = 60 * 60 * 24;
  // Within a day
  if (interval > now - (secondsInADay * 1)) {
    // 4:31 pm
    dateFormatter.dateFormat = @"h:mm a";

    // 5h, 5m, or 5s
    NSInteger secondsElapsed = [[NSDate date] timeIntervalSince1970] - interval;
    NSInteger hours = secondsElapsed / (60 * 60);
    secondsElapsed -= hours * 60 * 60;
    if (hours) {
      NSString *hoursString = [NSString stringWithFormat: @"%ih", hours];
      return hoursString;
    }
    else {
      NSInteger minutes = secondsElapsed / 60;
      secondsElapsed -= minutes * 60;
      if (minutes) {
        NSString *minutesString = [NSString stringWithFormat: @"%im", minutes];
        return minutesString;
      }
      else {
        NSInteger seconds = secondsElapsed;
        NSString *secondsString = [NSString stringWithFormat: @"%is", seconds];
        return secondsString;
      }
    }
  }
  // Within the week
  else if (interval > now - (secondsInADay * 7)) {
    // Sun
    dateFormatter.dateFormat = @"EEE";
  }
  else if (interval > now - (secondsInADay * 365)) {
    // Jan 4
    dateFormatter.dateFormat = @"MMM d";
  }
  else {
    // 11/04/13
    dateFormatter.dateFormat = @"M/d/yy";
  }
  NSString *string = [dateFormatter stringFromDate: 
    [NSDate dateWithTimeIntervalSince1970: interval]];
  if (interval > now - (secondsInADay * 1)) {
    string = [string lowercaseString];
  }
  return string;
}

+ (NSString *) timeRemainingShortFormatWithAllUnitsInterval: 
(NSTimeInterval) interval
{
  // 5d 2h 32m 5s
  NSInteger secondsElapsed = interval - [[NSDate date] timeIntervalSince1970];

  NSString *string = @"";
  if (secondsElapsed > 0) {
    // Days
    NSInteger days = secondsElapsed / (60 * 60 * 24);
    secondsElapsed -= days * 60 * 60 * 24;
    NSString *daysString = [NSString stringWithFormat: @"%id", days];
    // Hours
    NSInteger hours = secondsElapsed / (60 * 60);
    secondsElapsed -= hours * 60 * 60;
    NSString *hoursString = [NSString stringWithFormat: @"%ih", hours];
    // Minutes
    NSInteger minutes = secondsElapsed / 60;
    secondsElapsed -= minutes * 60;
    NSString *minutesString = [NSString stringWithFormat: @"%im", minutes];
    // Seconds
    NSString *secondsString = [NSString stringWithFormat: @"%is", 
      secondsElapsed];
    if (days) {
      string = [string stringByAppendingString: 
        [NSString stringWithFormat: @" %@", daysString]];
    }
    if (hours) {
      string = [string stringByAppendingString: 
        [NSString stringWithFormat: @" %@", hoursString]];
    }
    if (minutes) {
      string = [string stringByAppendingString: 
        [NSString stringWithFormat: @" %@", minutesString]];
    }
    string = [string stringByAppendingString: 
      [NSString stringWithFormat: @" %@", secondsString]];
  }
  else {
    string = @"0s";
  }
  return string;
}

+ (NSString *) timeRemainingShortFormatWithInterval: (NSTimeInterval) interval
{
  // 5d 2h
  // 2h 3m
  // 3m 12s
  NSInteger secondsElapsed = interval - [[NSDate date] timeIntervalSince1970];

  NSString *string = @"0s";
  if (secondsElapsed > 0) {
    // Days
    NSInteger days = secondsElapsed / (60 * 60 * 24);
    secondsElapsed -= days * 60 * 60 * 24;
    NSString *daysString = [NSString stringWithFormat: @"%id", days];
    // Hours
    NSInteger hours = secondsElapsed / (60 * 60);
    secondsElapsed -= hours * 60 * 60;
    NSString *hoursString = [NSString stringWithFormat: @"%ih", hours];
    // Minutes
    NSInteger minutes = secondsElapsed / 60;
    secondsElapsed -= minutes * 60;
    NSString *minutesString = [NSString stringWithFormat: @"%im", minutes];
    // Seconds
    NSString *secondsString = [NSString stringWithFormat: @"%is", 
      secondsElapsed];
    if (days) {
      string = [NSString stringWithFormat: @"%@ %@",
        daysString, hoursString];
    }
    else if (hours) {
      string = [NSString stringWithFormat: @"%@ %@",
        hoursString, minutesString];
    }
    else if (minutes) {
      string = [NSString stringWithFormat: @"%@ %@", minutesString, 
        secondsString];
    }
    else {
      string = [NSString stringWithFormat: @"%@", secondsString];
    }
  }
  return string;
}

#pragma mark - Instance Methods

- (NSAttributedString *) attributedStringWithFont: (UIFont *) font
lineHeight: (CGFloat) lineHeight
{
  NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
  // style.maximumLineHeight = lineHeight;
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

- (NSArray *) matchingResultsWithRegularExpression: (NSString *) string
{
  NSRegularExpression *regex = 
    [NSRegularExpression regularExpressionWithPattern: string 
      options: 0 error: nil];
  return [regex matchesInString: self options: 0 
    range: NSMakeRange(0, [self length])];
}

- (NSString *) stripWhiteSpace
{
  return [self stringByTrimmingCharactersInSet: 
    [NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

@end
