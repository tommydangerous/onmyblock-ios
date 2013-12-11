//
//  NSString+Extensions.h
//  SpadeTree
//
//  Created by Tommy DANGerous on 7/19/13.
//  Copyright (c) 2013 Quantum Ventures. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extensions)

+ (NSString *) stringFromDateForJSON: (NSDate *) date;
+ (NSString *) numberToCurrencyString: (int) number;
+ (NSString *) stripLower: (NSString *) string;

- (NSString *) stripWhiteSpace;

@end
