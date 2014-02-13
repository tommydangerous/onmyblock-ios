//
//  OMBResidenceBookItCalendarCell.m
//  OnMyBlock
//
//  Created by Paul Aguilar on 2/3/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBResidenceBookItCalendarCell.h"
#import "MNCalendarView.h"
#import "UIColor+Extensions.h"

@implementation OMBResidenceBookItCalendarCell

#pragma mark - Initializer

- (id) initWithStyle: (UITableViewCellStyle) style
     reuseIdentifier: (NSString *) reuseIdentifier
{
  if (!(self = [super initWithStyle: style
                    reuseIdentifier: reuseIdentifier]))
    return nil;
  
  float screenWidth = [UIScreen mainScreen].bounds.size.width;
  self.selectionStyle = UITableViewCellSelectionStyleNone;
  self.separatorInset = UIEdgeInsetsMake(0.0f, screenWidth, 0.0f, 0.0f);
  self.backgroundColor = [UIColor grayUltraLight];
  
  float sizeCalendar = 195.f;
  CGRect boundsCalendarView = CGRectMake(0.f, 0.f ,
                                         screenWidth , sizeCalendar);
  _calendarView = [[MNCalendarView alloc] initWithFrame:boundsCalendarView];
  _calendarView.backgroundColor = UIColor.whiteColor;
  [self addSubview: _calendarView];
  
  _leaseMonthsLabel = [[UILabel alloc] init];
  _leaseMonthsLabel.backgroundColor = [UIColor grayLight];
  _leaseMonthsLabel.font = [UIFont fontWithName: @"HelveticaNeue-Light"
                                           size: 15];
  _leaseMonthsLabel.frame = CGRectMake(_calendarView.frame.origin.x, _calendarView.frame.origin.y + _calendarView.frame.size.height + 3.f,
                                       _calendarView.frame.size.width, 30.0f);
  _leaseMonthsLabel.textAlignment = NSTextAlignmentCenter;
  // _leaseMonthsLabel.text = @"0 MONTH LEASE";
  _leaseMonthsLabel.textColor = [UIColor whiteColor];
  [self.contentView insertSubview: _leaseMonthsLabel belowSubview: _calendarView];
  
  return self;
}

#pragma mark - Methods

#pragma mark - Class Methods

+ (CGFloat) heightForCell
{
  return 195.f + 30.f + 5.f;
}

@end
