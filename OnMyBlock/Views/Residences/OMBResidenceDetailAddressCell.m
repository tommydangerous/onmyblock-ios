//
//  OMBResidenceDetailAddressCell.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/17/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBResidenceDetailAddressCell.h"

@implementation OMBResidenceDetailAddressCell

#pragma mark - Initializer

- (id) initWithStyle: (UITableViewCellStyle) style 
reuseIdentifier: (NSString *)reuseIdentifier
{
  if (!(self = [super initWithStyle: style reuseIdentifier: reuseIdentifier])) 
    return nil;

  CGRect screen = [[UIScreen mainScreen] bounds];

  float screeWidth = screen.size.width;

  float padding = 20.0f;

  [self.titleLabel removeFromSuperview];

  // Address label
  _addressLabel       = [[UILabel alloc] init];
  _addressLabel.font  = [UIFont fontWithName: @"HelveticaNeue-Light" size: 22];
  _addressLabel.frame = CGRectMake(padding, padding * 0.8, 
    screeWidth - (padding * 2), 33.0f);
  _addressLabel.textColor = [UIColor textColor];
  [self.contentView addSubview: _addressLabel];

  _bedBathLeaseMonthLabel = [[UILabel alloc] init];
  _bedBathLeaseMonthLabel.font = [UIFont fontWithName: @"HelveticaNeue-Light"
    size: 15];
  _bedBathLeaseMonthLabel.frame = CGRectMake(_addressLabel.frame.origin.x,
    _addressLabel.frame.origin.y + _addressLabel.frame.size.height,
      _addressLabel.frame.size.width, 23.0f);
  _bedBathLeaseMonthLabel.textColor = _addressLabel.textColor;
  [self.contentView addSubview: _bedBathLeaseMonthLabel];

  _propertyTypeLabel = [[UILabel alloc] init];
  _propertyTypeLabel.font = _bedBathLeaseMonthLabel.font;
  _propertyTypeLabel.frame = CGRectMake(_addressLabel.frame.origin.x,
    _bedBathLeaseMonthLabel.frame.origin.y + 
    _bedBathLeaseMonthLabel.frame.size.height,
      _bedBathLeaseMonthLabel.frame.size.width, 
        _bedBathLeaseMonthLabel.frame.size.height);
  _propertyTypeLabel.textColor = [UIColor grayMedium];
  [self.contentView addSubview: _propertyTypeLabel];

  return self;
}

#pragma mark - Methods

#pragma mark - Class Methods

+ (CGFloat) heightForCell
{
  // Padding top of address, address height, bed height, property type height
  // padding bottom
  return (20.0f * 0.8) + 33.0f + 23.0f + 23.0f + 20.0f;
}

@end
