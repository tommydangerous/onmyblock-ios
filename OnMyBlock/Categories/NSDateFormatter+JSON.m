//
//  NSDateFormatter+JSON.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 1/22/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "NSDateFormatter+JSON.h"

@implementation NSDateFormatter (JSON)

+ (NSDateFormatter *) JSONDateParser
{
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  dateFormatter.dateFormat       = @"yyyy-MM-dd HH:mm:ss ZZZ";
  return dateFormatter; 
}

@end
