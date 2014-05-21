//
//  OMBSentApplicationCell.m
//  OnMyBlock
//
//  Created by Paul Aguilar on 5/21/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBSentApplicationCell.h"

#import "NSString+Extensions.h"
#import "OMBCenteredImageView.h"
#import "OMBResidence.h"
#import "OMBUser.h"
#import "OMBViewController.h"
#import "UIFont+OnMyBlock.h"

@implementation OMBSentApplicationCell

#pragma mark - Initializer

- (id) initWithStyle: (UITableViewCellStyle) style
     reuseIdentifier: (NSString *) reuseIdentifier
{
  if (!(self = [super initWithStyle: style reuseIdentifier: reuseIdentifier]))
    return nil;
  
  self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
  
  CGRect screen       = [[UIScreen mainScreen] bounds];
  CGFloat screenWidth = screen.size.width;
  CGFloat padding     = OMBPadding;
  
  // Image
  CGFloat imageSize = 22.0f + 22.0f + 22.0f;
  userImageView = [[OMBCenteredImageView alloc] init];
  userImageView.frame = CGRectMake(padding, padding, imageSize, imageSize);
  userImageView.layer.cornerRadius = imageSize * 0.5f;
  [self.contentView addSubview: userImageView];
  
  CGFloat width = screenWidth - (userImageView.frame.origin.x +
    userImageView.frame.size.width + padding + padding);
  
  // Name; James J.
  nameLabel = [UILabel new];
  nameLabel.font = [UIFont normalTextFontBold];
  nameLabel.frame = CGRectMake(userImageView.frame.origin.x +
    userImageView.frame.size.width + padding,
      padding, width, 22.0f);
  nameLabel.textColor = [UIColor textColor];
  [self.contentView addSubview: nameLabel];
  
  // Address; $400 - 8230 Costa Verde Blvd
  addressLabel = [UILabel new];
  addressLabel.font = [UIFont normalTextFont];
  // Minus another padding to not run into the disclosure indicator
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
  rentLabel.textColor = [UIColor blueDark];
  // [self.contentView addSubview: rentLabel];
  
  // Type; status: e.g. response required
  typeLabel = [UILabel new];
  typeLabel.font = [UIFont normalTextFont];
  typeLabel.frame = rentLabel.frame;
  typeLabel.textAlignment = NSTextAlignmentLeft;
  [self.contentView addSubview: typeLabel];
  
  // Notes; long descriptions
  notesLabel = [UILabel new];
  notesLabel.font = [UIFont smallTextFont];
  notesLabel.hidden = YES;
  notesLabel.numberOfLines = 0;
  notesLabel.textColor = [UIColor grayMedium];
  // 17 = line height of font size 13
  notesLabel.frame = CGRectMake(padding,
    typeLabel.frame.origin.y + typeLabel.frame.size.height,
      screenWidth - (padding * 2), padding + (17.0f * 3));
  // notesLabel.textAlignment = NSTextAlignmentRight;
  [self.contentView addSubview: notesLabel];
  
  return self;
}

#pragma mark - Methods

#pragma mark - Class Methods

+ (CGFloat) heightForCell
{
  CGFloat padding = OMBPadding;
  return padding + 22.0f + 22.0f + 22.0f + padding;
}

+ (CGFloat) heightForCellWithNotes
{
  // 17 = line height of font size 13
  CGFloat padding = OMBPadding;
  return [OMBSentApplicationCell heightForCell] + padding * 0.5f + (17.0f * 3);
}

#pragma mark - Instance Methods

- (void) adjustFrames
{
  CGRect screen       = [[UIScreen mainScreen] bounds];
  CGFloat screenWidth = screen.size.width;
  CGFloat padding     = 20.0f;
  
  // Name
  CGFloat nameLabelOriginX = userImageView.frame.origin.x +
    userImageView.frame.size.width + padding;
  nameLabel.frame = CGRectMake(nameLabelOriginX, padding,
    screenWidth - (nameLabelOriginX + padding + nameLabel.frame.size.width + padding),
      22.0f);
  
  // Rent
  CGRect rentLabelRect = [rentLabel.text boundingRectWithSize:
    CGSizeMake(screenWidth, typeLabel.frame.size.height)
                                                         font: rentLabel.font];
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

- (void) adjustFramesWithoutImage
{
  CGRect screen       = [[UIScreen mainScreen] bounds];
  CGFloat screenWidth = screen.size.width;
  CGFloat padding     = 20.0f;
  
  // Name
  CGFloat addressOriginX = padding;
  addressLabel.frame = CGRectMake(addressOriginX, padding,
    screenWidth - padding, 22.0f);
  
  // Address
  CGRect nameLabelRect = addressLabel.frame;
  nameLabel.frame = CGRectMake(nameLabelRect.origin.x,
    nameLabelRect.origin.y + nameLabelRect.size.height,
      nameLabelRect.size.width, nameLabelRect.size.height);
  
  // Type Label
  CGRect typeLabelRect = nameLabel.frame;
  typeLabel.frame = CGRectMake(typeLabelRect.origin.x,
    typeLabelRect.origin.y + typeLabelRect.size.height,
      typeLabelRect.size.width, typeLabelRect.size.height);
}

- (void) loadInfo:(OMBSentApplication *)sentapp
{
  //
}

- (void) loadFakeInfo
{
  
  // Image
  userImageView.image = [[OMBUser currentUser] imageForSize: userImageView.frame.size];
  
  // Note
  notesLabel.hidden = YES;
  notesLabel.text = @"Once you have reviewed the applicant party’s "
  @"offer and renter profile(s), please accept or decline.";
  
  // Name
  nameLabel.text = [[OMBUser currentUser] shortName];
  
  // Status
  notesLabel.hidden = NO;
  notesLabel.text = [NSString stringWithFormat:
    @"This offer will become live if the previously accepted offer for "
    @"Lima - Peru is rejected by the student who made the offer."];
      
  typeLabel.text = @"Waiting for Landlord";
  typeLabel.textColor = [UIColor grayMedium];
  
  // Address
  addressLabel.text = [NSString stringWithFormat: @"%@ - %@",
    [NSString numberToCurrencyString: 12345],
      @"Lima-Peru"];
}

@end
