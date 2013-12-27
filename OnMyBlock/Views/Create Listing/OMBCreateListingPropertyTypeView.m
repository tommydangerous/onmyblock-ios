//
//  OMBCreateListingPropertyTypeView.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/26/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBCreateListingPropertyTypeView.h"

#import "UIColor+Extensions.h"

@implementation OMBCreateListingPropertyTypeView

#pragma mark - Initializer

- (id) initWithFrame: (CGRect) rect
{
  if (!(self = [super initWithFrame: rect])) return nil;

  CGFloat padding   = 20.0f;
  CGFloat imageSize = self.frame.size.width * 1.0f;

  _imageView = [UIImageView new];
  _imageView.frame = CGRectMake((self.frame.size.width - imageSize) * 0.5,
    padding, imageSize, imageSize);
  [self addSubview: _imageView];

  _label = [UILabel new];
  _label.font = [UIFont fontWithName: @"HelveticaNeue-Medium" size: 27];
  _label.frame = CGRectMake(0.0f, 
    _imageView.frame.origin.y + _imageView.frame.size.height + padding,
      self.frame.size.width, 54.0f);
  _label.textAlignment = NSTextAlignmentCenter;
  _label.textColor = [UIColor grayMedium];
  [self addSubview: _label];

  return self;
}

@end
