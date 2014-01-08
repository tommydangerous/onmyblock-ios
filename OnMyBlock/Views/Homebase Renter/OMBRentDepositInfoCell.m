//
//  OMBRentDepositInfoCell.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 1/7/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBRentDepositInfoCell.h"

@implementation OMBRentDepositInfoCell

#pragma mark - Initializer

- (id) initWithStyle: (UITableViewCellStyle) style 
reuseIdentifier: (NSString *) reuseIdentifier
{
  if (!(self = [super initWithStyle: style reuseIdentifier: reuseIdentifier])) 
    return nil;

  self.selectionStyle = UITableViewCellSelectionStyleNone;

  CGRect screen       = [[UIScreen mainScreen] bounds];
  CGFloat screenWidth = screen.size.width;

  CGFloat padding        = 20.0f;
  CGFloat standardHeight = 44.0f;
  CGFloat width = (screenWidth - (padding * 4)) / 3.0f;

  // Name
  _nameLabel = [UILabel new];
  _nameLabel.font = [UIFont fontWithName: @"HelveticaNeue-Light" size: 15];
  _nameLabel.frame = CGRectMake(padding, padding, width, standardHeight);
  _nameLabel.text = @"Jonathan";
  _nameLabel.textColor = [UIColor textColor];
  [self.contentView addSubview: _nameLabel];

  // Deposit
  _depositTextField = [[TextFieldPadding alloc] init];
  _depositTextField.font = [UIFont fontWithName: @"HelveticaNeue-Light" 
    size: 15];
  _depositTextField.frame = CGRectMake(
    _nameLabel.frame.origin.x + _nameLabel.frame.size.width + padding,
      _nameLabel.frame.origin.y, _nameLabel.frame.size.width,
        _nameLabel.frame.size.height);
  _depositTextField.keyboardType = UIKeyboardTypeDecimalPad;
  _depositTextField.layer.borderColor = [UIColor grayLight].CGColor;
  _depositTextField.layer.borderWidth = 1.0f;
  _depositTextField.layer.cornerRadius = 5.0f;
  // Left view 1
  UILabel *leftView1 = [UILabel new];
  leftView1.font = _depositTextField.font;
  leftView1.text = @"$";
  leftView1.textAlignment = NSTextAlignmentCenter;
  leftView1.textColor = [UIColor grayMedium];
  CGSize maxSize = CGSizeMake(_depositTextField.frame.size.width, 
    _depositTextField.frame.size.height);
  CGRect leftView1Rect = [leftView1.text boundingRectWithSize: maxSize
    font: leftView1.font];
  leftView1.frame = CGRectMake(0.0f, 0.0f, 
    (padding * 0.25f) + leftView1Rect.size.width + (padding * 0.25f),
      leftView1Rect.size.height);
  _depositTextField.leftView = leftView1;
  _depositTextField.leftViewMode = UITextFieldViewModeAlways;
  _depositTextField.leftPaddingX = leftView1.frame.size.width;
  _depositTextField.rightPaddingX = padding * 0.25f;
  _depositTextField.textColor = [UIColor blueDark];
  [self.contentView addSubview: _depositTextField];

  // Rent
  _rentTextField = [[TextFieldPadding alloc] init];
  _rentTextField.font = _depositTextField.font;
  _rentTextField.frame = CGRectMake(_depositTextField.frame.origin.x + 
    _depositTextField.frame.size.width + padding,
      _depositTextField.frame.origin.y, _depositTextField.frame.size.width,
        _depositTextField.frame.size.height);
  _rentTextField.keyboardType = _depositTextField.keyboardType;
  _rentTextField.layer.borderColor = _depositTextField.layer.borderColor;
  _rentTextField.layer.borderWidth = _depositTextField.layer.borderWidth;
  _rentTextField.layer.cornerRadius = _depositTextField.layer.cornerRadius;
  // Left view 1
  UILabel *leftView2 = [UILabel new];
  leftView2.font = leftView1.font;
  leftView2.text = leftView1.text;
  leftView2.textAlignment = leftView1.textAlignment;
  leftView2.textColor = leftView1.textColor;
  leftView2.frame = leftView1.frame;
  _rentTextField.leftView = leftView2;
  _rentTextField.leftViewMode = _depositTextField.leftViewMode;
  _rentTextField.leftPaddingX = _depositTextField.leftPaddingX;
  _rentTextField.rightPaddingX = _depositTextField.rightPaddingX;
  _rentTextField.textColor = _depositTextField.textColor;
  [self.contentView addSubview: _rentTextField];

  return self;
}

#pragma mark - Methods

#pragma mark - Class Methods

+ (CGFloat) heightForCell
{
  CGFloat padding        = 20.0f;
  CGFloat standardHeight = 44.0f;
  return padding + standardHeight + padding;
}

@end
