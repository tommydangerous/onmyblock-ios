//
//  OMBNeedHelpTwoTextFieldCell.m
//  OnMyBlock
//
//  Created by Paul Aguilar on 8/19/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBNeedHelpTwoTextFieldCell.h"

#import "OMBViewController.h"

@implementation OMBNeedHelpTwoTextFieldCell

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
{
  
  if (!(self = [super initWithStyle:style
        reuseIdentifier:reuseIdentifier])) {
    return nil;
  }
  
  float padding = 20.f;
  CGRect screen = [[UIScreen mainScreen] bounds];
  
  self.textField.frame = CGRectMake(
    padding, self.textField.frame.origin.y,
      (screen.size.width - padding * 3.f) * .5f,
        self.textField.frame.size.height);
  
  _secondTextField = [[TextFieldPadding alloc] init];
  _secondTextField.backgroundColor = self.textField.backgroundColor;
  _secondTextField.font = self.textField.font;
  _secondTextField.frame = CGRectMake(
    self.textField.frame.origin.x +
      self.textField.frame.size.width + padding,
        self.textField.frame.origin.y,
          self.textField.frame.size.width - 1.f,
            self.textField.frame.size.height);
  _secondTextField.layer.cornerRadius = self.textField.layer.cornerRadius;
  _secondTextField.paddingX = self.textField.paddingX;
  _secondTextField.returnKeyType = self.textField.returnKeyType;
  _secondTextField.textColor = self.textField.textColor;
  [self.contentView addSubview: _secondTextField];
  
  return self;
}

@end
