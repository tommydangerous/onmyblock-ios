//
//  OMBEmployment.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/9/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBEmployment.h"

@implementation OMBEmployment

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
  return @"employment";
}

+ (NSString *) resourceName
{
  return [NSString stringWithFormat: @"%@s", [OMBEmployment modelName]];
}

#pragma mark - Instance Methods

- (NSString *) companyWebsiteString
{
  return [NSString stringWithFormat: @"http://www.%@", 
    [self shortCompanyWebsiteString]];
}

- (int) numberOfMonthsEmployed
{
  if (_endDate && _startDate) {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = (NSDayCalendarUnit | NSMonthCalendarUnit | 
      NSWeekdayCalendarUnit | NSYearCalendarUnit);
    NSDateComponents *endDateComponents = [calendar components: unitFlags
      fromDate: [NSDate dateWithTimeIntervalSince1970: _endDate]];
    NSDateComponents *startDateComponents = [calendar components: unitFlags
      fromDate: [NSDate dateWithTimeIntervalSince1970: _startDate]];
    [endDateComponents setDay: 1];
    [startDateComponents setDay: 1];
    NSDate *endDateDate   = [calendar dateFromComponents: endDateComponents];
    NSDate *startDateDate = [calendar dateFromComponents: startDateComponents];
    NSDateComponents *dateComponents = [calendar components: NSMonthCalendarUnit
      fromDate: startDateDate toDate: endDateDate options:0];
    return [dateComponents month];
  }
  return 0;
}

- (NSString *) numberOfMonthsEmployedString
{
  int months = [self numberOfMonthsEmployed];
  int years  = months / 12;
  int value  = months;
  NSString *string = @"months";
  if (months == 1)
    string = @"month";
  if (years > 0) {
    string = @"years";
    if (years == 1)
      string = @"year";
    value = years;
  }
  return [NSString stringWithFormat: @"%i %@", value, string];
}

- (void) readFromDictionary: (NSDictionary *) dictionary
{
  // Company name
  if ([dictionary objectForKey: @"company_name"] == [NSNull null])
    _companyName = @"";
  else
    _companyName = [dictionary objectForKey: @"company_name"];

  // Company website
  if ([dictionary objectForKey: @"company_website"] == [NSNull null])
    _companyWebsite = @"";
  else
    _companyWebsite = [dictionary objectForKey: @"company_website"];

  NSDateFormatter *dateFormatter = [NSDateFormatter new];
  dateFormatter.dateFormat = @"yyyy-MM-d HH:mm:ss ZZZ";
  if ([dictionary objectForKey: @"end_date"] != [NSNull null]) {
    _endDate = [[dateFormatter dateFromString: 
      [dictionary objectForKey: @"end_date"]] timeIntervalSince1970];
  }
  if ([dictionary objectForKey: @"income"] != [NSNull null])
    _income = [[dictionary objectForKey: @"income"] floatValue];
  if ([dictionary objectForKey: @"start_date"] != [NSNull null]) {
    _startDate = [[dateFormatter dateFromString: 
      [dictionary objectForKey: @"start_date"]] timeIntervalSince1970];
  }
  if ([dictionary objectForKey: @"title"] == [NSNull null])
    _title = @"";
  else
    _title = [dictionary objectForKey: @"title"];
  
  self.uid = [[dictionary objectForKey: @"id"] intValue];
}

- (NSString *) shortCompanyWebsiteString
{
  NSArray *words = [_companyWebsite componentsSeparatedByString: @"www."];
  NSString *website = [words objectAtIndex: [words count] - 1];
  words = [website componentsSeparatedByString: @"http://"];
  website = [words objectAtIndex: [words count] - 1];
  return website;
}

@end
