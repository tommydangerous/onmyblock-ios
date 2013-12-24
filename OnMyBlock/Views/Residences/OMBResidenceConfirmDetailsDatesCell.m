//
//  OMBResidenceConfirmDetailsDatesCell.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/23/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBResidenceConfirmDetailsDatesCell.h"

#import "UIColor+Extensions.h"

@implementation OMBResidenceConfirmDetailsDatesCell

#pragma mark - Initializer

- (id) initWithStyle: (UITableViewCellStyle) style 
reuseIdentifier: (NSString *)reuseIdentifier
{
  if (!(self = [super initWithStyle: style reuseIdentifier: reuseIdentifier])) 
    return nil;

  self.selectionStyle = UITableViewCellSelectionStyleNone;

  CGRect screen = [[UIScreen mainScreen] bounds];

  CGFloat screeWidth = screen.size.width;

  CGFloat padding = 20.0f;

  UILabel *moveInLabel = [[UILabel alloc] init];
  moveInLabel.font = [UIFont fontWithName: @"HelveticaNeue-Light"
    size: 18];
  moveInLabel.frame = CGRectMake(0.0f, 0.0f, screeWidth * 0.5, padding + 27.0f);
  moveInLabel.text = @"Move-in";
  moveInLabel.textAlignment = NSTextAlignmentCenter;
  moveInLabel.textColor = [UIColor textColor];
  [self.contentView addSubview: moveInLabel];
  CALayer *leftUnderline = [CALayer layer];
  leftUnderline.backgroundColor = [UIColor grayLight].CGColor;
  leftUnderline.frame = CGRectMake(0.0f, moveInLabel.frame.size.height - 0.5f,
    moveInLabel.frame.size.width - padding, 0.5f);
  [moveInLabel.layer addSublayer: leftUnderline];

  UILabel *moveOutLabel = [[UILabel alloc] init];
  moveOutLabel.font = moveInLabel.font;
  moveOutLabel.frame = CGRectMake(screeWidth - moveInLabel.frame.size.width,
    moveInLabel.frame.origin.y, moveInLabel.frame.size.width,
      moveInLabel.frame.size.height);
  moveOutLabel.text = @"Move-out";
  moveOutLabel.textAlignment = moveInLabel.textAlignment;
  moveOutLabel.textColor = moveInLabel.textColor;
  [self.contentView addSubview: moveOutLabel];
  CALayer *rightUnderline = [CALayer layer];
  rightUnderline.backgroundColor = leftUnderline.backgroundColor;
  rightUnderline.frame = CGRectMake(
    moveOutLabel.frame.size.width - leftUnderline.frame.size.width,
      leftUnderline.frame.origin.y, leftUnderline.frame.size.width,
        leftUnderline.frame.size.height);
  [moveOutLabel.layer addSublayer: rightUnderline];

  _moveInDateLabel = [[UILabel alloc] init];
  _moveInDateLabel.font = [UIFont fontWithName: @"HelveticaNeue-Medium" 
    size: 18];
  _moveInDateLabel.frame = CGRectMake(moveInLabel.frame.origin.x,
    moveInLabel.frame.origin.y + moveInLabel.frame.size.height,
      moveInLabel.frame.size.width, moveInLabel.frame.size.height);
  _moveInDateLabel.text = @"Sep 13, 13";
  _moveInDateLabel.textAlignment = moveInLabel.textAlignment;
  _moveInDateLabel.textColor = [UIColor blueDark];
  [self.contentView addSubview: _moveInDateLabel];

  _moveOutDateLabel = [[UILabel alloc] init];
  _moveOutDateLabel.font = _moveInDateLabel.font;
  _moveOutDateLabel.frame = CGRectMake(moveOutLabel.frame.origin.x,
    moveOutLabel.frame.origin.y + moveOutLabel.frame.size.height,
      moveOutLabel.frame.size.width, moveOutLabel.frame.size.height);
  _moveOutDateLabel.text = @"Jan 30, 14";
  _moveOutDateLabel.textAlignment = _moveInDateLabel.textAlignment;
  _moveOutDateLabel.textColor = _moveInDateLabel.textColor;
  [self.contentView addSubview: _moveOutDateLabel];

  UIView *middleLine = [[UIView alloc] init];
  middleLine.backgroundColor = [UIColor grayLight];
  middleLine.frame = CGRectMake((screeWidth - 0.5f) * 0.5, padding,
    0.5f, _moveInDateLabel.frame.origin.y + 
      _moveInDateLabel.frame.size.height - (padding * 2));
  [self.contentView addSubview: middleLine];

  UIView *bottomLine = [[UIView alloc] init];
  bottomLine.backgroundColor = middleLine.backgroundColor;
  bottomLine.frame = CGRectMake(0.0f, 
    _moveInDateLabel.frame.origin.y + _moveInDateLabel.frame.size.height, 
      screeWidth, 0.5f);
  [self.contentView addSubview: bottomLine];

  _leaseMonthsLabel = [[UILabel alloc] init];
  _leaseMonthsLabel.font = [UIFont fontWithName: @"HelveticaNeue-Light" 
    size: 15];
  _leaseMonthsLabel.frame = CGRectMake(0.0f, bottomLine.frame.origin.y,
    screeWidth, 44.0f);
  _leaseMonthsLabel.text = @"5 month lease";
  _leaseMonthsLabel.textAlignment = NSTextAlignmentCenter;
  _leaseMonthsLabel.textColor = [UIColor grayMedium];
  [self.contentView addSubview: _leaseMonthsLabel];

  CALayer *bottomBorder = [CALayer layer];
  bottomBorder.backgroundColor = leftUnderline.backgroundColor;
  bottomBorder.frame = CGRectMake(0.0f, _leaseMonthsLabel.frame.origin.y + 
    _leaseMonthsLabel.frame.size.height - 0.5f, screeWidth, 0.5f);
  [self.contentView.layer addSublayer: bottomBorder];

  return self;
}

#pragma mark - Methods

#pragma mark - Class Methods

+ (CGFloat) heightForCell
{
  CGFloat padding = 20.0f;
  return ((padding + 27.0f) * 2) + 44.0f;
}

@end
