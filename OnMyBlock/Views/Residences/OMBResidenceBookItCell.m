//
//  OMBResidenceBookItCell.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/21/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBResidenceBookItCell.h"

#import "UIColor+Extensions.h"

@implementation OMBResidenceBookItCell

#pragma mark - Initializer

- (id) initWithStyle: (UITableViewCellStyle) style 
reuseIdentifier: (NSString *) reuseIdentifier
{
  if (!(self = [super initWithStyle: style 
    reuseIdentifier: reuseIdentifier])) return nil;
  
  self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

  CGRect screen = [[UIScreen mainScreen] bounds];
  CGFloat screenWidth = screen.size.width;

  CGFloat padding = 20.0f;
  // CGFloat height  = (padding * 0.5) + 27.0f + 22.0f + 22.0f +
  //   (padding * 0.5);

  _titleLabel = [[UILabel alloc] init];
  _titleLabel.font = [UIFont fontWithName: @"HelveticaNeue-Light" size: 27];
  _titleLabel.frame = CGRectMake(padding, padding, screenWidth - (padding * 2),
    36.0f);
  _titleLabel.textColor = [UIColor blue];
  [self.contentView addSubview: _titleLabel];

  _offerLabel = [[UILabel alloc] init];
  _offerLabel.font = [UIFont fontWithName: @"HelveticaNeue-Medium" size: 18];
  _offerLabel.frame = CGRectMake(padding, 
    _titleLabel.frame.origin.y + _titleLabel.frame.size.height, 
      _titleLabel.frame.size.width, 27.0f);
  _offerLabel.textColor = [UIColor grayDark];
  [self.contentView addSubview: _offerLabel];

  _descriptionLabel = [[UILabel alloc] init];
  _descriptionLabel.font = [UIFont fontWithName: @"HelveticaNeue-Light"
    size: 15];
  _descriptionLabel.frame = CGRectMake(_offerLabel.frame.origin.x,
    _offerLabel.frame.origin.y + _offerLabel.frame.size.height + 
    (padding * 0.5f),
      _offerLabel.frame.size.width, 22.0f * 3);
  _descriptionLabel.numberOfLines = 0;
  _descriptionLabel.textColor = [UIColor grayMedium];
  [self.contentView addSubview: _descriptionLabel];

  return self;
}

#pragma mark - Methods

#pragma mark - Class Methods

+ (CGFloat) heightForCell
{
  CGFloat padding = 20.0f;
  return padding + 36.0f + 27.0f + (padding * 0.5) + (22.0f * 3) + padding;
}

#pragma mark - Instance Methods

- (void) setPlaceOfferText
{
  _titleLabel.text = @"Place Offer";
  NSMutableParagraphStyle *pStyle = [[NSMutableParagraphStyle alloc] init];
  pStyle.maximumLineHeight = 22.0f;
  pStyle.minimumLineHeight = 22.0f;
  NSString *text = @"You are placing an offer on monthly rent.\n"
    @"Your offer can be higher or lower than the current offer.";
  NSMutableAttributedString *aString = 
    [[NSMutableAttributedString alloc] initWithString: text attributes: @{
      NSParagraphStyleAttributeName: pStyle
    }
  ];
  _descriptionLabel.attributedText = aString;
}

- (void) setRentItNowText
{
  _titleLabel.text = @"Rent it Now";
  NSMutableParagraphStyle *pStyle = [[NSMutableParagraphStyle alloc] init];
  pStyle.maximumLineHeight = 22.0f;
  pStyle.minimumLineHeight = 22.0f;
  NSString *text = @"Get this place for the rent it now price.\n"
    @"You will receive a confirmation from the seller within 24 hours.";
  NSMutableAttributedString *aString = 
    [[NSMutableAttributedString alloc] initWithString: text attributes: @{
      NSParagraphStyleAttributeName: pStyle
    }
  ];
  _descriptionLabel.attributedText = aString;
}

@end
