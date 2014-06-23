//
//  OMBCreditCardTextFieldCell.m
//  OnMyBlock
//
//  Created by Paul Aguilar on 6/23/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBCreditCardTextFieldCell.h"

#import "OMBViewController.h"

@implementation OMBCreditCardTextFieldCell

- (id) initWithStyle: (UITableViewCellStyle) style
     reuseIdentifier: (NSString *)reuseIdentifier
{
  
  if (!(self = [super initWithStyle: style reuseIdentifier: reuseIdentifier]))
    return nil;
  
  //self.firstTextField.textAlignment = NSTextAlignmentCenter;
  
  _yearTextField = [[TextFieldPadding alloc] init];
  _yearTextField.font = self.firstTextField.font;
  //_yearTextField.returnKeyType = UIReturnKeyDone;
  _yearTextField.textAlignment = NSTextAlignmentCenter;
  _yearTextField.textColor = self.firstTextField.textColor;
  [self.contentView addSubview: _yearTextField];
  
  expirationSeparator = [UILabel new];
  expirationSeparator.font = _yearTextField.font;
  expirationSeparator.textColor = _yearTextField.textColor;
  expirationSeparator.text = @"/";
  [self.contentView addSubview: expirationSeparator];
  
  return self;
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) setFrameUsingIconImageView
{
  [super setFrameUsingIconImageView];
  
  CGRect screen       = [[UIScreen mainScreen] bounds];
  CGFloat screenWidth = screen.size.width;
  CGFloat padding = OMBPadding;
  CGFloat height = [OMBTwoLabelTextFieldCell heightForCellWithIconImageView];
  CGFloat iconSize = height * 0.5f;
  
  CGFloat textWidth = (screenWidth - 4 * padding - iconSize) * 0.5;
  CGFloat originX1 = self.firstIconImageView.frame.origin.x +
  self.firstIconImageView.frame.size.width + padding;
  
  CGFloat widthDivider = 7.f;
  
  self.firstTextField.frame = CGRectMake(originX1, 0.0f,
    (textWidth - widthDivider) * .5f , height);
  
  expirationSeparator.frame =
    CGRectMake(self.firstTextField.frame.origin.x +
      self.firstTextField.frame.size.width, 0.0f, widthDivider, height);
  
  _yearTextField.frame = CGRectMake(expirationSeparator.frame.origin.x +
    expirationSeparator.frame.size.width, 0.0f,
      self.firstTextField.frame.size.width, height);
  
  CGFloat originX2 = _yearTextField.frame.origin.x +
    _yearTextField.frame.size.width + padding;
  
  self.secondTextField.frame = CGRectMake(originX2, 0.0f,
    textWidth, height);
  
}

@end
