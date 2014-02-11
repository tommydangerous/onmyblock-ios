//
//  OMBResidenceConfirmDetailsDatesCell.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/23/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBResidenceConfirmDetailsDatesCell.h"

#import "OMBResidence.h"
#import "OMBViewController.h"
#import "UIColor+Extensions.h"
#import "UIFont+OnMyBlock.h"

@implementation OMBResidenceConfirmDetailsDatesCell

#pragma mark - Initializer

- (id) initWithStyle: (UITableViewCellStyle) style
     reuseIdentifier: (NSString *)reuseIdentifier
{
  if (!(self = [super initWithStyle: style reuseIdentifier: reuseIdentifier]))
    return nil;
  
  CGRect screen = [[UIScreen mainScreen] bounds];
  CGFloat screenWidth = screen.size.width;
  CGFloat padding = 20.0f;
  
  self.backgroundColor = [UIColor grayUltraLight];
  self.selectionStyle = UITableViewCellSelectionStyleNone;
  self.separatorInset = UIEdgeInsetsMake(0.0f, screenWidth, 0.0f, 0.0f);
  
  // Move-in label
  moveInLabel = [UILabel new];
  moveInLabel.font = [UIFont normalTextFont];
  moveInLabel.frame = CGRectMake(0.0f, padding, 
    screenWidth * 0.5, 22.0f);
  moveInLabel.text = @"Move-in";
  moveInLabel.textAlignment = NSTextAlignmentCenter;
  moveInLabel.textColor = [UIColor grayMedium];
  [self.contentView addSubview: moveInLabel];
  // CALayer *leftUnderline = [CALayer layer];
  // leftUnderline.backgroundColor = [UIColor grayLight].CGColor;
  // leftUnderline.frame = CGRectMake(0.0f, 
  //   moveInLabel.frame.size.height - 0.5f,
  //     moveInLabel.frame.size.width - padding, 0.5f);
  // [moveInLabel.layer addSublayer: leftUnderline];
  
  // Move-out label
  moveOutLabel = [UILabel new];
  moveOutLabel.font = moveInLabel.font;
  moveOutLabel.frame = CGRectMake(screenWidth - moveInLabel.frame.size.width,
    moveInLabel.frame.origin.y, moveInLabel.frame.size.width,
      moveInLabel.frame.size.height);
  moveOutLabel.text = @"Move-out";
  moveOutLabel.textAlignment = moveInLabel.textAlignment;
  moveOutLabel.textColor = moveInLabel.textColor;
  [self.contentView addSubview: moveOutLabel];
  // CALayer *rightUnderline = [CALayer layer];
  // rightUnderline.backgroundColor = leftUnderline.backgroundColor;
  // rightUnderline.frame = CGRectMake(
  //   moveOutLabel.frame.size.width - leftUnderline.frame.size.width,
  //     leftUnderline.frame.origin.y, leftUnderline.frame.size.width,
  //       leftUnderline.frame.size.height);
  // [moveOutLabel.layer addSublayer: rightUnderline];
  
  // Move-in date label
  _moveInDateLabel = [UILabel new];
  _moveInDateLabel.font = [UIFont mediumTextFontBold];
  _moveInDateLabel.frame = CGRectMake(moveInLabel.frame.origin.x,
    moveInLabel.frame.origin.y + moveInLabel.frame.size.height,
      moveInLabel.frame.size.width, 27.0f);
  _moveInDateLabel.textAlignment = moveInLabel.textAlignment;
  _moveInDateLabel.textColor = [UIColor grayMedium];
  [self.contentView addSubview: _moveInDateLabel];
  //  _contactMeButton.backgroundColor = [UIColor blueAlpha: 0.8f];
  // [_contactMeButton addTarget: self 
  //   action: @selector(contactMeButtonSelected)
  //             forControlEvents: UIControlEventTouchUpInside];
  
  // Move-out date label
  _moveOutDateLabel = [UILabel new];
  _moveOutDateLabel.font = _moveInDateLabel.font;
  _moveOutDateLabel.frame = CGRectMake(moveOutLabel.frame.origin.x,
     moveOutLabel.frame.origin.y + moveOutLabel.frame.size.height,
      moveOutLabel.frame.size.width, moveOutLabel.frame.size.height);
  _moveOutDateLabel.textAlignment = _moveInDateLabel.textAlignment;
  _moveOutDateLabel.textColor = _moveInDateLabel.textColor;
  [self.contentView addSubview: _moveOutDateLabel];
  
  // Middle line between move-in and move-out
  UIView *middleLine = [[UIView alloc] init];
  middleLine.backgroundColor = [UIColor grayLight];
  middleLine.frame = CGRectMake((screenWidth - 0.5f) * 0.5, 0.0f,
    0.5f, moveInLabel.frame.origin.y + moveInLabel.frame.size.height + 
      _moveInDateLabel.frame.size.height + padding);
  [self.contentView addSubview: middleLine];
  
  // Line above the lease months label
  UIView *bottomLine = [[UIView alloc] init];
  bottomLine.backgroundColor = [UIColor grayLight];
  bottomLine.frame = CGRectMake(0.0f,
    (_moveInDateLabel.frame.origin.y +
    _moveInDateLabel.frame.size.height + padding) - 0.5f,
      screenWidth, 0.5f);
  [self.contentView addSubview: bottomLine];
  
  _leaseMonthsLabel = [[UILabel alloc] init];
  _leaseMonthsLabel.backgroundColor = [UIColor grayUltraLight];
  _leaseMonthsLabel.font = [UIFont normalTextFont];
  _leaseMonthsLabel.frame = CGRectMake(0.0f, bottomLine.frame.origin.y,
    screenWidth, 44.0f);
  _leaseMonthsLabel.textAlignment = NSTextAlignmentCenter;
  _leaseMonthsLabel.textColor = [UIColor grayMedium];
  [self.contentView insertSubview: _leaseMonthsLabel belowSubview: bottomLine];
  
  // CALayer *bottomBorder = [CALayer layer];
  // bottomBorder.backgroundColor = leftUnderline.backgroundColor;
  // bottomBorder.frame = CGRectMake(0.0f, _leaseMonthsLabel.frame.origin.y +
  //   _leaseMonthsLabel.frame.size.height - 0.5f, screenWidth, 0.5f);
  // [self.contentView.layer addSublayer: bottomBorder];

  _moveInButton = [UIButton new];
  // _moveInButton.backgroundColor = [UIColor blueAlpha: 0.5f];
  _moveInButton.frame = CGRectMake(0.0f, 0.0f, moveInLabel.frame.size.width,
    moveInLabel.frame.origin.y + moveInLabel.frame.size.height + 
      + _moveInDateLabel.frame.size.height + padding);
  [self.contentView addSubview: _moveInButton];

  _moveOutButton = [UIButton new];
  // _moveOutButton.backgroundColor = [UIColor blueAlpha: 0.5f];
  _moveOutButton.frame = CGRectMake(
    _moveInButton.frame.origin.x + _moveInButton.frame.size.width,
      _moveInButton.frame.origin.y, _moveInButton.frame.size.width,
        _moveInButton.frame.size.height);
  [self.contentView addSubview: _moveOutButton];

  _moveInBackground = [UIView new];
  _moveInBackground.frame = _moveInButton.frame;
  [self.contentView insertSubview: _moveInBackground atIndex: 0];

  _moveOutBackground = [UIView new];
  _moveOutBackground.frame = _moveOutButton.frame;
  [self.contentView insertSubview: _moveOutBackground atIndex: 0];
  
  return self;
}

