//
//  UIFont+OnMyBlock.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 1/24/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const OMBFontName;
extern NSString *const OMBFontNameBold;

@interface UIFont (OnMyBlock)

#pragma mark - Methods

#pragma mark - Class Methods

+ (UIFont *) fontWithSize: (NSInteger) size bold: (BOOL) bold;
+ (UIFont *) largeTextFont;
+ (UIFont *) largeTextFontBold;
+ (UIFont *) normalTextFont;
+ (UIFont *) normalTextFontBold;
+ (UIFont *) smallTextFont;
+ (UIFont *) smallTextFontBold;

@end
