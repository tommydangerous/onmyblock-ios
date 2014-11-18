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
  
  if (!(self = [super initWithFrame:frame])) {
    return nil;
  }

  self.backgroundColor = [UIColor orange];
  
  float height = 40.f;
  _rentedLabel = [UILabel new];
  _rentedLabel.font = [UIFont mediumTextFontBold];
  _rentedLabel.frame = CGRectMake(10.f,
    (frame.size.height - height) * .5f,
      70.f, height);
  _rentedLabel.text = @"Rented";
  _rentedLabel.textColor = UIColor.whiteColor;
  [self addSubview:_rentedLabel];
  
  _availableLabel = [UILabel new];
  float widthLabel = frame.size.width - _rentedLabel.frame.size.width - 3 * 10.f;
  _availableLabel.font = [UIFont smallTextFont];
  _availableLabel.frame = CGRectMake(_rentedLabel.frame.origin.x +
    _rentedLabel.frame.size.width + 10.f,
      (frame.size.height - 20.f) * .5f,
        widthLabel, 20.f);
  _availableLabel.textAlignment = NSTextAlignmentRight;
  _availableLabel.textColor = UIColor.whiteColor;
  [self addSubview:_availableLabel];
  
  return self;
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void)loadDateAvailable:(NSTimeInterval)timeInterval
{
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  dateFormatter.dateFormat       = @"MMMM d, yyyy";
  NSString *moveInSring = [dateFormatter stringFromDate:
    [NSDate dateWithTimeIntervalSince1970: timeInterval]];
  _availableLabel.text = [NSString stringWithFormat:
    @"Available on %@", moveInSring];
}

@end
