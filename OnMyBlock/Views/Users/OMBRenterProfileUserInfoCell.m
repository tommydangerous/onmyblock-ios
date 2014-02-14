//
//  OMBRenterProfileUserInfoCell.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 1/28/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBRenterProfileUserInfoCell.h"

#import "OMBUser.h"
#import "OMBViewController.h"
#import "UIFont+OnMyBlock.h"

@implementation OMBRenterProfileUserInfoCell

#pragma mark - Initializer

- (id) initWithStyle: (UITableViewCellStyle) style 
reuseIdentifier: (NSString *) reuseIdentifier
{
  if (!(self = [super initWithStyle: style reuseIdentifier: reuseIdentifier])) 
    return nil;

  self.selectionStyle = UITableViewCellSelectionStyleNone;

  _checkmarkImageView = [UIImageView new];
  [self.contentView addSubview: _checkmarkImageView];

  _iconImageView = [UIImageView new];
  [self.contentView addSubview: _iconImageView];

  _label = [UILabel new];
  [self.contentView addSubview: _label];

  _valueLabel = [UILabel new];
  [self.contentView addSubview: _valueLabel];

  return self;
}

#pragma mark - Methods

#pragma mark - Class Methods

+ (CGFloat) heightForCell
{
  return OMBPadding + 22.0f + OMBPadding;
}

+ (CGFloat) widthForLabel
{
  CGRect screen = [[UIScreen mainScreen] bounds];
  CGFloat screenWidth    = screen.size.width;
  CGFloat padding        = OMBPadding;
  CGFloat height = [OMBRenterProfileUserInfoCell heightForCell];
  return screenWidth - (padding + (height * 0.5f) + padding + padding);
}

#pragma mark - Instance Methods

- (void) fillCheckmark
{
  _checkmarkImageView.alpha = 1.0f;
  _checkmarkImageView.image = [UIImage imageNamed: 
    @"checkmark_outline_filled.png"];
}

- (void) loadUserAbout: (OMBUser *) object
{
  CGFloat padding = OMBPadding;

  if (object.about && [object.about length]) {
    _label.attributedText = [object.about attributedStringWithFont: _label.font
      lineHeight: 22.0f];
    _label.numberOfLines = 0;
    _label.frame = CGRectMake(_label.frame.origin.x, padding * 0.5f,
      _label.frame.size.width, [object heightForAboutTextWithWidth:
        _label.frame.size.width]);
    _label.textColor = [UIColor textColor];
  }
  else {
    if ([object isCurrentUser]) {
      _label.text = @"A little about you...";
    }
    else {
      _label.text = @"Nothing about me yet";
    }
    _label.textColor = [UIColor grayMedium];
  }
}

- (void) reset
{
  CGRect screen = [[UIScreen mainScreen] bounds];
  CGFloat screenWidth    = screen.size.width;
  CGFloat padding        = OMBPadding;
  CGFloat height = [OMBRenterProfileUserInfoCell heightForCell];

  CGFloat iconSize = height * 0.5f;
  _iconImageView.alpha = 0.3f;
  _iconImageView.frame = CGRectMake(padding, (height - iconSize) * 0.5f, 
    iconSize, iconSize);

  _label.font = [UIFont normalTextFont];
  _label.frame = CGRectMake(_iconImageView.frame.origin.x + 
    _iconImageView.frame.size.width + padding, padding, 
      screenWidth - (_iconImageView.frame.origin.x + 
      _iconImageView.frame.size.width + padding + padding), 22.0f);
  _label.textColor = [UIColor textColor];

  _valueLabel.font = [UIFont normalTextFontBold];
  _valueLabel.frame = _label.frame;
  _valueLabel.textColor = [UIColor blueDark];
  _valueLabel.textAlignment = NSTextAlignmentRight;

  _checkmarkImageView.hidden = YES;
}

- (void) resetWithCheckmark
{
  [self reset];

  CGRect screen = [[UIScreen mainScreen] bounds];

  CGFloat checkmarkSize = 20.0f;
  CGFloat padding = OMBPadding;
  CGFloat height = [OMBRenterProfileUserInfoCell heightForCell];

  _checkmarkImageView.alpha = 0.2f;
  _checkmarkImageView.frame = CGRectMake(
    screen.size.width - (checkmarkSize + padding), 
      (height - checkmarkSize) * 0.5f, checkmarkSize, checkmarkSize);
  _checkmarkImageView.hidden = NO;
  _checkmarkImageView.image = [UIImage imageNamed: @"checkmark_outline.png"];

  _valueLabel.frame = CGRectMake(_checkmarkImageView.frame.origin.x - 
    (_valueLabel.frame.size.width + padding), 
      _valueLabel.frame.origin.y, _valueLabel.frame.size.width,
        _valueLabel.frame.size.height);
}

@end
