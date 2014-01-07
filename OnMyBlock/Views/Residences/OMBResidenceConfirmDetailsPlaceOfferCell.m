//
//  OMBResidenceConfirmDetailsPlaceOfferCell.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/23/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBResidenceConfirmDetailsPlaceOfferCell.h"

#import "NSString+Extensions.h"
#import "TextFieldPadding.h"
#import "UIColor+Extensions.h"

@implementation OMBResidenceConfirmDetailsPlaceOfferCell

#pragma mark - Initializer

- (id) initWithStyle: (UITableViewCellStyle) style 
reuseIdentifier: (NSString *)reuseIdentifier
{
  if (!(self = [super initWithStyle: style reuseIdentifier: reuseIdentifier])) 
    return nil;

  self.selectionStyle = UITableViewCellSelectionStyleNone;

  CGRect screen = [[UIScreen mainScreen] bounds];

  CGFloat screeWidth = screen.size.width;

  CGFloat padding = 20.0f;

  UILabel *yourOfferLabel = [[UILabel alloc] init];
  yourOfferLabel.font = [UIFont fontWithName: @"HelveticaNeue-Light" size: 27];
  yourOfferLabel.frame = CGRectMake(padding, padding, 0.0f, 36.0f);
  yourOfferLabel.text = @"Your offer:";
  yourOfferLabel.textColor = [UIColor textColor];
  CGRect yourOfferLabelRect = [yourOfferLabel.text boundingRectWithSize:
    CGSizeMake(yourOfferLabel.frame.size.width, 
      yourOfferLabel.frame.size.height) font: yourOfferLabel.font];
  yourOfferLabel.frame = CGRectMake(yourOfferLabel.frame.origin.x,
    yourOfferLabel.frame.origin.y, yourOfferLabelRect.size.width,
      yourOfferLabel.frame.size.height);
  [self.contentView addSubview: yourOfferLabel];

  _yourOfferTextField = [[TextFieldPadding alloc] init];
  _yourOfferTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
  _yourOfferTextField.font = yourOfferLabel.font;
  _yourOfferTextField.frame = CGRectMake(
    yourOfferLabel.frame.origin.x + yourOfferLabel.frame.size.width + padding, 
      yourOfferLabel.frame.origin.y, screeWidth - 
      (padding + yourOfferLabel.frame.size.width + padding + padding), 
        yourOfferLabel.frame.size.height);
  _yourOfferTextField.keyboardType = UIKeyboardTypeDecimalPad;
  _yourOfferTextField.leftViewMode = UITextFieldViewModeAlways;
  _yourOfferTextField.placeholderColor = [UIColor blueDarkAlpha: 0.5f];
  _yourOfferTextField.textColor = [UIColor blueDark];
  [self.contentView addSubview: _yourOfferTextField];
  CALayer *underline = [CALayer layer];
  underline.backgroundColor = [UIColor textColor].CGColor;
  underline.frame = CGRectMake(0.0f, 
    _yourOfferTextField.frame.size.height - 1.0f, 
      _yourOfferTextField.frame.size.width, 1.0f);
  [_yourOfferTextField.layer addSublayer: underline];
  // Dollar sign next to text field
  UILabel *moneyLabel = [UILabel new];
  moneyLabel.font = _yourOfferTextField.font;
  moneyLabel.text = @"$";
  moneyLabel.textColor = _yourOfferTextField.textColor;
  CGRect moneyLabelRect = [moneyLabel.text boundingRectWithSize: 
    CGSizeMake(_yourOfferTextField.frame.size.width, 
      _yourOfferTextField.frame.size.height) font: moneyLabel.font];
  moneyLabel.frame = CGRectMake(0.0f, 0.0f, 
    moneyLabelRect.size.width, _yourOfferTextField.frame.size.height);
  _yourOfferTextField.leftView = moneyLabel;
  _yourOfferTextField.paddingX = moneyLabel.frame.size.width;

  UILabel *info = [[UILabel alloc] init];
  info.font = [UIFont fontWithName: @"HelveticaNeue-Light" size: 15];
  info.frame = CGRectMake(yourOfferLabel.frame.origin.x,
    _yourOfferTextField.frame.origin.y + 
    _yourOfferTextField.frame.size.height + padding,
      screeWidth - (padding * 2), 22.0f);
  info.text = @"Your offer can be higher or lower.";
  info.textColor = [UIColor grayMedium];
  [self.contentView addSubview: info];

  CALayer *bottomBorder = [CALayer layer];
  bottomBorder.backgroundColor = [UIColor grayLight].CGColor;
  bottomBorder.frame = CGRectMake(0.0f, 
    (info.frame.origin.y + info.frame.size.height + padding) - 0.5f,
      screeWidth, 0.5f);
  [self.contentView.layer addSublayer: bottomBorder];

  return self;
}

#pragma mark - Methods

#pragma mark - Class Methods

+ (CGFloat) heightForCell
{
  CGFloat padding = 20.0f;
  return padding + 36.0f + padding + 22.0f  + padding;
}

@end