#pragma mark - Methods

#pragma mark - Class Methods

+ (CGFloat) heightForCell
{
  CGFloat padding = OMBPadding;
  return padding + 22.0f + 27.0f + padding + OMBStandardHeight;
  // return ((padding + 27.0f) * 2) + OMBStandardHeight;
}

+ (CGFloat) heightForCellWithNoLeaseMonthLabel
{
  return [OMBResidenceConfirmDetailsDatesCell heightForCell] -
  OMBStandardHeight;
}

#pragma mark - Instance Methods

- (void) highlightMoveInDate
{
  _moveInDateLabel.textColor  = [UIColor blue];
  _moveOutDateLabel.textColor = [UIColor grayMedium];

  _moveInBackground.backgroundColor  = [UIColor whiteColor];
  _moveOutBackground.backgroundColor = [UIColor grayUltraLight];
}

- (void) highlightMoveOutDate
{
  _moveInDateLabel.textColor  = [UIColor grayMedium];
  _moveOutDateLabel.textColor = [UIColor blue];

  _moveInBackground.backgroundColor  = [UIColor grayUltraLight];
  _moveOutBackground.backgroundColor = [UIColor whiteColor];
}

- (void) highlightNothing
{
  _moveInDateLabel.textColor = _moveOutDateLabel.textColor = 
    [UIColor grayMedium];
  _moveInBackground.backgroundColor = _moveOutBackground.backgroundColor =
    [UIColor grayUltraLight];
}

- (void) loadResidence: (OMBResidence *) object
{
  NSDateFormatter *dateFormmater = [NSDateFormatter new];
  dateFormmater.dateFormat = @"MMM d, yy";
  
  _moveInDateLabel.text  = @"Select date";
  _moveOutDateLabel.text = @"-";

  _moveInDateLabel.textColor = [UIColor blue];

  // _leaseMonthsLabel.text = [NSString stringWithFormat:
  //   @"%i month lease", object.leaseMonths];
}

@end