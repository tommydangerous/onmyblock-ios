//
//  UIFont+OnMyBlock.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 1/24/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "UIFont+OnMyBlock.h"

NSString *const OMBFontName     = @"HelveticaNeue-Light";
NSString *const OMBFontNameBold = @"HelveticaNeue-Medium";

@implementation UIFont (OnMyBlock)

// UIFont size - line height
// 13 - 17
// 14 - 18
// 15 - 20
// 18 - 23
// 20 - 26
// 27 - 33

#pragma mark - Methods

#pragma mark - Class Methods

+ (UIFont *) fontWithSize: (NSInteger) size bold: (BOOL) bold
{
  NSString *name = OMBFontName;
  if (bold)
    name = OMBFontNameBold;
  return [UIFont fontWithName: name size: size];
}

+ (UIFont *) largeTextFont
{
  return [UIFont fontWithSize: 27 bold: NO];
}

+ (UIFont *) largeTextFontBold
{
  return [UIFont fontWithSize: 27 bold: YES];
}

+ (UIFont *) mediumLargeTextFont
{
  return [UIFont fontWithSize: 22 bold: NO];
}

+ (UIFont *) mediumLargeTextFontBold
{
  return [UIFont fontWithSize: 22 bold: YES];
}

+ (UIFont *) mediumTextFont
{
  return [UIFont fontWithSize: 18 bold: NO];
}

+ (UIFont *) mediumTextFontBold
{
  return [UIFont fontWithSize: 18 bold: YES];
}

+ (UIFont *) normalSmallTextFont
{
  return [UIFont fontWithSize: 14 bold: NO];
}

+ (UIFont *) normalSmallTextFontBold
{
  return [UIFont fontWithSize: 14 bold: YES];
}

+ (UIFont *) normalTextFont
{
  return [UIFont fontWithSize: 15 bold: NO];
}

+ (UIFont *) normalTextFontBold
{
  return [UIFont fontWithSize: 15 bold: YES];
}

+ (UIFont *) smallTextFont
{
  return [UIFont fontWithSize: 13 bold: NO];
}

+ (UIFont *) smallTextFontBold
{
  return [UIFont fontWithSize: 13 bold: YES];
}

+ (UIFont *) veryLargeTextFont
{
  return [UIFont fontWithSize: 36 bold: NO];
}

+ (UIFont *) veryLargeTextFontBold
{
  return [UIFont fontWithSize: 36 bold: YES];
}

@end
