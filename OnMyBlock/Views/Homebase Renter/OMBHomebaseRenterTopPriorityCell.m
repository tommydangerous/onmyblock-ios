//
//  OMBHomebaseRenterTopPriorityCell.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 1/6/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBHomebaseRenterTopPriorityCell.h"

#import "OMBOffer.h"
#import "OMBResidence.h"
#import "UIImage+Color.h"
#import "UIImage+Resize.h"

@implementation OMBHomebaseRenterTopPriorityCell

#pragma mark - Initializer

- (id) initWithStyle: (UITableViewCellStyle) style 
reuseIdentifier: (NSString *) reuseIdentifier
{
  if (!(self = [super initWithStyle: style reuseIdentifier: reuseIdentifier])) 
    return nil;

  self.selectionStyle = UITableViewCellSelectionStyleNone;

  CGRect screen = [[UIScreen mainScreen] bounds];
  CGFloat padding = 20.0f;
  CGFloat width = (screen.size.width - (padding * 2));

  dateTimeLabel = [UILabel new];
  dateTimeLabel.font = [UIFont fontWithName: @"HelveticaNeue-Light" size: 13];
  dateTimeLabel.frame = CGRectMake(topLabel.frame.origin.x,
    topLabel.frame.origin.y, topLabel.frame.size.width, 
      topLabel.frame.size.height);
  dateTimeLabel.textAlignment = NSTextAlignmentRight;
  dateTimeLabel.textColor = [UIColor grayMedium];
  [self.contentView addSubview: dateTimeLabel];

  _noButton = [UIButton new];
  _noButton.clipsToBounds = YES;
  _noButton.frame = CGRectMake(padding,
    middleLabel.frame.origin.y + middleLabel.frame.size.height + 
    padding, width * 0.3f, 10 + 15.0f + 10);
  _noButton.layer.borderColor = [UIColor red].CGColor;
  _noButton.layer.borderWidth = 1.0f;
  _noButton.layer.cornerRadius = 5.0f;
  _noButton.titleLabel.font = [UIFont fontWithName: @"HelveticaNeue-Light" 
    size: 15];
  [_noButton setBackgroundImage: [UIImage imageWithColor: [UIColor red]]
    forState: UIControlStateHighlighted];
  [_noButton setTitle: @"Decline" forState: UIControlStateNormal];
  [_noButton setTitleColor: [UIColor red] forState: UIControlStateNormal];
  [_noButton setTitleColor: [UIColor whiteColor] 
    forState: UIControlStateHighlighted];
  [self.contentView addSubview: _noButton];

  CGFloat _yesButtonWidth = width - (_noButton.frame.size.width + padding);
  _yesButton = [UIButton new];
  _yesButton.clipsToBounds = _noButton.clipsToBounds;
  _yesButton.frame = CGRectMake(_noButton.frame.origin.x + 
    _noButton.frame.size.width + padding, _noButton.frame.origin.y, 
      _yesButtonWidth, _noButton.frame.size.height);
  _yesButton.layer.borderColor = [UIColor green].CGColor;
  _yesButton.layer.borderWidth = _noButton.layer.borderWidth;
  _yesButton.layer.cornerRadius = _noButton.layer.cornerRadius;
  _yesButton.titleLabel.font = _noButton.titleLabel.font;
  [_yesButton setBackgroundImage: [UIImage imageWithColor: [UIColor green]]
    forState: UIControlStateHighlighted];
  [_yesButton setTitle: @"Confirm Payment" // @"Confirm Rent & Deposit"
    forState: UIControlStateNormal];
  [_yesButton setTitleColor: [UIColor green] forState: UIControlStateNormal];
  [_yesButton setTitleColor: [UIColor whiteColor] 
    forState: UIControlStateHighlighted];
  [self.contentView addSubview: _yesButton];

  return self;
}

#pragma mark - Methods

#pragma mark - Class Methods

+ (CGFloat) heightForCell
{
  CGFloat padding = 20.0f;
  return padding + 22.0f + 22.0f + padding + (10 + 15.0f + 10) + padding;
}

#pragma mark - Instance Methods

- (void) loadOffer: (OMBOffer *) offer
{
  // Date accepted
  dateTimeLabel.text = [NSString timeAgoInShortFormatWithTimeInterval:
    offer.acceptedDate];
  // Image
  CGSize size = objectImageView.frame.size;
  NSString *sizeKey = [NSString stringWithFormat: @"%f,%f", 
    size.width, size.height];
  void (^completionBlock) (NSError *error) = ^(NSError *error) {
    objectImageView.image = [offer.residence coverPhoto];
    [offer.residence.coverPhotoSizeDictionary setObject: objectImageView.image
      forKey: sizeKey];
  };
  if ([offer.residence coverPhoto]) {
    UIImage *image = [offer.residence coverPhotoForSize: size];
    if (!image) {
      completionBlock(nil);
    }
    else {
      objectImageView.image = image;
    }
  }
  else {
    [offer.residence downloadCoverPhotoWithCompletion: ^(NSError *error) {
      completionBlock(error);
    }];
  }
  // Offer accepted
  topLabel.text = [NSString stringWithFormat: @"Offer accepted: %@",
    [NSString numberToCurrencyString: (int) offer.amount]];
  // Address
  middleLabel.text = [offer.residence.address capitalizedString];
}

@end
