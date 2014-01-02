//
//  OMBMapFilterPlusMinusCell.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 1/2/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBMapFilterPlusMinusCell.h"

#import "UIImage+Color.h"
#import "UIColor+Extensions.h"

@implementation OMBMapFilterPlusMinusCell

#pragma mark - Initialize

- (id) initWithStyle: (UITableViewCellStyle) style 
reuseIdentifier: (NSString *)reuseIdentifier
{ 
  if (!(self = [super initWithStyle: style reuseIdentifier: reuseIdentifier])) 
    return nil;

  self.backgroundColor = [UIColor clearColor];
  self.selectionStyle = UITableViewCellSelectionStyleNone;

  CGRect screen = [[UIScreen mainScreen] bounds];
  CGFloat padding = 20.0f;

  CGFloat width = screen.size.width - (padding * 2);

  _currentValue = [NSNumber numberWithInt: 1];

  _valueLabel = [UILabel new];
  _valueLabel.backgroundColor = [UIColor whiteColor];
  _valueLabel.font = [UIFont fontWithName: @"HelveticaNeue-Medium" size: 15];
  _valueLabel.frame = CGRectMake(padding, 0.0f, width, 44.0f);
  _valueLabel.layer.borderColor = [UIColor blue].CGColor;
  _valueLabel.layer.borderWidth = 1.0f;
  _valueLabel.layer.cornerRadius = 5.0f;
  _valueLabel.textAlignment = NSTextAlignmentCenter;
  _valueLabel.textColor = [UIColor blue];
  [self.contentView addSubview: _valueLabel];

  _minusButton = [UIButton new];
  _minusButton.frame = CGRectMake(padding, 0.0f, _valueLabel.frame.size.height,
    _valueLabel.frame.size.height);
  _minusButton.tag = -1;
  _minusButton.titleLabel.font = _valueLabel.font;
  [_minusButton addTarget: self action: @selector(changeCurrentValue:)
    forControlEvents: UIControlEventTouchUpInside];
  [_minusButton setTitle: @"-" forState: UIControlStateNormal];
  [_minusButton setTitleColor: _valueLabel.textColor
    forState: UIControlStateNormal];
  [self.contentView addSubview: _minusButton];
  CALayer *rightBorderLayer = [CALayer layer];
  rightBorderLayer.backgroundColor = _valueLabel.layer.borderColor;
  rightBorderLayer.frame = CGRectMake(
    _minusButton.frame.size.width - _valueLabel.layer.borderWidth, 0.0f, 
      _valueLabel.layer.borderWidth, _valueLabel.frame.size.height);
  [_minusButton.layer addSublayer: rightBorderLayer];

  _plusButton = [UIButton new];
  _plusButton.frame = CGRectMake(
    screen.size.width - (_valueLabel.frame.size.height + padding), 
      0.0f, _valueLabel.frame.size.height, _valueLabel.frame.size.height);
  _plusButton.tag = 1;
  _plusButton.titleLabel.font = _valueLabel.font;
  [_plusButton addTarget: self action: @selector(changeCurrentValue:)
    forControlEvents: UIControlEventTouchUpInside];
  [_plusButton setTitle: @"+" forState: UIControlStateNormal];
  [_plusButton setTitleColor: _valueLabel.textColor
    forState: UIControlStateNormal];
  [self.contentView addSubview: _plusButton];
  CALayer *leftBorderLayer = [CALayer layer];
  leftBorderLayer.backgroundColor = _valueLabel.layer.borderColor;
  leftBorderLayer.frame = CGRectMake(0.0f, 0.0f, 
    _valueLabel.layer.borderWidth, _valueLabel.frame.size.height);
  [_plusButton.layer addSublayer: leftBorderLayer];

  [self setValueLabelText];

  return self;
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) changeCurrentValue: (UIButton *) button
{
  int value = [_currentValue intValue];
  value += button.tag;
  if (value < 0)
    value = 0;
  _currentValue = [NSNumber numberWithInt: value];
  [self setValueLabelText];
}

- (void) setValueLabelText
{
  // Subclasses implement this
}

@end
