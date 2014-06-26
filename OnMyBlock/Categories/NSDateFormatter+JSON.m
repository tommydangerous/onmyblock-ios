//
//  NSDateFormatter+JSON.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 1/22/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "NSDateFormatter+JSON.h"

@implementation NSDateFormatter (JSON)

#pragma mark - Methods

#pragma mark - Class Methods

#pragma mark - Public

+ (NSDateFormatter *) JSONDateParser
{
  static NSDateFormatter *dateFormatter = nil;

  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    dateFormatter = [[NSDateFormatter alloc] init];
  });

  [dateFormatter setDateFormatRubyCustom];
  
  return dateFormatter; 
}

#pragma mark - Instance Methods

#pragma mark - Public

- (void) setDateFormatRubyCustom
{
  self.dateFormat = @"yyyy-MM-dd HH:mm:ss ZZZ";
}

- (void) setDateFormatRubyDefault
{
  self.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSSZZZ";
}

@end
