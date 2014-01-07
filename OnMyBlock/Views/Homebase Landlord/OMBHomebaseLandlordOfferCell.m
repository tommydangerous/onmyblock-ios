//
//  OMBHomebaseLandlordOfferCell.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 1/4/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBHomebaseLandlordOfferCell.h"

#import "NSString+Extensions.h"
#import "OMBCenteredImageView.h"

@implementation OMBHomebaseLandlordOfferCell

#pragma mark - Initializer

- (id) initWithStyle: (UITableViewCellStyle) style 
reuseIdentifier: (NSString *) reuseIdentifier
{
  if (!(self = [super initWithStyle: style reuseIdentifier: reuseIdentifier])) 
    return nil;

  CGRect screen       = [[UIScreen mainScreen] bounds];
  CGFloat screenWidth = screen.size.width;
  CGFloat padding     = 20.0f;

  // Image
  CGFloat imageSize = 22.0f + 22.0f + 22.0f;
  userImageView = [[OMBCenteredImageView alloc] init];
  userImageView.frame = CGRectMake(padding, padding, imageSize, imageSize);
  userImageView.layer.cornerRadius = imageSize * 0.5f;
  [self.contentView addSubview: userImageView];

  // Time
  timeLabel = [UILabel new];
  timeLabel.font = [UIFont fontWithName: @"HelveticaNeue-Light" size: 13];
  CGRect timeLabelRect = [timeLabel.text boundingRectWithSize: 
    CGSizeMake(screenWidth, 15.0f) font: timeLabel.font];
  timeLabel.frame = CGRectMake(
    screenWidth - (timeLabelRect.size.width + padding), padding,
      timeLabelRect.size.width, 15.0f);
  timeLabel.textColor = [UIColor grayMedium];
  [self.contentView addSubview: timeLabel];
  
  // Name
  nameLabel = [UILabel new];
  nameLabel.font = [UIFont fontWithName: @"HelveticaNeue-Medium" size: 15];
  CGFloat nameLabelOriginX = userImageView.frame.origin.x + 
    userImageView.frame.size.width + padding;
  nameLabel.frame = CGRectMake(nameLabelOriginX, padding, 
    screenWidth - 
    (nameLabelOriginX + padding + timeLabel.frame.size.width + padding), 
      22.0f);
  nameLabel.textColor = [UIColor textColor];
  [self.contentView addSubview: nameLabel];

  // Type
  typeLabel = [UILabel new];
  typeLabel.font = [UIFont fontWithName: @"HelveticaNeue-Light" size: 15];
  typeLabel.frame = CGRectMake(nameLabel.frame.origin.x, 
    nameLabel.frame.origin.y + nameLabel.frame.size.height, 
      screenWidth - (nameLabelOriginX + padding), 22.0f);
  typeLabel.textColor = [UIColor grayMedium];
  [self.contentView addSubview: typeLabel];

  // Rent
  rentLabel = [UILabel new];
  rentLabel.font = [UIFont fontWithName: @"HelveticaNeue-Medium" size: 15];
  rentLabel.textColor = [UIColor pink];
  [self.contentView addSubview: rentLabel];

  // Address
  addressLabel = [UILabel new];
  addressLabel.font = typeLabel.font;
  addressLabel.textColor = [UIColor textColor];
  [self.contentView addSubview: addressLabel];

  return self;
}

#pragma mark - Methods

#pragma mark - Class Methods

+ (CGFloat) heightForCell
{
  CGFloat padding = 20.0f;
  return padding + 22.0f + 22.0f + 22.0f + padding;
}

#pragma mark - Instance Methods

- (void) adjustFrames
{
  CGRect screen       = [[UIScreen mainScreen] bounds];
  CGFloat screenWidth = screen.size.width;
  CGFloat padding     = 20.0f;

  // Time
  CGRect timeLabelRect = [timeLabel.text boundingRectWithSize: 
    CGSizeMake(screenWidth, 15.0f) font: timeLabel.font];
  timeLabel.frame = CGRectMake(
    screenWidth - (timeLabelRect.size.width + padding), padding,
      timeLabelRect.size.width, 15.0f);

  // Name
  CGFloat nameLabelOriginX = userImageView.frame.origin.x + 
    userImageView.frame.size.width + padding;
  nameLabel.frame = CGRectMake(nameLabelOriginX, padding, 
    screenWidth - 
    (nameLabelOriginX + padding + timeLabel.frame.size.width + padding), 
      22.0f);

  // Rent
  CGRect rentLabelRect = [rentLabel.text boundingRectWithSize: 
    CGSizeMake(screenWidth, typeLabel.frame.size.height) font: rentLabel.font];
  rentLabel.frame = CGRectMake(nameLabel.frame.origin.x,
    typeLabel.frame.origin.y + typeLabel.frame.size.height, 
      rentLabelRect.size.width, nameLabel.frame.size.height);

  // Address
  CGFloat addressMaxWidth = screenWidth - 
    (rentLabel.frame.origin.x + rentLabel.frame.size.width + 
      (padding * 0.5) + padding);
  addressLabel.frame = CGRectMake(
    rentLabel.frame.origin.x + rentLabel.frame.size.width + (padding * 0.5f), 
      rentLabel.frame.origin.y, addressMaxWidth, rentLabel.frame.size.height);
}

- (void) loadConfirmedTenantData
{
  // Image
  userImageView.image = [UIImage imageNamed: @"edward_d.jpg"];
  // Time
  timeLabel.text = @"+3 more";
  timeLabel.textColor = [UIColor blueDark];
  // Name
  nameLabel.text = @"Edward Drake";
  // Type / Tenants
  typeLabel.text = @"4/13/14 - 10/1/14";
  // Rent
  rentLabel.text = @"$2,100";
  // Address
  addressLabel.text = @"275 Sand Hill Rd";
  [self adjustFrames];
}

- (void) loadOfferData
{
  // Image
  userImageView.image = [UIImage imageNamed: @"tommy_d.png"];
  // Time
  timeLabel.text = @"6d";
  timeLabel.textColor = [UIColor grayMedium];
  // Name
  nameLabel.text = @"Tommy Dang";
  // Type / Tenants
  typeLabel.text = @"response required";
  // Rent
  rentLabel.text = @"$2,750";
  // Address
  addressLabel.text = @"4654 Costa Verde Blvd";
  [self adjustFrames];
}

@end
