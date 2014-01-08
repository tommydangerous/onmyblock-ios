//
//  OMBHomebaseRenterTopPriorityCell.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 1/6/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBHomebaseRenterTopPriorityCell.h"

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
  dateTimeLabel.frame = CGRectMake(
    screen.size.width - ((padding * 2) + padding),
      topLabel.frame.origin.y, padding * 2, topLabel.frame.size.height);
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
  [_yesButton setTitle: @"Confirm Rent & Deposit"
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

- (void) loadData
{
  dateTimeLabel.text = @"5m";

  CGFloat imageSize = objectImageView.frame.size.width;
  UIImage *image = 
    [[OMBResidence fakeResidence].imageSizeDictionary objectForKey: 
      [NSNumber numberWithFloat: imageSize]];
  if (!image) {
    image = [UIImage image: [OMBResidence fakeResidence].coverPhoto 
      size: CGSizeMake(imageSize, imageSize)];
    [[OMBResidence fakeResidence].imageSizeDictionary setObject: image 
      forKey: [NSNumber numberWithFloat: imageSize]];
  }
  objectImageView.image = image;
  topLabel.text = @"Offer accepted: $1,575";
  middleLabel.text = @"2756 Costa Verde Blvd";
}

@end
