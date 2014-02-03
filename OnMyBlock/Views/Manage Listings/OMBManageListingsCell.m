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
#import "OMBResidenceCoverPhotoURLConnection.h"
#import "OMBTemporaryResidence.h"
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
  centeredImageView.backgroundColor = [UIColor grayUltraLight];
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
    size: 13];
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

- (void) clearImage
{
  [centeredImageView clearImage];
}

- (void) loadResidenceData: (OMBResidence *) object
{
  residence = object;

  // Image
  if (![residence coverPhoto])
    [self clearImage];
  NSString *sizeKey = [NSString stringWithFormat: @"%f,%f",
    centeredImageView.frame.size.width, centeredImageView.frame.size.height];
  UIImage *image = [residence coverPhotoForSizeKey: sizeKey];
  if (image) {
    centeredImageView.image = image;
  }
  else {
    OMBResidenceCoverPhotoURLConnection *conn = 
      [[OMBResidenceCoverPhotoURLConnection alloc] initWithResidence: 
        residence];
    conn.completionBlock = ^(NSError *error) {
      if ([residence coverPhoto]) {
        centeredImageView.image = [residence coverPhoto];
        [residence.coverPhotoSizeDictionary setObject: centeredImageView.image
          forKey: sizeKey];
        [self setStatusLabelText];
      }
    };
    [conn start];
  }

  // Address
  if ([residence.address length] || [residence.title length]) {
    if ([residence.title length])
      addressLabel.text = residence.title;
    else
      addressLabel.text = [residence.address capitalizedString];
  }
  else {
    addressLabel.text = [NSString stringWithFormat: @"%@ in %@",
      [residence.propertyType capitalizedString], 
        [residence.city capitalizedString]];
  }
  CGRect addressRect = [addressLabel.text boundingRectWithSize:
    CGSizeMake(addressLabel.frame.size.width, 23.0f * 2) 
      font: addressLabel.font];
  addressLabel.frame = CGRectMake(addressLabel.frame.origin.x,
    addressLabel.frame.origin.y, addressLabel.frame.size.width,
      addressRect.size.height);

  // Property
  propertyTypeLabel.text = [residence.propertyType capitalizedString];
  // NSString *class = @"residence";
  // if ([residence isKindOfClass: [OMBTemporaryResidence class]])
  //   class = @"temporaryResidence";
  // propertyTypeLabel.text = [NSString stringWithFormat: @"(%@)", class];
  CGRect propertyRect = [propertyTypeLabel.text boundingRectWithSize:
    CGSizeMake(addressLabel.frame.size.width, 
      propertyTypeLabel.frame.size.height) font: propertyTypeLabel.font];
  propertyTypeLabel.frame = CGRectMake(propertyTypeLabel.frame.origin.x,
    propertyTypeLabel.frame.origin.y,
      propertyRect.size.width, propertyTypeLabel.frame.size.height);

  [self setStatusLabelText];
}

- (void) setStatusLabelText
{
  CGRect screen = [[UIScreen mainScreen] bounds];
  CGFloat screenWidth = screen.size.width;
  CGFloat padding = 10.0f;

  NSString *statusString = @"";
  if ([residence numberOfStepsLeft]) {
    NSString *stepsString = @"steps";
    if ([residence numberOfStepsLeft] == 1)
      stepsString = @"step";
    statusString = [NSString stringWithFormat: @"%i %@", 
      [residence numberOfStepsLeft], stepsString];
    _statusLabel.textColor = [UIColor blue];
  }
  else {
    if ([residence isKindOfClass: [OMBTemporaryResidence class]]) {
      statusString = @"Ready";
      _statusLabel.textColor = [UIColor pink];
    }
    else {
      if (residence.inactive) {
        statusString = @"Unlisted";
        _statusLabel.textColor = [UIColor redColor];
      }
      else {
        statusString = @"Listed";
        _statusLabel.textColor = [UIColor green];
      }
    }
  }

  _statusLabel.text = statusString;
  CGRect statusRect = [_statusLabel.text boundingRectWithSize: CGSizeMake(
    addressLabel.frame.size.width, _statusLabel.frame.size.height) 
      font: _statusLabel.font];
  _statusLabel.frame = CGRectMake(
    screenWidth - (statusRect.size.width + padding), 
      _statusLabel.frame.origin.y, statusRect.size.width, 
        _statusLabel.frame.size.height);
}

@end
