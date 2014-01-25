//
//  OMBFinishListingRentItNowPriceCell.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/29/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBFinishListingRentItNowPriceCell.h"

@implementation OMBFinishListingRentItNowPriceCell

#pragma mark - Initializer

- (id) initWithStyle: (UITableViewCellStyle) style 
reuseIdentifier: (NSString *) reuseIdentifier
{
  if (!(self = [super initWithStyle: style reuseIdentifier: reuseIdentifier])) 
    return nil;

  self.selectionStyle = UITableViewCellSelectionStyleNone;

  CGRect screen       = [[UIScreen mainScreen] bounds];
  CGFloat screenWidth = screen.size.width;
  CGFloat padding     = 20.0f;

  CGFloat labelHeight = 44.0f;
  UILabel *label = [UILabel new];
  label.font = [UIFont fontWithName: @"HelveticaNeue-Light" size: 15];
  label.text = @"Security Deposit";
  // label.text = @"Rent it Now Price";
  label.textColor = [UIColor textColor];
  CGRect labelRect = [label.text boundingRectWithSize: 
    CGSizeMake(screenWidth, labelHeight) font: label.font];
  label.frame = CGRectMake(padding, padding, labelRect.size.width, labelHeight);
  [self.contentView addSubview: label];

  CGFloat textFieldWidth = screenWidth - 
    (padding + label.frame.size.width + padding + padding);
  _textField = [[TextFieldPadding alloc] init];
  _textField.font = [UIFont fontWithName: @"HelveticaNeue-Medium" size: 15];
  _textField.frame = CGRectMake(screenWidth - (textFieldWidth + padding),
    padding, textFieldWidth, label.frame.size.height);
  _textField.keyboardType = UIKeyboardTypeDecimalPad;
  _textField.layer.borderColor = [UIColor grayLight].CGColor;
  _textField.layer.borderWidth = 1.0f;
  _textField.layer.cornerRadius = 5.0f;
  // Left view
  UILabel *leftView = [UILabel new];
  leftView.font = _textField.font;
  leftView.text = @"$";
  leftView.textAlignment = NSTextAlignmentCenter;
  leftView.textColor = [UIColor grayMedium];
  CGSize maxSize = CGSizeMake(_textField.frame.size.width, 
    _textField.frame.size.height);
  CGRect leftViewRect = [leftView.text boundingRectWithSize: maxSize
    font: leftView.font];
  leftView.frame = CGRectMake(0.0f, 0.0f, 
    (padding * 0.5) + leftViewRect.size.width + (padding * 0.5),
      leftViewRect.size.height);
  _textField.leftView = leftView;
  _textField.leftViewMode = UITextFieldViewModeAlways;
  // Right view
  UILabel *rightView = [UILabel new];
  rightView.font = leftView.font;
  rightView.text = @"/ mo";
  rightView.textAlignment = leftView.textAlignment;
  rightView.textColor = leftView.textColor;
  CGRect rightViewRect = [rightView.text boundingRectWithSize: maxSize
    font: rightView.font];
  rightView.frame = CGRectMake(0.0f, 0.0f, 
    (padding * 0.5) + rightViewRect.size.width + (padding * 0.5),
      rightViewRect.size.height);
  _textField.leftPaddingX = leftView.frame.size.width;
  _textField.rightPaddingX = rightView.frame.size.width;
  // _textField.rightView = rightView;
  _textField.rightViewMode = _textField.leftViewMode;
  _textField.textColor = [UIColor blueDark];
  [self.contentView addSubview: _textField];

  return self;
}

#pragma mark - Methods

#pragma mark - Class Methods

+ (CGFloat) heightForCell
{
  CGFloat labelHeight = 44.0f;
  CGFloat padding     = 20.0f;
  return padding + labelHeight + padding;
}

@end
