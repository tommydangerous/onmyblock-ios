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

// used for alert that the dates chosen are outside the landlord’s preferred dates
@property (nonatomic, strong) UILabel *leaseMonthsLabel;
@property (nonatomic, strong) MNCalendarView *calendarView;

#pragma mark - Methods

#pragma mark - Class Methods

+ (CGFloat) heightForCell;
+ (CGFloat) heightForCellWithAlert;
@end
