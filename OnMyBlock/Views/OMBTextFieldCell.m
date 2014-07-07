//
//  OMBTextFieldCell.m
//  OnMyBlock
//
//  Created by Paul Aguilar on 7/7/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBTextFieldCell.h"

#import "OMBViewController.h"
#import "TextFieldPadding.h"

@implementation OMBTextFieldCell

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
{
  if(!(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]))
    return nil;
  

  float padding = 20.f;
  CGRect screen = [[UIScreen mainScreen] bounds];
  
  _textField = [[TextFieldPadding alloc] init];
  _textField.font = [UIFont fontWithName: @"HelveticaNeue-Light"
    size: 15];
  _textField.frame = CGRectMake(padding, 0.0f,
    (screen.size.width - 2 * padding), OMBStandardButtonHeight);
  _textField.textColor = [UIColor textColor];
  [self.contentView addSubview: _textField];
  
  return self;
}

#pragma mark - Methods

#pragma mark - Class Methods

+ (CGFloat) heightForCell
{
  return OMBStandardButtonHeight;
}

@end
