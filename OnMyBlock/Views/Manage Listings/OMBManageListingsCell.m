//
//  OMBManageListingsCell.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/30/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBManageListingsCell.h"

#import "OMBCenteredImageView.h"
#import "OMBResidence.h"
#import "UIImage+Color.h"

@implementation OMBManageListingsCell

#pragma mark - Initializer

- (id) initWithStyle: (UITableViewCellStyle) style 
reuseIdentifier: (NSString *) reuseIdentifier
{
  if (!(self = [super initWithStyle: style reuseIdentifier: reuseIdentifier])) 
    return nil;

  self.selectedBackgroundView = [[UIImageView alloc] initWithImage:
    [UIImage imageWithColor: [UIColor blue]]];

  CGRect screen = [[UIScreen mainScreen] bounds];
  CGFloat screenWidth = screen.size.width;
  CGFloat padding = 10.0f;

  centeredImageView = [[OMBCenteredImageView alloc] init];
  centeredImageView.frame = CGRectMake(0.0f, 0.0f, 
    screenWidth * 0.3f, [OMBManageListingsCell heightForCell]);
  [self.contentView addSubview: centeredImageView];

  CGFloat addressOriginX = centeredImageView.frame.origin.x +
    centeredImageView.frame.size.width + padding;
  addressLabel = [UILabel new];
  addressLabel.font = [UIFont fontWithName: @"HelveticaNeue-Medium" size: 15];
  addressLabel.frame = CGRectMake(addressOriginX, padding, 
    screenWidth - (addressOriginX + padding), 23.0f);
  addressLabel.numberOfLines = 0;
  addressLabel.textColor = [UIColor textColor];
  [self.contentView addSubview: addressLabel];

  CGFloat propertyTypeHeight = 20.0f;
  propertyTypeLabel = [UILabel new];
  propertyTypeLabel.font = [UIFont fontWithName: @"HelveticaNeue-Light" 
    size: 14];
  propertyTypeLabel.frame = CGRectMake(addressLabel.frame.origin.x,
    [OMBManageListingsCell heightForCell] - (propertyTypeHeight + padding),
      0.0f, propertyTypeHeight);
  propertyTypeLabel.textColor = [UIColor grayMedium];
  [self.contentView addSubview: propertyTypeLabel];

  _statusLabel = [UILabel new];
  _statusLabel.font = propertyTypeLabel.font;
  _statusLabel.frame = CGRectMake(screenWidth, propertyTypeLabel.frame.origin.y,
    0.0f, propertyTypeLabel.frame.size.height);
  [self.contentView addSubview: _statusLabel];

  return self;
}

#pragma mark - Methods

#pragma mark - Class Methods

+ (CGFloat) heightForCell
{
  CGFloat padding = 10.0f;
  return padding + 23.0f + 23.0f + 20.0f + padding;
}

#pragma mark - Instance Methods

- (void) loadResidenceData: (OMBResidence *) object
{
  residence = object;

  centeredImageView.image = [UIImage imageNamed: 
    @"intro_still_image_slide_3_background.jpg"];
  addressLabel.text = @"8550 Costa Verde Blvd";
  CGRect addressRect = [addressLabel.text boundingRectWithSize:
    CGSizeMake(addressLabel.frame.size.width, 23.0f * 2) 
      font: addressLabel.font];
  addressLabel.frame = CGRectMake(addressLabel.frame.origin.x,
    addressLabel.frame.origin.y, addressLabel.frame.size.width,
      addressRect.size.height);

  propertyTypeLabel.text = @"Apartment";
  CGRect propertyRect = [propertyTypeLabel.text boundingRectWithSize:
    CGSizeMake(addressLabel.frame.size.width, 
      propertyTypeLabel.frame.size.height) font: propertyTypeLabel.font];
  propertyTypeLabel.frame = CGRectMake(propertyTypeLabel.frame.origin.x,
    propertyTypeLabel.frame.origin.y,
      propertyRect.size.width, propertyTypeLabel.frame.size.height);
}

- (void) setStatusLabelText: (NSString *) string
{
  CGRect screen = [[UIScreen mainScreen] bounds];
  CGFloat screenWidth = screen.size.width;
  CGFloat padding = 10.0f;

  _statusLabel.text = string;
  CGRect statusRect = [_statusLabel.text boundingRectWithSize: CGSizeMake(
    addressLabel.frame.size.width, _statusLabel.frame.size.height) 
      font: _statusLabel.font];
  _statusLabel.frame = CGRectMake(
    screenWidth - (statusRect.size.width + padding), 
      _statusLabel.frame.origin.y, statusRect.size.width, 
        _statusLabel.frame.size.height);
}

@end
