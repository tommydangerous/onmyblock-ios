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
#import "UIImageView+WebCache.h"

@implementation OMBHomebaseLandlordOfferCell

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
  // Time; countdown: 1d 23h 23m 12s
  timeLabel = [UILabel new];
  timeLabel.font = [UIFont smallTextFontBold];
  timeLabel.frame = CGRectMake(userImageView.frame.origin.x + 
    userImageView.frame.size.width + padding, padding, width, 22.0f);
  timeLabel.textAlignment = NSTextAlignmentRight;
  [self.contentView addSubview: timeLabel];
  
  // Name; James J.
  nameLabel = [UILabel new];
  nameLabel.font = [UIFont normalTextFontBold];
  nameLabel.frame = CGRectMake(timeLabel.frame.origin.x, 
    timeLabel.frame.origin.y, timeLabel.frame.size.width, 22.0f);
  nameLabel.textColor = [UIColor textColor];
  [self.contentView addSubview: nameLabel];

  // Address; $400 - 8230 Costa Verde Blvd
  addressLabel = [UILabel new];
  addressLabel.font = [UIFont normalTextFont];
  // Minus another padding to not run into the disclosure indicator
  addressLabel.frame = CGRectMake(nameLabel.frame.origin.x,
    nameLabel.frame.origin.y + nameLabel.frame.size.height,
      nameLabel.frame.size.width - padding, nameLabel.frame.size.height);
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

