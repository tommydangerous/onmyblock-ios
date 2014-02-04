//
//  OMBResidenceBookItCalendarCell.h
//  OnMyBlock
//
//  Created by Paul Aguilar on 2/3/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OMBTableViewCell.h"

@class MNCalendarView;

@interface OMBResidenceBookItCalendarCell : OMBTableViewCell

@property (nonatomic, strong) MNCalendarView *calendarView;

+ (CGFloat) heightForCell;

@end
