//
//  OMBRentedBannerView.m
//  OnMyBlock
//
//  Created by Paul Aguilar on 7/21/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBRentedBannerView.h"

#import "UIColor+Extensions.h"
#import "UIFont+OnMyBlock.h"

@implementation OMBRentedBannerView

- (id)initWithFrame:(CGRect)frame
{
  
  if (!(self = [super initWithFrame:frame]))
    return nil;

  self.backgroundColor = [UIColor orange];
  
  UILabel *rentedLabel = [UILabel new];
  float height = 40.f;
  rentedLabel.font = [UIFont mediumTextFontBold];
  rentedLabel.frame = CGRectMake(10.f,
    (frame.size.height - height) * .5f,
      70.f, height);
  rentedLabel.text = @"Rented";
  rentedLabel.textColor = UIColor.whiteColor;
  [self addSubview:rentedLabel];
  
  _availableLabel = [UILabel new];
  float widthLabel = frame.size.width - rentedLabel.frame.size.width - 3 * 10.f;
  _availableLabel.font = [UIFont smallTextFont];
  _availableLabel.frame = CGRectMake(rentedLabel.frame.origin.x +
    rentedLabel.frame.size.width + 10.f,
      (frame.size.height - 20.f) * .5f,
        widthLabel, 20.f);
  _availableLabel.textAlignment = NSTextAlignmentRight;
  _availableLabel.textColor = UIColor.whiteColor;
  [self addSubview:_availableLabel];
  
  return self;
}

@end
