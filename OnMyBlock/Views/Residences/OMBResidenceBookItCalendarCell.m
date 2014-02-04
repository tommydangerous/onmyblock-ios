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
  
  self.selectionStyle = UITableViewCellSelectionStyleNone;
  self.backgroundColor = [UIColor grayUltraLight];
  float sizeCalendar = 195.f;
  CGRect boundsCalendarView = CGRectMake([UIScreen mainScreen].bounds.size.width * 0.08, 0 ,
                                         [UIScreen mainScreen].bounds.size.width * 0.84 , sizeCalendar);
  self.frame = CGRectMake(0, 0 ,
                          [UIScreen mainScreen].bounds.size.width, sizeCalendar + 5.f);
  _calendarView = [[MNCalendarView alloc] initWithFrame:boundsCalendarView];
  _calendarView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
  _calendarView.backgroundColor = UIColor.whiteColor;
  [self addSubview: _calendarView];
  
  return self;
}

#pragma mark - Methods

#pragma mark - Class Methods

+ (CGFloat) heightForCell
{
  return 200.0f;
}

@end