- (void) loadConfirmedTenant: (OMBOffer *) object
{
  _offer = object;
  [countdownTimer invalidate];
  
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

  // Time
  timeLabel.hidden = YES;

  // Address
  addressLabel.text = [NSString stringWithFormat: @"%@ - %@",
    [NSString numberToCurrencyString: _offer.amount],
      [_offer.residence.address capitalizedString]];

  // Dates
  NSDateFormatter *dateFormatter = [NSDateFormatter new];
  dateFormatter.dateFormat = @"M/d/yy";
  NSDate *moveInDate = [NSDate dateWithTimeIntervalSince1970: 
    _offer.residence.moveInDate];
  NSDate *moveOutDate = [_offer.residence moveOutDateDate];
  if (_offer.residence.moveOutDate)
    moveOutDate = [NSDate dateWithTimeIntervalSince1970:
      _offer.residence.moveOutDate];
  typeLabel.text = [NSString stringWithFormat: @"%@ - %@",
    [dateFormatter stringFromDate: moveInDate],
      [dateFormatter stringFromDate: moveOutDate]];
  typeLabel.textColor = [UIColor textColor];
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
    case OMBOfferStatusForLandlordRejected:
    case OMBOfferStatusForLandlordOfferPaidExpired: {
      color = [UIColor red];
      break;
    }
    case OMBOfferStatusForLandlordConfirmed:
    case OMBOfferStatusForLandlordOfferPaid: {
      color = [UIColor green];
      break;
    }
    case OMBOfferStatusForLandlordAccepted: {
      color = [UIColor orange];
      notesLabel.hidden = NO;
      notesLabel.text = [NSString stringWithFormat: @"Student has %i "
        @"hours to confirm, pay, and sign the lease. Once the lease has been "
        @"signed, we will send it to you via email.", 
          kMaxHoursForStudentToConfirm];
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
      color = [UIColor pink];
      notesLabel.hidden = NO;
      notesLabel.text = @"Once you have reviewed the offer and the student's "
        @"renter profile, please accept or decline the offer.";
      timeLabel.hidden = NO;
      break;
    }
    case OMBOfferStatusForLandlordExpired: {
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
  if (!_offer.residence.coverPhotoURL)
    [userImageView clearImage];

  NSString *sizeKey = [NSString stringWithFormat: @"%f,%f",
    userImageView.bounds.size.width, userImageView.bounds.size.height];
  UIImage *image = [_offer.residence coverPhotoForSizeKey: sizeKey];
  if (image) {
    userImageView.image = image;
  }
  else {
    __weak typeof(userImageView) weakUserImageView = userImageView;
    [_offer.residence downloadCoverPhotoWithCompletion: ^(NSError *error) {
      [weakUserImageView.imageView setImageWithURL: 
        _offer.residence.coverPhotoURL placeholderImage: nil 
          options: SDWebImageRetryFailed completed:
            ^(UIImage *img, NSError *error, SDImageCacheType cacheType) {
              weakUserImageView.image = img;
              [_offer.residence.coverPhotoSizeDictionary setObject: 
                weakUserImageView.image forKey: sizeKey];
            }
          ];
      // if ([_offer.residence coverPhoto]) {
      //   userImageView.image = [_offer.residence coverPhoto];
      //   [_offer.residence.coverPhotoSizeDictionary setObject: 
      //     userImageView.image forKey: sizeKey];
      // }
    }];
    userImageView.image = [OMBResidence placeholderImage];
  }

  // nameLabel.text = [_offer.residence.user shortName];
  // NSMutableAttributedString *aString1 = (NSMutableAttributedString *) 
  //   [[NSString numberToCurrencyString: 
  //     self.offer.amount] attributedStringWithFont: 
  //       [UIFont normalTextFontBold]];
  // NSMutableAttributedString *aString2 = (NSMutableAttributedString *) 
  //   [[NSString stringWithFormat: @" %i bd / %i ba", 
  //     (NSUInteger) self.offer.residence.bedrooms, 
  //       (NSUInteger) self.offer.residence.bathrooms] 
  //         attributedStringWithFont: [UIFont normalTextFont]];
  // [aString1 appendAttributedString: aString2];
  // nameLabel.attributedText = aString1;
  nameLabel.text = [NSString numberToCurrencyString: self.offer.amount];

  // Time
  timeLabel.hidden = YES;
  [self updateTimeLabel];

  // Note
  notesLabel.hidden = YES;
  notesLabel.text = @"";

  // Status
  UIColor *color;
  switch ([_offer statusForStudent]) {
    case OMBOfferStatusForStudentRejected:
    case OMBOfferStatusForStudentOfferPaidExpired: {
      color = [UIColor red];
      break;
    }
    case OMBOfferStatusForStudentConfirmed:
    case OMBOfferStatusForStudentOfferPaid: {
      color = [UIColor green];
      break;
    }
    case OMBOfferStatusForStudentAccepted: {
      color = [UIColor pink];
      notesLabel.hidden = NO;
      notesLabel.text = [NSString stringWithFormat:
        @"You have %@ to confirm or reject. "
        @"You may secure the place by signing the lease and "
        @"paying the 1st month's rent and deposit.",
        [self.offer timelineStringForStudent]
      ];
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
      color = [UIColor orange];
      notesLabel.hidden = NO;
      notesLabel.text = [NSString stringWithFormat:
        @"Once you submit your offer, the landlord will have %@ "
        @"to review your offer, your renter profile, and your roommates' "
        @"renter profiles if applicable.", 
        [self.offer timelineStringForLandlord]
      ];
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
  typeLabel.text = [[self.offer statusStringForStudent] capitalizedString];
  typeLabel.textColor = color;

  // Address
  // addressLabel.text = [_offer.residence.address capitalizedString];
  // addressLabel.text = [NSString stringWithFormat: @"%@ - %@",
  //   [NSString numberToCurrencyString: _offer.amount],
  //     [_offer.residence.address capitalizedString]];
  addressLabel.text = [self.offer.residence.address capitalizedString];
}

- (void) timerFireMethod: (NSTimer *) timer
{
  [self updateTimeLabel];
}

- (void) updateTimeLabel
{
  NSInteger timeLeft = 0;
  timeLabel.textColor = [UIColor blueDark];
  timeLabel.textColor = [UIColor blue];
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
