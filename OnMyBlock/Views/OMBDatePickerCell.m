//
//  OMBDatePickerCell.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/30/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBDatePickerCell.h"

@implementation OMBDatePickerCell

#pragma mark - Initializer

- (id) initWithStyle: (UITableViewCellStyle) style 
reuseIdentifier: (NSString *) reuseIdentifier
{ 
  if (!(self = [super initWithStyle: style 
    reuseIdentifier: reuseIdentifier])) return nil;

  self.selectionStyle = UITableViewCellSelectionStyleNone;

  _datePicker = [UIDatePicker new];
  _datePicker.datePickerMode = UIDatePickerModeDate;
  _datePicker.minimumDate    = [NSDate date];
  [self.contentView addSubview: _datePicker];

  return self;
}

#pragma mark - Methods

#pragma mark - Class Methods

+ (CGFloat) heightForCell
{
  return 216.0f;
}

@end
