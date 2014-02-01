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
#import "OMBOffer.h"
#import "OMBResidence.h"
#import "OMBUser.h"
#import "UIFont+OnMyBlock.h"

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

  CGFloat width = screenWidth - (userImageView.frame.origin.x +
    userImageView.frame.size.width + padding + padding);
  // Time
  timeLabel = [UILabel new];
  timeLabel.font = [UIFont smallTextFont];
  timeLabel.frame = CGRectMake(userImageView.frame.origin.x + 
    userImageView.frame.size.width + padding, padding, width, 15.0f);
  timeLabel.textAlignment = NSTextAlignmentRight;
  [self.contentView addSubview: timeLabel];
  
  // Name
  nameLabel = [UILabel new];
  nameLabel.font = [UIFont normalTextFontBold];
  nameLabel.frame = CGRectMake(timeLabel.frame.origin.x, 
    timeLabel.frame.origin.y, timeLabel.frame.size.width, 22.0f);
  nameLabel.textColor = [UIColor textColor];
  [self.contentView addSubview: nameLabel];

  // Address
  addressLabel = [UILabel new];
  addressLabel.font = [UIFont smallTextFont];
  addressLabel.frame = CGRectMake(nameLabel.frame.origin.x,
    nameLabel.frame.origin.y + nameLabel.frame.size.height,
      nameLabel.frame.size.width, nameLabel.frame.size.height);
  addressLabel.textColor = [UIColor grayMedium];
  [self.contentView addSubview: addressLabel];

  // Rent
  rentLabel = [UILabel new];
  rentLabel.font = [UIFont normalTextFont];
  rentLabel.frame = CGRectMake(addressLabel.frame.origin.x,
    addressLabel.frame.origin.y + addressLabel.frame.size.height,
      addressLabel.frame.size.width, addressLabel.frame.size.height);
  rentLabel.textColor = [UIColor pink];
  [self.contentView addSubview: rentLabel];

  // Type
  typeLabel = [UILabel new];
  typeLabel.font = [UIFont smallTextFont];
  typeLabel.frame = rentLabel.frame;
  typeLabel.textAlignment = NSTextAlignmentRight;
  [self.contentView addSubview: typeLabel];

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

- (void) loadConfirmedTenant: (OMBOffer *) object
{
  _offer = object;
  
  // Image
  if (_offer.user.image) {
    userImageView.image = [_offer.user imageForSize: userImageView.frame.size];
  }
  else {
    [_offer.user downloadImageFromImageURLWithCompletion: ^(NSError *error) {
      userImageView.image = [_offer.user imageForSize: 
        userImageView.frame.size];
    }];
    userImageView.image = [UIImage imageNamed: @"user_icon.png"];
  }
  // Name
  nameLabel.text = [_offer.user fullName];
  // Dates
  NSDateFormatter *dateFormatter = [NSDateFormatter new];
  dateFormatter.dateFormat = @"M/d/yy";
  NSDate *moveInDate = [NSDate dateWithTimeIntervalSince1970: 
    _offer.residence.moveInDate];
  NSDate *moveOutDate = [_offer.residence moveOutDate];
  typeLabel.text = [NSString stringWithFormat: @"%@ - %@",
    [dateFormatter stringFromDate: moveInDate],
      [dateFormatter stringFromDate: moveOutDate]];
  typeLabel.textColor = [UIColor textColor];
  // Address
  addressLabel.text = [_offer.residence.address capitalizedString];
  // Rent
  rentLabel.text = [NSString numberToCurrencyString: _offer.amount];

  // NSMutableAttributedString *rentAttributedString = 
  //   [[NSMutableAttributedString alloc] initWithString: 
  //     [NSString numberToCurrencyString: (int) _offer.amount] attributes: @{
  //       NSFontAttributeName: [UIFont fontWithName: @"HelveticaNeue-Medium" 
  //         size: 15],
  //       NSForegroundColorAttributeName: [UIColor pink]
  //     }
  //   ];
  // if ([_offer.residence.address length]) {
  //   NSMutableAttributedString *addressAttributedString = 
  //     [[NSMutableAttributedString alloc] initWithString: 
  //       _offer.residence.address attributes: @{
  //         NSFontAttributeName: [UIFont fontWithName: @"HelveticaNeue-Light" 
  //           size: 15],
  //         NSForegroundColorAttributeName: [UIColor textColor]
  //       }
  //     ];
  //   NSMutableAttributedString *spacesString = 
  //     [[NSMutableAttributedString alloc] initWithString: @"   "];
  //   [rentAttributedString appendAttributedString: spacesString];
  //   [rentAttributedString appendAttributedString: addressAttributedString];
  // }
  // rentLabel.attributedText = rentAttributedString;
}

