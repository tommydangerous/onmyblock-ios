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
  return [UIFont fontWithSize: 18 bold: NO];
}

+ (UIFont *) largeTextFontBold
{
  return [UIFont fontWithSize: 18 bold: YES]; 
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

@end
