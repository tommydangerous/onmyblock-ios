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

  _iconImageView = [UIImageView new];
  [self.contentView addSubview: _iconImageView];

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

+ (CGFloat) heightForCellWithIconImageView
{
  return OMBStandardButtonHeight;
}

#pragma mark - Instance Methods

- (void) setFrameUsingIconImageView
{
  CGRect screen       = [[UIScreen mainScreen] bounds];
  CGFloat screenWidth = screen.size.width;
  CGFloat padding = OMBPadding;
  CGFloat height = [OMBLabelTextFieldCell heightForCellWithIconImageView];

  CGFloat iconSize = height * 0.5f;
  _iconImageView.alpha = 0.3f;
  _iconImageView.frame = CGRectMake(padding, (height - iconSize) * 0.5f,
    iconSize, iconSize);

  CGFloat originX = _iconImageView.frame.origin.x +
    _iconImageView.frame.size.width + padding;
  _textField.frame = CGRectMake(originX, 0.0f, 
    screenWidth - (originX + padding), height);
}

- (void) setFrameUsingSize: (CGSize) size
{
  CGRect screen       = [[UIScreen mainScreen] bounds];
  CGFloat screenWidth = screen.size.width;
  CGFloat padding = OMBPadding;
  _textFieldLabel.frame = CGRectMake(padding, 0.0f, 
    size.width, OMBStandardHeight);
  _textField.frame = CGRectMake(_textFieldLabel.frame.origin.x + 
    _textFieldLabel.frame.size.width + padding, _textFieldLabel.frame.origin.y,
      screenWidth - (_textFieldLabel.frame.origin.x + 
        _textFieldLabel.frame.size.width + padding + padding), 
          _textFieldLabel.frame.size.height);
}

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
