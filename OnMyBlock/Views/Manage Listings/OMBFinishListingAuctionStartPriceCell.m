//
//  OMBFinishListingAuctionStartPriceCell.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/29/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBFinishListingAuctionStartPriceCell.h"

@implementation OMBFinishListingAuctionStartPriceCell

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

  // UIView *borderTop = [UIView new];
  // borderTop.backgroundColor = [UIColor grayLight];
  // borderTop.frame = CGRectMake(0.0f, 0.0f, screenWidth, 0.5f);
  // [self.contentView addSubview: borderTop];

  CGFloat labelHeight = 58.0f;
  UILabel *label = [UILabel new];
  label.font = [UIFont fontWithName: @"HelveticaNeue-Light" size: 18];
  label.text = @"Rent Price";
  // label.text = @"Starting Price";
  label.textColor = [UIColor textColor];
  CGRect labelRect = [label.text boundingRectWithSize:
    CGSizeMake(screenWidth, labelHeight) font: label.font];
  label.frame = CGRectMake(padding, padding, labelRect.size.width, labelHeight);
  [self.contentView addSubview: label];

  CGFloat textFieldWidth = screenWidth -
    (padding + label.frame.size.width + padding + padding);
  _textField = [[TextFieldPadding alloc] init];
  // _textField.backgroundColor = [UIColor grayVeryLight];
  _textField.font = [UIFont fontWithName: @"HelveticaNeue-Medium" size: 18];
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
  _textField.rightView = rightView;
  _textField.rightViewMode = _textField.leftViewMode;
  _textField.textColor = [UIColor blueDark];
  [self.contentView addSubview: _textField];

  CGFloat noteLabelViewWidth = screenWidth - (padding * 2);
  UIView *noteLabelView = [UIView new];
  noteLabelView.layer.borderColor = [UIColor blue].CGColor;
  noteLabelView.layer.borderWidth = 0.5f;
  noteLabelView.layer.cornerRadius = 5.0f;
  [self.contentView addSubview: noteLabelView];

  CGFloat noteLabelPadding = padding * 0.3f;
  CGFloat noteLabelWidth = noteLabelViewWidth - (noteLabelPadding * 2);
  UILabel *noteLabel = [UILabel new];
  noteLabel.font = [UIFont fontWithName: @"HelveticaNeue-Light" size: 13];
  noteLabel.numberOfLines = 0;
  // noteLabel.text =
  //   @"Start at a low price to attract more renters.";
  noteLabel.text = @"This price will be for the monthly rent";
  noteLabel.textColor = [UIColor blue];
  CGRect noteLabelRect = [noteLabel.text boundingRectWithSize: CGSizeMake(
    noteLabelWidth, 9999) font: noteLabel.font];
  noteLabel.frame = CGRectMake(noteLabelPadding, noteLabelPadding,
    noteLabelRect.size.width, 19);
  [noteLabelView addSubview: noteLabel];

  CGFloat newNoteLabelViewWidth =
    noteLabelPadding + noteLabel.frame.size.width + noteLabelPadding;
  noteLabelView.frame = CGRectMake(
    screenWidth - (newNoteLabelViewWidth + padding),
      label.frame.origin.y + label.frame.size.height + (padding * 0.5),
        newNoteLabelViewWidth,
          noteLabelPadding + noteLabel.frame.size.height + noteLabelPadding);

  return self;
}

#pragma mark - Methods

#pragma mark - Class Methods

+ (CGFloat) heightForCell
{
  CGFloat labelHeight = 58.0f;
  CGFloat padding = 20.0f;
  CGFloat noteLabelPadding = padding * 0.3f;
  return padding + labelHeight +
    (padding * 0.5) + noteLabelPadding + 19 + noteLabelPadding + padding;
}

@end
