//
//  OMBCreateListingPropertyTypeCell.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/26/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBCreateListingPropertyTypeCell.h"

#import "UIColor+Extensions.h"

@implementation OMBCreateListingPropertyTypeCell

#pragma mark - Initializer

- (id) initWithStyle: (UITableViewCellStyle) style 
reuseIdentifier: (NSString *) reuseIdentifier
{
  if (!(self = [super initWithStyle: style 
    reuseIdentifier: reuseIdentifier])) return nil;
  
  self.accessoryType  = UITableViewCellAccessoryDisclosureIndicator;
  UIView *backgroundView = [UIView new];
  backgroundView.backgroundColor = [UIColor blueLight];
  self.selectedBackgroundView = backgroundView;

  _propertyTypeImageView = [UIImageView new];
  [self.contentView addSubview: _propertyTypeImageView];

  _propertyTypeLabel = [UILabel new];
  _propertyTypeLabel.font = [UIFont fontWithName: @"HelveticaNeue-Medium" 
    size: 18];
  _propertyTypeLabel.textColor = [UIColor textColor];
  [self.contentView addSubview: _propertyTypeLabel];

  return self;
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) setFramesForSubviewsWithSize: (CGSize) size
{
  CGFloat padding = 20.0f;

  CGFloat imageSize = size.height - (padding * 3);
  _propertyTypeImageView.frame = CGRectMake(padding * 1.5, 
    (size.height - imageSize) * 0.5, imageSize, imageSize);

  CGFloat labelOriginX = _propertyTypeImageView.frame.origin.x + 
    _propertyTypeImageView.frame.size.width + (padding * 1.5);
  _propertyTypeLabel.frame = CGRectMake(labelOriginX, 0.0f,
    size.width - (labelOriginX + (padding * 1.5)), size.height); 
}

@end
