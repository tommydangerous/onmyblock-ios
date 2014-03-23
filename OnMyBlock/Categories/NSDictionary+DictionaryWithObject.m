//
//  NSDictionary+DictionaryWithObject.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 3/22/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "NSDictionary+DictionaryWithObject.h"

@implementation NSDictionary (DictionaryWithObject)

+ (NSDictionary *) dictionaryWithPropertiesOfObject: (id) obj
{
  NSMutableDictionary *dict = [NSMutableDictionary dictionary];

    unsigned count;
    objc_property_t *properties = class_copyPropertyList([obj class], &count);

    for (int i = 0; i < count; i++) {
        NSString *key = [NSString stringWithUTF8String:property_getName(properties[i])];
        id value = [obj valueForKey: key];
        if (value && value != [NSNull null])
          [dict setObject: value forKey: key];
    }

    free(properties);

    return [NSDictionary dictionaryWithDictionary:dict];
}

@end
