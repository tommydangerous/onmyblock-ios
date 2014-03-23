//
//  NSDictionary+DictionaryWithObject.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 3/22/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import <objc/runtime.h>

@interface NSDictionary (DictionaryWithObject)

+ (NSDictionary *) dictionaryWithPropertiesOfObject: (id) obj;

@end
