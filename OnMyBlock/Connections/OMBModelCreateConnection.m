//
//  OMBCreateModelConnection.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 3/22/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBModelCreateConnection.h"

#import "NSDateFormatter+JSON.h"
#import "NSDictionary+DictionaryWithObject.h"
#import "NSString+Extensions.h"

@implementation OMBModelCreateConnection

#pragma mark - Initializer

- (id) initWithModel: (OMBObject *) object
{
  if (!(self = [super initWithModel: object])) return nil;

  NSMutableDictionary *objectParams = [NSMutableDictionary dictionary];
  NSDictionary *dictionary = [NSDictionary dictionaryWithPropertiesOfObject:
    object];
  for (NSString *key in [dictionary allKeys]) {
    id value = [dictionary objectForKey: key];
    NSString *newKey = [[[key stringSeparatedByUppercaseStrings]
      componentsJoinedByString: @"_"] lowercaseString];
    if ([newKey rangeOfString: @"date"].location != NSNotFound) {
      if ([[dictionary objectForKey: key] doubleValue] > 0) {
        value = [[NSDateFormatter JSONDateParser] stringFromDate:
          [NSDate dateWithTimeIntervalSince1970: [value doubleValue]]];
        [objectParams setObject: value forKey: newKey];
      }
    }
    else {
      [objectParams setObject: value forKey: newKey];
    }
  }
  // This is used to track where the models were created from
  // Web or iOS
  [objectParams setObject: OnMyBlockCreatedSource forKey: @"created_source"];

  NSString *string = [NSString stringWithFormat: @"%@/%@",
    OnMyBlockAPIURL, [object resourceName]];
  NSDictionary *params = [NSDictionary dictionaryWithObjects:
    @[[OMBUser currentUser].accessToken, objectParams] forKeys:
      @[@"access_token", [object modelName]]];
  [self setRequestWithString: string method: @"POST" parameters: params];

  return self;
}

@end
