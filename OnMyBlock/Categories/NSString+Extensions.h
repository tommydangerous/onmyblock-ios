//
//  NSString+Extensions.h
//  SpadeTree
//
//  Created by Tommy DANGerous on 7/19/13.
//  Copyright (c) 2013 Quantum Ventures. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extensions)

#pragma mark - Methods

#pragma mark - Class Methods

+ (NSString *) stringFromDateForJSON: (NSDate *) date;
+ (NSString *) numberToCurrencyString: (int) number;
+ (NSString *) stripLower: (NSString *) string;

#pragma mark - Instance Methods

- (NSAttributedString *) attributedStringWithFont: (UIFont *) font
lineHeight: (CGFloat) lineHeight;
- (NSAttributedString *) attributedStringWithString: (NSString *) string 
primaryColor: (UIColor *) primaryColor 
secondaryColor: (UIColor *) secondayColor;
- (NSAttributedString *) attributedStringWithLineHeight: (CGFloat) lineHeight;
- (CGRect) boundingRectWithSize: (CGSize) size font: (UIFont *) font;
- (NSDictionary *) dictionaryFromString;
- (NSString *) stripWhiteSpace;

@end
