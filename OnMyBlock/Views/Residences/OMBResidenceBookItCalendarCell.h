//
//  OMBResidenceBookItCalendarCell.h
//  OnMyBlock
//
//  Created by Paul Aguilar on 2/3/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBTableViewCell.h"

@class MNCalendarView;

@interface OMBResidenceBookItCalendarCell : OMBTableViewCell

@property (nonatomic, strong) UILabel *leaseMonthsLabel;
@property (nonatomic, strong) MNCalendarView *calendarView;

#pragma mark - Methods

#pragma mark - Class Methods

+ (CGFloat) heightForCell;

@end
