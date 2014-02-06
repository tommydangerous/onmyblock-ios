//
//  OMBResidenceConfirmDetailsDatesCell.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/23/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBResidenceConfirmDetailsDatesCell.h"

#import "OMBResidence.h"
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

  self.selectionStyle = UITableViewCellSelectionStyleNone;
  self.separatorInset = UIEdgeInsetsMake(0.0f, screenWidth, 0.0f, 0.0f);

  moveInLabel = [[UILabel alloc] init];
  moveInLabel.font = [UIFont fontWithName: @"HelveticaNeue-Light"
    size: 18];
  moveInLabel.frame = CGRectMake(0.0f, 0.0f, screenWidth * 0.5, padding + 27.0f);
  moveInLabel.text = @"Move-in";
  moveInLabel.textAlignment = NSTextAlignmentCenter;
  moveInLabel.textColor = [UIColor textColor];
  [self.contentView addSubview: moveInLabel];
  CALayer *leftUnderline = [CALayer layer];
  leftUnderline.backgroundColor = [UIColor grayLight].CGColor;
  leftUnderline.frame = CGRectMake(0.0f, moveInLabel.frame.size.height - 0.5f,
    moveInLabel.frame.size.width - padding, 0.5f);
  [moveInLabel.layer addSublayer: leftUnderline];

  moveOutLabel = [[UILabel alloc] init];
  moveOutLabel.font = moveInLabel.font;
  moveOutLabel.frame = CGRectMake(screenWidth - moveInLabel.frame.size.width,
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

  _moveInDateLabel = [[UIButton alloc] init];
  _moveInDateLabel.titleLabel.font = [UIFont fontWithName: @"HelveticaNeue-Medium"
    size: 18];
  _moveInDateLabel.frame = CGRectMake(moveInLabel.frame.origin.x,
    moveInLabel.frame.origin.y + moveInLabel.frame.size.height,
      moveInLabel.frame.size.width, moveInLabel.frame.size.height);
  _moveInDateLabel.titleLabel.textAlignment = moveInLabel.textAlignment;
  [_moveInDateLabel setTitleColor:[UIColor blue] forState:UIControlStateNormal];
  [self.contentView addSubview: _moveInDateLabel];
//  _contactMeButton.backgroundColor = [UIColor blueAlpha: 0.8f];
//  [_contactMeButton addTarget: self action: @selector(contactMeButtonSelected)
//             forControlEvents: UIControlEventTouchUpInside];
  
  _moveOutDateLabel = [[UIButton alloc] init];
  _moveOutDateLabel.titleLabel.font = _moveInDateLabel.titleLabel.font;
  _moveOutDateLabel.frame = CGRectMake(moveOutLabel.frame.origin.x,
    moveOutLabel.frame.origin.y + moveOutLabel.frame.size.height,
      moveOutLabel.frame.size.width, moveOutLabel.frame.size.height);
  _moveOutDateLabel.titleLabel.textAlignment = _moveInDateLabel.titleLabel.textAlignment;
  [_moveOutDateLabel setTitleColor:[_moveInDateLabel titleColorForState:UIControlStateNormal] forState:UIControlStateNormal];
  [self.contentView addSubview: _moveOutDateLabel];

  UIView *middleLine = [[UIView alloc] init];
  middleLine.backgroundColor = [UIColor grayLight];
  middleLine.frame = CGRectMake((screenWidth - 0.5f) * 0.5, padding,
    0.5f, _moveInDateLabel.frame.origin.y + 
      _moveInDateLabel.frame.size.height - (padding * 2));
  [self.contentView addSubview: middleLine];

  // Line above the lease months label
  UIView *bottomLine = [[UIView alloc] init];
  bottomLine.backgroundColor = middleLine.backgroundColor;
  bottomLine.frame = CGRectMake(0.0f, 
    _moveInDateLabel.frame.origin.y + _moveInDateLabel.frame.size.height, 
      screenWidth, 0.5f);
  [self.contentView addSubview: bottomLine];

  _leaseMonthsLabel = [[UILabel alloc] init];
  _leaseMonthsLabel.backgroundColor = [UIColor grayUltraLight];
  _leaseMonthsLabel.font = [UIFont fontWithName: @"HelveticaNeue-Light" 
    size: 15];
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

  return self;
}

#pragma mark - Methods

#pragma mark - Class Methods

+ (CGFloat) heightForCell
{
  CGFloat padding = 20.0f;
  return ((padding + 27.0f) * 2) + 44.0f;
}

#pragma mark - Instance Methods

- (void) highlightMoveInDate
{
  // moveInLabel.backgroundColor = _moveInDateLabel.backgroundColor = 
  //   [UIColor blueLight]; 
  // moveOutLabel.backgroundColor = _moveOutDateLabel.backgroundColor =
  //   [UIColor whiteColor];
  moveInLabel.font  = [UIFont mediumTextFontBold];
  moveInLabel.textColor = [UIColor blueDark];
  moveOutLabel.font = [UIFont mediumTextFont];
  moveOutLabel.textColor = [UIColor textColor];
}

- (void) highlightMoveOutDate
{
  // moveInLabel.backgroundColor = _moveInDateLabel.backgroundColor = 
  //   [UIColor whiteColor]; 
  // moveOutLabel.backgroundColor = _moveOutDateLabel.backgroundColor =
  //   [UIColor blueLight];
  moveInLabel.font  = [UIFont mediumTextFont];
  moveInLabel.textColor = [UIColor textColor];
  moveOutLabel.font = [UIFont mediumTextFontBold];
  moveOutLabel.textColor = [UIColor blueDark];
}

- (void) highlightNothing
{
  // moveInLabel.backgroundColor = _moveInDateLabel.backgroundColor = 
  //   [UIColor whiteColor]; 
  // moveOutLabel.backgroundColor = _moveOutDateLabel.backgroundColor =
  //   [UIColor whiteColor];
  moveInLabel.font = moveOutLabel.font = [UIFont mediumTextFont];
  moveInLabel.textColor = moveOutLabel.textColor = [UIColor textColor];
}

- (void) loadResidence: (OMBResidence *) object
{
  NSDateFormatter *dateFormmater = [NSDateFormatter new];
  dateFormmater.dateFormat = @"MMM d, yy";
// <<<<<<< HEAD

//   _moveInDateLabel.text  = [dateFormmater stringFromDate: 
//     [NSDate dateWithTimeIntervalSince1970: object.moveInDate]];
//   _moveOutDateLabel.text = [dateFormmater stringFromDate: [object moveOutDateDate]];
//   _leaseMonthsLabel.text = [NSString stringWithFormat: 
// =======
  
  [_moveInDateLabel setTitle:@"Select date" forState:UIControlStateNormal];
  [_moveOutDateLabel setTitle:@"-" forState:UIControlStateNormal];
//  [_moveInDateLabel setTitle:[dateFormmater stringFromDate:
//    [NSDate dateWithTimeIntervalSince1970: object.moveInDate]] forState:UIControlStateNormal];
//  [_moveOutDateLabel setTitle:[dateFormmater stringFromDate: [object moveOutDate]] forState:UIControlStateNormal];
  _leaseMonthsLabel.text = [NSString stringWithFormat:
// >>>>>>> cb7fd819c965a120fc9188315e308ea1cc0a3452
    @"%i month lease", object.leaseMonths];
  
}

- (void) setMoveInDateLabelText: (NSString *) string
{
  [_moveInDateLabel setTitle: string forState: UIControlStateNormal];
}

- (void) setMoveOutDateLabelText: (NSString *) string
{
  [_moveOutDateLabel setTitle: string forState: UIControlStateNormal];
}

@end
