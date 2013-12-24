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

  self.selectionStyle = UITableViewCellSelectionStyleNone;

  CGRect screen = [[UIScreen mainScreen] bounds];
  CGFloat padding = 20.0f;

  _neighborhoodTextField = [[TextFieldPadding alloc] init];
  _neighborhoodTextField.backgroundColor = [UIColor blueLight];
  _neighborhoodTextField.clipsToBounds = YES;
  _neighborhoodTextField.font = [UIFont fontWithName: @"HelveticaNeue-Medium" 
    size: 15];
  _neighborhoodTextField.frame = CGRectMake(padding, padding * 0.25, 
    screen.size.width - (padding * 2), 44.0f);
  _neighborhoodTextField.keyboardType = UIKeyboardTypeDecimalPad;
  _neighborhoodTextField.layer.cornerRadius = 2.0f;
  _neighborhoodTextField.paddingX = padding;
  _neighborhoodTextField.placeholderColor = [UIColor blueDarkAlpha: 0.5f];
  _neighborhoodTextField.placeholder = @"Select a neighborhood";
  _neighborhoodTextField.returnKeyType = UIReturnKeyDone;
  _neighborhoodTextField.textColor = [UIColor blueDark];
  _neighborhoodTextField.userInteractionEnabled = NO;
  
  [self.contentView addSubview: _neighborhoodTextField];

  return self;
}

@end
