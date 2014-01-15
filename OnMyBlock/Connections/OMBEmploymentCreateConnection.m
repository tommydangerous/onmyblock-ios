//
//  OMBEmploymentCreateConnection.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/10/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBEmploymentCreateConnection.h"

#import "NSString+Extensions.h"
#import "OMBEmployment.h"

@implementation OMBEmploymentCreateConnection

#pragma mark - Initializer

- (id) initWithEmployment: (OMBEmployment *) object
{
  if (!(self = [super init])) return self;

  employment = object;

  NSString *string = [NSString stringWithFormat: @"%@/employments",
    OnMyBlockAPIURL];
  NSURL *url = [NSURL URLWithString: string];
  NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL: url];
  NSString *endDateString = @"";
  if (employment.endDate) {
    endDateString = [NSString stringFromDateForJSON: 
      [NSDate dateWithTimeIntervalSince1970: employment.endDate]];
  }
  NSString *startDateString = @"";
  if (employment.startDate) {
    startDateString = [NSString stringFromDateForJSON: 
      [NSDate dateWithTimeIntervalSince1970: employment.startDate]]; 
  }
  NSDictionary *objectParams = @{
    @"company_name":    employment.companyName,
    @"company_website": employment.companyWebsite,
    @"end_date":        endDateString,
    @"income":          [NSNumber numberWithFloat: employment.income],
    @"start_date":      startDateString,
    @"title":           employment.title
  };
  NSDictionary *params = @{
    @"access_token": [OMBUser currentUser].accessToken,
    @"employment":   objectParams
  };
  NSData *json = [NSJSONSerialization dataWithJSONObject: params
    options: 0 error: nil];
  [req addValue: @"application/json" forHTTPHeaderField: @"Content-Type"];
  [req setHTTPBody: json];
  [req setHTTPMethod: @"POST"];
  self.request = req;

  return self;
}

#pragma mark - Protocol

#pragma mark - Protocol NSURLConnectionDataDelegate

- (void) connectionDidFinishLoading: (NSURLConnection *) connection
{
  NSDictionary *json = [NSJSONSerialization JSONObjectWithData: container
    options: 0 error: nil];
  if ([[json objectForKey: @"success"] intValue] == 1) {
    NSDictionary *dict = [json objectForKey: @"object"];
    employment.uid = [[dict objectForKey: @"id"] intValue];
  }
  [super connectionDidFinishLoading: connection];
}

@end
