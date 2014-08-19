//
//  OMBNeedHelpTextFieldCell.m
//  OnMyBlock
//
//  Created by Paul Aguilar on 8/18/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBNeedHelpTextFieldCell.h"

#import "OMBViewController.h"

@implementation OMBNeedHelpTextFieldCell

- (id)initWithStyle:(UITableViewCellStyle)style
  reuseIdentifier:(NSString *)reuseIdentifier
{
  if (!(self = [super initWithStyle:style
       reuseIdentifier:reuseIdentifier])) {
    return nil;
  }
  
  float padding = 20.f;
  CGRect screen = [[UIScreen mainScreen] bounds];
  
  self.backgroundColor = [UIColor grayUltraLight];
  self.selectionStyle = UITableViewCellSelectionStyleNone;
  
  self.textField.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.7];
  self.textField.frame = CGRectMake(padding, 10.0f,
    (screen.size.width - 2 * padding), OMBStandardHeight);
  self.textField.layer.cornerRadius = OMBCornerRadius;
  self.textField.paddingX = padding;
  self.textField.returnKeyType = UIReturnKeyDone;
  
  return self;
}

#pragma mark - Methods

#pragma mark - Class Methods

+ (CGFloat) heightForCell
{
  return 10.f + OMBStandardHeight + 10.f;
}

@end
