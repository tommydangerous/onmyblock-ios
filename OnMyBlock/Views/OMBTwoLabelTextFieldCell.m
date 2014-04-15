//
//  OMBTwoLabelTextFieldCell.m
//  OnMyBlock
//
//  Created by Paul Aguilar on 2/18/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBTwoLabelTextFieldCell.h"

#import "NSString+Extensions.h"
#import "OMBViewController.h"

@interface OMBTwoLabelTextFieldCell ()
{
  UIView *middleDivider;
}

@end

@implementation OMBTwoLabelTextFieldCell

#pragma mark - Initializer

- (id) initWithStyle: (UITableViewCellStyle) style
     reuseIdentifier: (NSString *)reuseIdentifier
{
  if (!(self = [super initWithStyle: style reuseIdentifier: reuseIdentifier]))
    return nil;
  
    _viewBackground = [UIView new];
    _viewBackground.backgroundColor = [UIColor whiteColor];
    _viewBackground.layer.borderColor = [[UIColor grayLight] CGColor];
    [_viewBackground setHidden:YES];
    [self.contentView addSubview: _viewBackground];

  _firstIconImageView = [UIImageView new];
  [self.contentView addSubview: _firstIconImageView];
  
  _firstTextFieldLabel = [UILabel new];
  _firstTextFieldLabel.font = [UIFont fontWithName: @"HelveticaNeue-Light"
                                              size: 15];
  _firstTextFieldLabel.textColor = [UIColor textColor];
  [self.contentView addSubview: _firstTextFieldLabel];
  
  _firstTextField = [[TextFieldPadding alloc] init];
  _firstTextField.font = _firstTextFieldLabel.font;
  _firstTextField.returnKeyType = UIReturnKeyDone;
  _firstTextField.textColor = [UIColor textColor];
  [self.contentView addSubview: _firstTextField];
  
  _secondIconImageView = [UIImageView new];
  //[self.contentView addSubview: _secondIconImageView];
  
  _secondTextFieldLabel = [UILabel new];
  _secondTextFieldLabel.font = _firstTextFieldLabel.font;
  _secondTextFieldLabel.textColor = _firstTextFieldLabel.textColor;
  [self.contentView addSubview: _secondTextFieldLabel];
  
  _secondTextField = [[TextFieldPadding alloc] init];
  _secondTextField.font = _secondTextFieldLabel.font;
  _secondTextField.returnKeyType = UIReturnKeyDone;
  _secondTextField.textColor = _firstTextField.textColor;
  [self.contentView addSubview: _secondTextField];

    middleDivider = [UIView new];
    middleDivider.backgroundColor = [UIColor grayLight];
    [self.contentView addSubview: middleDivider];

    _thirdTextField = [[TextFieldPadding alloc] init];
    _thirdTextField.font = _secondTextFieldLabel.font;
    _thirdTextField.returnKeyType = UIReturnKeyDone;
    _thirdTextField.textColor = _thirdTextField.textColor;
    _thirdTextField.hidden = YES;
    [self.contentView addSubview: _thirdTextField];

    _labelSeparator = [UILabel new];
    _labelSeparator.font = _thirdTextField.font;
    _labelSeparator.textColor = _labelSeparator.textColor;
    _labelSeparator.hidden = YES;
    [self.contentView addSubview: _labelSeparator];

    _secondIconImageView.hidden = YES;
    [self.contentView addSubview: _secondIconImageView];

  
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

+ (CGFloat) heightForCellWithLeftLabelIconImageView
{
    return 32.0f;
}

#pragma mark - Instance Methods

- (void) setFrameUsingLeftLabelIconImageView
{
    CGRect screen       = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screen.size.width;
    CGFloat padding = OMBPadding;
    CGFloat padding2 = 10.0f;
    CGFloat height = [OMBTwoLabelTextFieldCell heightForCellWithLeftLabelIconImageView];
    CGFloat iconSize = height * 0.5f;
    CGFloat labelWidth = 60.0f;
    CGFloat textWidth = 30.0f;

    CGFloat secondLabelWidth = 40.0f;
    CGFloat secondTextWidth = 60.0f;

    CGFloat separatorWidth = 10.0f;

    _viewBackground.frame = CGRectMake(padding, -1.0f,
                                       screenWidth - 2*padding, height);
    
    _viewBackground.backgroundColor = [UIColor whiteColor];
    _viewBackground.layer.borderWidth = 1.0f;
    [_viewBackground setHidden:NO];

    CGFloat originX1 =  padding + padding2;
    _firstTextFieldLabel.frame = CGRectMake(originX1, 0.0f,
                                       labelWidth, height);

    _firstIconImageView.hidden = YES;

    _firstTextField.hidden = NO;
    _firstTextField.frame = CGRectMake(originX1 + labelWidth, 0.0f,
                                        textWidth, height);
    _labelSeparator.hidden = NO;
    _labelSeparator.frame = CGRectMake(_firstTextField.frame.origin.x + _firstTextField.frame.size.width - 5.0f, 0.0f,separatorWidth, height);

    _thirdTextField.hidden = NO;
    _thirdTextField.frame = CGRectMake(_labelSeparator.frame.origin.x + _labelSeparator.frame.size.width - 0.0f, 0.0f,textWidth, height);

    
    CGFloat middleDividerWidth = 0.5f;
    middleDivider.frame = CGRectMake(_viewBackground.frame.origin.x +
                                     _viewBackground.frame.size.width * 0.5f - middleDividerWidth,
                                     0.0f, middleDividerWidth,
                                     height);

    CGFloat originX2 = middleDivider.frame.origin.x + middleDivider.frame.size.width + padding2;

    _secondTextFieldLabel.frame = CGRectMake(originX2, 0.0f,
                                            secondLabelWidth, height);
    
    _secondTextField.hidden = NO;
    _secondTextField.frame = CGRectMake(originX2 + _secondTextFieldLabel.frame.size.width, 0.0f,
                                            secondTextWidth, height);

    _secondIconImageView.hidden = NO;
    _secondIconImageView.alpha = 0.3f;
    _secondIconImageView.frame = CGRectMake(_viewBackground.frame.origin.x + _viewBackground.frame.size.width - padding2 - iconSize, (height - iconSize) * 0.5f,
                                           iconSize, iconSize);

    
}

- (void) setFrameUsingIconImageView
{
  CGRect screen       = [[UIScreen mainScreen] bounds];
  CGFloat screenWidth = screen.size.width;
  CGFloat padding = OMBPadding;
  CGFloat height = [OMBTwoLabelTextFieldCell heightForCellWithIconImageView];
  CGFloat iconSize = height * 0.5f;
  _firstIconImageView.alpha = 0.3f;
  _firstIconImageView.frame = CGRectMake(padding, (height - iconSize) * 0.5f,
                                    iconSize, iconSize);
  
  CGFloat textWidth = (screenWidth - 4 * padding - iconSize) * 0.5;
  CGFloat originX1 = _firstIconImageView.frame.origin.x +
  _firstIconImageView.frame.size.width + padding;
  _firstTextField.frame = CGRectMake(originX1, 0.0f,
                                     textWidth, height);
  
  CGFloat originX2 = _firstTextField.frame.origin.x + _firstTextField.frame.size.width + padding;
  _secondTextField.frame = CGRectMake(originX2, 0.0f,
                                     textWidth, height);

  CGFloat middleDividerWidth = 0.5f;
  middleDivider.frame = CGRectMake(_firstTextField.frame.origin.x + 
    _firstTextField.frame.size.width - middleDividerWidth,
      _secondTextField.frame.origin.y, middleDividerWidth, 
        _secondTextField.frame.size.height);
}


@end
