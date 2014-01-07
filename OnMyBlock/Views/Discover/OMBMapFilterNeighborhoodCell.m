//
//  OMBMapFilterNeighborhoodCell.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/20/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBMapFilterNeighborhoodCell.h"

#import "TextFieldPadding.h"
#import "UIColor+Extensions.h"

@implementation OMBMapFilterNeighborhoodCell

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

  _neighborhoodTextField = [[TextFieldPadding alloc] init];
  _neighborhoodTextField.backgroundColor = [UIColor whiteColor];
  _neighborhoodTextField.clipsToBounds = YES;
  _neighborhoodTextField.font = [UIFont fontWithName: @"HelveticaNeue-Medium" 
    size: 15];
  _neighborhoodTextField.frame = CGRectMake(padding, 0.0f, 
    screen.size.width - (padding * 2), 44.0f);
  _neighborhoodTextField.keyboardType = UIKeyboardTypeDecimalPad;
  _neighborhoodTextField.layer.borderColor = [UIColor blue].CGColor;
  _neighborhoodTextField.layer.borderWidth = 1.0f;
  _neighborhoodTextField.layer.cornerRadius = 5.0f;
  _neighborhoodTextField.paddingX = padding;
  _neighborhoodTextField.placeholderColor = [UIColor grayLight];
  _neighborhoodTextField.placeholder = @"Select a neighborhood";
  _neighborhoodTextField.returnKeyType = UIReturnKeyDone;
  _neighborhoodTextField.textAlignment = NSTextAlignmentCenter;
  _neighborhoodTextField.textColor = [UIColor blue];
  _neighborhoodTextField.userInteractionEnabled = NO;
  
  [self.contentView addSubview: _neighborhoodTextField];

  return self;
}

@end
