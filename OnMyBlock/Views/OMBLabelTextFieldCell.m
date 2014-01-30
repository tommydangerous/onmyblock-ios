//
//  OMBLabelTextFieldCell.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/27/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBLabelTextFieldCell.h"

#import "NSString+Extensions.h"
#import "OMBViewController.h"

@implementation OMBLabelTextFieldCell

#pragma mark - Initializer

- (id) initWithStyle: (UITableViewCellStyle) style 
reuseIdentifier: (NSString *)reuseIdentifier
{ 
  if (!(self = [super initWithStyle: style reuseIdentifier: reuseIdentifier])) 
    return nil;

  _textFieldLabel = [UILabel new];
  _textFieldLabel.font = [UIFont fontWithName: @"HelveticaNeue-Light" 
    size: 15];
  _textFieldLabel.textColor = [UIColor textColor];
  [self.contentView addSubview: _textFieldLabel];

  _textField = [[TextFieldPadding alloc] init];
  _textField.font = _textFieldLabel.font;
  _textField.returnKeyType = UIReturnKeyDone;
  _textField.textColor = [UIColor textColor];
  [self.contentView addSubview: _textField];

  return self;
}

#pragma mark - Methods

#pragma mark - Class Methods

+ (CGFloat) heightForCell
{
  return OMBStandardHeight;
}

#pragma mark - Instance Methods

- (void) setFramesUsingString: (NSString *) string
{
  CGRect screen       = [[UIScreen mainScreen] bounds];
  CGFloat screenWidth = screen.size.width;
  CGFloat padding     = 20.0f;
  CGSize size = [string boundingRectWithSize: CGSizeMake(screenWidth, 44.0f)
    font: _textFieldLabel.font].size;

  _textFieldLabel.frame = CGRectMake(padding, 0.0f, size.width, 44.0f);
  _textField.frame = CGRectMake(_textFieldLabel.frame.origin.x + 
    _textFieldLabel.frame.size.width + padding, _textFieldLabel.frame.origin.y,
      screenWidth - (_textFieldLabel.frame.origin.x + 
        _textFieldLabel.frame.size.width + padding + padding), 
          _textFieldLabel.frame.size.height);
}

@end
