//
//  MNCalendarWeekdayViewCell.m
//  MNCalendarView
//
//  Created by Min Kim on 7/28/13.
//  Copyright (c) 2013 min. All rights reserved.
//

#import "MNCalendarViewWeekdayCell.h"

NSString *const MNCalendarViewWeekdayCellIdentifier = @"MNCalendarViewWeekdayCellIdentifier";


@implementation MNCalendarViewWeekdayCell

- (id)initWithFrame:(CGRect)frame {
  
  if (self = [super initWithFrame:frame]) {
    self.titleLabel.font = [UIFont fontWithName: @"HelveticaNeue-Light"
                                           size: 12]; // Sun, Mon ... etc
    self.enabled = NO;
    self.titleLabel.backgroundColor = [UIColor colorWithRed:0.98 green:0.98 blue:0.98 alpha:1.0];
  }
  return self;
}

- (void)setWeekday:(NSUInteger)weekday {
  _weekday = weekday;
  [self setNeedsDisplay];
}

@end
