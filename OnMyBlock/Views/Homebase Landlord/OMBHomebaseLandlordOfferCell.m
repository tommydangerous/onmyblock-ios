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
#import "OMBViewController.h"
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
  CGFloat padding     = OMBPadding;

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
  timeLabel.font = [UIFont smallTextFontBold];
  timeLabel.frame = CGRectMake(userImageView.frame.origin.x + 
    userImageView.frame.size.width + padding, padding, width, 22.0f);
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
  addressLabel.font = [UIFont normalTextFont];
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

  // Type
  typeLabel = [UILabel new];
  typeLabel.font = [UIFont normalTextFont];
  typeLabel.frame = rentLabel.frame;
  typeLabel.textAlignment = NSTextAlignmentLeft;
  [self.contentView addSubview: typeLabel];

  // Notes
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

  countdownTimer = [NSTimer timerWithTimeInterval: 1 target: self
    selector: @selector(timerFireMethod:) userInfo: nil repeats: YES];
  // NSRunLoopCommonModes, mode used for tracking events
  [[NSRunLoop currentRunLoop] addTimer: countdownTimer
    forMode: NSRunLoopCommonModes];

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
  return [OMBHomebaseLandlordOfferCell heightForCell] + padding + (17.0f * 3);
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
  NSDate *moveOutDate = [_offer.residence moveOutDateDate];
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
  timeLabel.hidden = YES;
  [self updateTimeLabel];

  // Note
  notesLabel.hidden = YES;
  notesLabel.text = @"";

  // Name
  nameLabel.text = [_offer.user shortName];
  
  // Status
  UIColor *color;
  switch ([_offer statusForLandlord]) {
    case OMBOfferStatusForLandlordRejected: {
      color = [UIColor red];
      break;
    }
    case OMBOfferStatusForLandlordConfirmed: {
      color = [UIColor green];
      break;
    }
    case OMBOfferStatusForLandlordAccepted: {
      color = [UIColor yellow];
      notesLabel.hidden = NO;
      notesLabel.text = @"The student has 48 hours to confirm the place "
        @"by signing the lease and paying the 1st month's rent and deposit";
      timeLabel.hidden = NO;
      break;
    }
    case OMBOfferStatusForLandlordOnHold: {
      color = [UIColor grayMedium];
      notesLabel.hidden = NO;
      notesLabel.text = [NSString stringWithFormat: 
        @"This offer will become live if the previously accepted offer for "
        @"%@ is rejected by the student who made the offer.", 
          [_offer.residence.address capitalizedString]];
      break;
    }
    case OMBOfferStatusForLandlordDeclined: {
      color = [UIColor grayMedium];
      break;
    }
    case OMBOfferStatusForLandlordResponseRequired: {
      color = [UIColor orange];
      notesLabel.hidden = NO;
      notesLabel.text = @"Once you have reviewed the offer and the student's "
        @"renter profile, please accept or decline the offer.";
      timeLabel.hidden = NO;
      break;
    }
    case OMBOfferStatusForStudentExpired: {
      color = [UIColor grayMedium];
      break;
    }
    default:
      break;
  }
  typeLabel.text = [_offer statusStringForLandlord];
  typeLabel.textColor = color;

  // Address
  addressLabel.text = [NSString stringWithFormat: @"%@ - %@",
    [NSString numberToCurrencyString: _offer.amount],
      [_offer.residence.address capitalizedString]];
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

  nameLabel.text = [_offer.residence.user shortName];

  // Time
  timeLabel.hidden = YES;
  [self updateTimeLabel];

  // Note
  notesLabel.hidden = YES;
  notesLabel.text = @"";

  // Status
  UIColor *color;
  switch ([_offer statusForStudent]) {
    case OMBOfferStatusForStudentRejected: {
      color = [UIColor red];
      break;
    }
    case OMBOfferStatusForStudentConfirmed: {
      color = [UIColor green];
      break;
    }
    case OMBOfferStatusForStudentAccepted: {
      color = [UIColor orange];
      notesLabel.hidden = NO;
      notesLabel.text = @"You have 48 hours to confirm or reject. You may "
        @"confirm the place by signing the lease and paying the 1st month's "
        @"rent and deposit.";
      timeLabel.hidden = NO;
      break;
    }
    case OMBOfferStatusForStudentOnHold: {
      color = [UIColor grayMedium];
      notesLabel.hidden = NO;
      notesLabel.text = @"The landlord has accepted another offer. If that "
        @"student does not pay and sign the lease within 48 hours, your offer "
        @"will be live.";
      break;
    }
    case OMBOfferStatusForStudentDeclined: {
      color = [UIColor grayMedium];
      break;
    }
    case OMBOfferStatusForStudentWaitingForLandlordResponse: {
      color = [UIColor yellow];
      notesLabel.hidden = NO;
      notesLabel.text = @"The landlord will have 24 hours to either accept or "
        @"decline your offer after reviewing your renter profile and offer.";
      timeLabel.hidden = NO;
      break;
    }
    case OMBOfferStatusForStudentExpired: {
      color = [UIColor grayMedium];
      break;
    }
    default:
      break;
  }
  typeLabel.text = [_offer statusStringForStudent];
  typeLabel.textColor = color;

  // Address
  // addressLabel.text = [_offer.residence.address capitalizedString];
  addressLabel.text = [NSString stringWithFormat: @"%@ - %@",
    [NSString numberToCurrencyString: _offer.amount],
      [_offer.residence.address capitalizedString]];
}

- (void) timerFireMethod: (NSTimer *) timer
{
  [self updateTimeLabel];
}

- (void) updateTimeLabel
{
  NSInteger timeLeft = 0;
  timeLabel.textColor = [UIColor blueDark];
  // Waiting for the student
  if (_offer.accepted && !_offer.rejected && !_offer.confirmed) {
    timeLeft = [_offer timeLeftForStudent];
    if (timeLeft > 0) {
      timeLabel.text = [_offer timeLeftStringForStudent];
    }
    else {
      timeLabel.text = [NSString timeAgoInShortFormatWithTimeInterval:
        _offer.acceptedDate];
      timeLabel.textColor = [UIColor grayMedium];
    }
    if ([_offer timeLeftPercentageForStudent] < 0.1f) {
      timeLabel.textColor = [UIColor red];
    }
  }
  // Landlord response required
  else {
    timeLeft = [_offer timeLeftForLandlord];
    if (timeLeft > 0) {
      timeLabel.text = [_offer timeLeftStringForLandlord];
    }
    else {
      timeLabel.text = [NSString timeAgoInShortFormatWithTimeInterval:
        _offer.createdAt];
      timeLabel.textColor = [UIColor grayMedium];
    }
    if ([_offer timeLeftPercentageForLandlord] < 0.1f) {
      timeLabel.textColor = [UIColor red];
    }
  }
}

@end
