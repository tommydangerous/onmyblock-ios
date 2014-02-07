//
//  OMBMapFilterRentCell.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/20/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBMapFilterRentCell.h"

#import "TextFieldPadding.h"
#import "UIColor+Extensions.h"

@implementation OMBMapFilterRentCell

#pragma mark - Initialize

- (id) initWithStyle: (UITableViewCellStyle) style 
reuseIdentifier: (NSString *)reuseIdentifier
{ 
  if (!(self = [super initWithStyle: style reuseIdentifier: reuseIdentifier])) 
    return nil;

  self.backgroundColor = [UIColor grayUltraLight];
  self.selectionStyle = UITableViewCellSelectionStyleNone;

  CGRect screen = [[UIScreen mainScreen] bounds];
  CGFloat padding = 20.0f;

  _rentRangeTextField = [[TextFieldPadding alloc] init];
//  _maxRentTextField = [[TextFieldPadding alloc] init];

  NSArray *array = @[_rentRangeTextField, /*_maxRentTextField*/];

  for (TextFieldPadding *textField in array) {
    textField.backgroundColor = [UIColor whiteColor];
    textField.clipsToBounds = YES;
    textField.font = [UIFont fontWithName: @"HelveticaNeue-Medium" 
      size: 15];
    CGFloat width = (screen.size.width - (padding * (1 + array.count))) * 1 / array.count;
    textField.frame = CGRectMake(
      padding + ((padding + width) * [array indexOfObject: textField]), 
        0.0f, width, 44.0f);
    textField.keyboardType = UIKeyboardTypeDecimalPad;
    textField.layer.borderColor = [UIColor blue].CGColor;
    textField.layer.borderWidth = 1.0f;
    textField.layer.cornerRadius = 5.0f;
    textField.paddingX = padding;
    textField.placeholderColor = [UIColor grayLight];
    textField.returnKeyType = UIReturnKeyDone;
    textField.textAlignment = NSTextAlignmentCenter;
    textField.textColor = [UIColor blue];
    textField.userInteractionEnabled = NO;
    
    [self.contentView addSubview: textField];
  }

  _rentRangeTextField.placeholder = @"Rent Range";
//  _maxRentTextField.placeholder = @"Max rent";

  return self;
}

#pragma mark - Methods

#pragma mark - Class Methods

+ (CGFloat) widthForTextField
{
  CGRect screen = [[UIScreen mainScreen] bounds];
  CGFloat padding = 20.0f;
  return (screen.size.width - (padding)) * 0.5;
}

@end