- (void) loadOfferForLandlord: (OMBOffer *) object
{
  _offer = object;

  // Image
  if (_offer.user.image) {
    userImageView.image = [_offer.user imageForSize: userImageView.frame.size];
  }
  else {
    [_offer.user downloadImageFromImageURLWithCompletion: ^(NSError *error) {
      userImageView.image = [_offer.user imageForSize: 
        userImageView.frame.size];
    }];
    userImageView.image = [UIImage imageNamed: @"user_icon.png"];
  }
  // Time
  timeLabel.text = [NSString timeAgoInShortFormatWithTimeInterval:
    _offer.createdAt];
  timeLabel.textColor = [UIColor grayMedium];
  // Name
  nameLabel.text = [_offer.user fullName];
  // Status
  UIColor *color;
  NSString *status;
  if (_offer.rejected) {
    color = [UIColor red];
    status = @"student rejected";
  }
  else if (_offer.confirmed) {
    color = [UIColor green];
    status = @"student confirmed";
  }
  else if (_offer.accepted) {
    color = [UIColor yellow];
    status = @"waiting for student";
  }
  else if (_offer.onHold) {
    color = [UIColor grayMedium];
    status = @"on hold";
  }
  else if (_offer.declined) {
    color = [UIColor grayMedium];
    status = @"declined";
  }
  else {
    color = [UIColor blue];
    status = @"response required";
  }
  typeLabel.text = status;
  typeLabel.textColor = color;
  // Address
  addressLabel.text = [_offer.residence.address capitalizedString];
  // Rent
  rentLabel.text = [NSString numberToCurrencyString: _offer.amount];

  // NSMutableAttributedString *rentAttributedString = 
  //   [[NSMutableAttributedString alloc] initWithString: 
  //     [NSString numberToCurrencyString: (int) _offer.amount] attributes: @{
  //       NSFontAttributeName: [UIFont fontWithName: @"HelveticaNeue-Medium" 
  //         size: 15],
  //       NSForegroundColorAttributeName: [UIColor pink]
  //     }
  //   ];
  // if ([_offer.residence.address length]) {
  //   NSMutableAttributedString *addressAttributedString = 
  //     [[NSMutableAttributedString alloc] initWithString: 
  //       _offer.residence.address attributes: @{
  //         NSFontAttributeName: [UIFont fontWithName: @"HelveticaNeue-Light" 
  //           size: 15],
  //         NSForegroundColorAttributeName: [UIColor textColor]
  //       }
  //     ];
  //   NSMutableAttributedString *spacesString = 
  //     [[NSMutableAttributedString alloc] initWithString: @"   "];
  //   [rentAttributedString appendAttributedString: spacesString];
  //   [rentAttributedString appendAttributedString: addressAttributedString];
  // }
  // rentLabel.attributedText = rentAttributedString;
}

- (void) loadOfferForRenter: (OMBOffer *) object
{
  _offer = object;

  // Image
  if (![_offer.residence coverPhoto]) {
    [userImageView clearImage];
  }
  NSString *sizeKey = [NSString stringWithFormat: @"%f,%f",
    userImageView.bounds.size.width, userImageView.bounds.size.height];
  UIImage *image = [_offer.residence coverPhotoForSizeKey: sizeKey];
  if (image) {
    userImageView.image = image;
  }
  else {
    [_offer.residence downloadCoverPhotoWithCompletion: ^(NSError *error) {
      if ([_offer.residence coverPhoto]) {
        userImageView.image = [_offer.residence coverPhoto];
        [_offer.residence.coverPhotoSizeDictionary setObject: 
          userImageView.image forKey: sizeKey];
      }
    }];
  }

  // Time
  timeLabel.text = [NSString timeAgoInShortFormatWithTimeInterval:
    _offer.createdAt];
  timeLabel.textColor = [UIColor grayMedium];
  timeLabel.hidden = YES;
  // Title
  nameLabel.text = _offer.residence.title;
  // Status
  UIColor *color;
  NSString *status;
  if (_offer.onHold) {
    color = [UIColor grayMedium];
    status = @"on hold";
  }
  else if (_offer.confirmed) {
    color = [UIColor grayMedium];
    status = @"confirmed";
  }
  else if (_offer.rejected) {
    color = [UIColor grayMedium];
    status = @"rejected";
  }
  else if (_offer.accepted) {
    color = [UIColor green];
    status = @"accepted";
  }
  else if (_offer.declined) {
    color = [UIColor red];
    status = @"declined";
  }
  else {
    color = [UIColor yellow];
    status = @"pending";
  }
  typeLabel.text = status;
  typeLabel.textColor = color;
  // Address
  addressLabel.text = [_offer.residence.address capitalizedString];
  // Rent
  rentLabel.text = [NSString numberToCurrencyString: _offer.amount];
  
  // NSMutableAttributedString *rentAttributedString = 
  //   [[NSMutableAttributedString alloc] initWithString: 
  //     [NSString numberToCurrencyString: (int) _offer.amount] attributes: @{
  //       NSFontAttributeName: [UIFont fontWithName: @"HelveticaNeue-Medium" 
  //         size: 15],
  //       NSForegroundColorAttributeName: [UIColor textColor]
  //     }
  //   ];
  // if ([_offer.residence.address length]) {
  //   NSMutableAttributedString *addressAttributedString = 
  //     [[NSMutableAttributedString alloc] initWithString: 
  //       _offer.residence.address attributes: @{
  //         NSFontAttributeName: [UIFont fontWithName: @"HelveticaNeue-Light" 
  //           size: 15],
  //         NSForegroundColorAttributeName: [UIColor grayMedium]
  //       }
  //     ];
  //   NSMutableAttributedString *spacesString = 
  //     [[NSMutableAttributedString alloc] initWithString: @"   "];
  //   [rentAttributedString appendAttributedString: spacesString];
  //   [rentAttributedString appendAttributedString: addressAttributedString];
  // }
  // rentLabel.attributedText = rentAttributedString;
}

@end
