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
  timeLabel.font = [UIFont fontWithName: @"HelveticaNeue-Light" size: 13];
  timeLabel.frame = CGRectMake(userImageView.frame.origin.x + 
    userImageView.frame.size.width + padding, padding, width, 15.0f);
  timeLabel.textAlignment = NSTextAlignmentRight;
  [self.contentView addSubview: timeLabel];
  
  // Name
  nameLabel = [UILabel new];
  nameLabel.font = [UIFont fontWithName: @"HelveticaNeue-Medium" size: 15];
  nameLabel.frame = CGRectMake(timeLabel.frame.origin.x, 
    timeLabel.frame.origin.y, timeLabel.frame.size.width, 22.0f);
  nameLabel.textColor = [UIColor textColor];
  [self.contentView addSubview: nameLabel];

  // Type
  typeLabel = [UILabel new];
  typeLabel.font = [UIFont fontWithName: @"HelveticaNeue-Light" size: 13];
  typeLabel.frame = CGRectMake(nameLabel.frame.origin.x,
    nameLabel.frame.origin.y + nameLabel.frame.size.height,
      nameLabel.frame.size.width, nameLabel.frame.size.height);
  typeLabel.textColor = [UIColor grayMedium];
  [self.contentView addSubview: typeLabel];

  // Rent
  rentLabel = [UILabel new];
  rentLabel.font = [UIFont fontWithName: @"HelveticaNeue-Medium" size: 15];
  rentLabel.frame = CGRectMake(typeLabel.frame.origin.x,
    typeLabel.frame.origin.y + typeLabel.frame.size.height,
      typeLabel.frame.size.width, typeLabel.frame.size.height);
  rentLabel.textColor = [UIColor pink];
  [self.contentView addSubview: rentLabel];

  // Address
  addressLabel = [UILabel new];
  addressLabel.font = [UIFont fontWithName: @"HelveticaNeue-Light" size: 15];
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

- (void) loadOffer: (OMBOffer *) object
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
  // Type / Tenants
  if (_offer.accepted) {
    typeLabel.text      = @"waiting on student";
    typeLabel.textColor = [UIColor grayMedium];
  }
  else {
    typeLabel.text      = @"response required";
    typeLabel.textColor = [UIColor red];
  }
  // Rent and address
  NSMutableAttributedString *rentAttributedString = 
    [[NSMutableAttributedString alloc] initWithString: 
      [NSString numberToCurrencyString: (int) _offer.amount] attributes: @{
        NSFontAttributeName: [UIFont fontWithName: @"HelveticaNeue-Medium" 
          size: 15],
        NSForegroundColorAttributeName: [UIColor pink]
      }
    ];
  if ([_offer.residence.address length]) {
    NSMutableAttributedString *addressAttributedString = 
      [[NSMutableAttributedString alloc] initWithString: 
        _offer.residence.address attributes: @{
          NSFontAttributeName: [UIFont fontWithName: @"HelveticaNeue-Light" 
            size: 15],
          NSForegroundColorAttributeName: [UIColor textColor]
        }
      ];
    NSMutableAttributedString *spacesString = 
      [[NSMutableAttributedString alloc] initWithString: @"   "];
    [rentAttributedString appendAttributedString: spacesString];
    [rentAttributedString appendAttributedString: addressAttributedString];
  }
  rentLabel.attributedText = rentAttributedString;
}

@end
