//
//  MNCalendarViewDayCell.m
//  MNCalendarView
//
//  Created by Min Kim on 7/28/13.
//  Copyright (c) 2013 min. All rights reserved.
//

#import "MNCalendarViewDayCell.h"

NSString *const MNCalendarViewDayCellIdentifier = @"MNCalendarViewDayCellIdentifier";

@interface MNCalendarViewDayCell()

@property(nonatomic,strong,readwrite) NSDate *date;
@property(nonatomic,strong,readwrite) NSDate *month;
@property(nonatomic,assign,readwrite) NSUInteger weekday;

@end

@implementation MNCalendarViewDayCell

- (void)setDate:(NSDate *)date
          month:(NSDate *)month
       calendar:(NSCalendar *)calendar {
  
  self.date     = date;
  self.month    = month;
  self.calendar = calendar;
  
  NSDateComponents *components =
  [self.calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSWeekdayCalendarUnit
                   fromDate:self.date];
  
  NSDateComponents *monthComponents =
  [self.calendar components:NSMonthCalendarUnit
                   fromDate:self.month];
  
  self.weekday = components.weekday;
  
  if(components.day == 1){
    self.titleLabel.numberOfLines = 3;
    self.titleLabel.text = [NSString stringWithFormat:@"%@\n%d\n ",[[[MNCalendarViewDayCell monthNames] objectAtIndex:components.month -1 ] uppercaseString],components.day];
    
    if(components.month == 1)
      self.titleLabel.text = [self.titleLabel.text stringByAppendingString:[NSString stringWithFormat:@"%d ",components.year]];;
    
  }else{
    self.titleLabel.text =  [NSString stringWithFormat:@"%d",components.day];
  }
  
  self.enabled = monthComponents.month == components.month;
  
  [self setNeedsDisplay];
}

- (void) setEnabled: (BOOL) enabled
{
  [super setEnabled:enabled];
  
  NSDateComponents *components = [self.calendar components:
    NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSWeekdayCalendarUnit 
    fromDate:self.date];
  
  NSDateComponents *monthComponents = [self.calendar components:NSMonthCalendarUnit
                                                       fromDate:self.month];
  // if(components.month == monthComponents.month && !self.isEnabled){
  //   self.titleLabel.textColor = UIColor.grayColor;
  //   self.backgroundColor = [UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:0.7];
  //   return;
  // }
  if(!self.isEnabled){
    self.titleLabel.textColor = UIColor.grayColor;
    self.backgroundColor = [UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:0.7];
    return;
  }
  
  // Enabled
  if (self.enabled) {
    self.titleLabel.textColor = [UIColor redColor];
  }
  else {
    self.titleLabel.textColor = [UIColor greenColor];
  }

  // Selected
  if (self.selected)
    self.titleLabel.textColor = UIColor.redColor;
  else
    self.titleLabel.textColor = [UIColor blackColor];

  // .. , UIColor.darkGrayColor
  self.backgroundColor =
    self.enabled ? UIColor.whiteColor : UIColor.whiteColor;
  
}

- (void)drawRect:(CGRect)rect {
  [super drawRect:rect];
  
  CGContextRef context = UIGraphicsGetCurrentContext();
  CGColorRef separatorColor = self.separatorColor.CGColor;
  
  CGSize size = self.bounds.size;
  
  // LINEAS VERTICALES
  // if(self.enabled)
  // separatorColor =  [[UIColor colorWithRed:0.f green:0.f blue:1.f alpha:1] CGColor];
  
//  NSDateComponents *dayComponent = [self.calendar components:NSCalendarUnitDay fromDate:self.date];
//  NSDateComponents *lastDayOfMonthComponent = [self.calendar components:NSCalendarUnitMonth |NSCalendarUnitDay fromDate:[self.date mn_lastDateOfMonth:self.calendar]];
//  
//  if(dayComponent.day == lastDayOfMonthComponent.day && self.enabled){
//    separatorColor = [[UIColor redColor] CGColor];
//    CGFloat pixel = 1.f / [UIScreen mainScreen].scale;
//    MNContextDrawLine(context,
//                      CGPointMake(size.width - pixel - pixel, pixel),
//                      CGPointMake(size.width - pixel - pixel, size.height),
//                      separatorColor,
//                      pixel);
//  }
  
  if (self.weekday != 7) {
    separatorColor = self.separatorColor.CGColor;
    CGFloat pixel = 1.f / [UIScreen mainScreen].scale;
    MNContextDrawLine(context,
                      CGPointMake(size.width - pixel, pixel),
                      CGPointMake(size.width - pixel, size.height),
                      separatorColor,
                      pixel);
  }
}

@end
