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

+ (NSString *) numberToCurrencyString: (int) number;
+ (NSString *) stringFromDateForJSON: (NSDate *) date;
+ (NSString *) stripLower: (NSString *) string;
+ (NSString *) timeAgoInShortFormatWithTimeInterval: (NSTimeInterval) interval;
+ (NSString *) timeRemainingShortFormatWithAllUnitsInterval: 
  (NSTimeInterval) interval;
+ (NSString *) timeRemainingShortFormatWithInterval: (NSTimeInterval) interval;

#pragma mark - Instance Methods

- (NSAttributedString *) attributedStringWithFont: (UIFont *) font
lineHeight: (CGFloat) lineHeight;
- (NSAttributedString *) attributedStringWithString: (NSString *) string 
primaryColor: (UIColor *) primaryColor 
secondaryColor: (UIColor *) secondayColor;
- (NSAttributedString *) attributedStringWithLineHeight: (CGFloat) lineHeight;
- (CGRect) boundingRectWithSize: (CGSize) size font: (UIFont *) font;
- (NSDictionary *) dictionaryFromString;
- (NSArray *) matchingResultsWithRegularExpression: (NSString *) string;
- (NSString *) stripWhiteSpace;

@end
