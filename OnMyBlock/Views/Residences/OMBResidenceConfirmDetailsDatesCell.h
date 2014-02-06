//
//  OMBResidenceConfirmDetailsDatesCell.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/23/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBTableViewCell.h"

@class OMBResidence;

@interface OMBResidenceConfirmDetailsDatesCell : OMBTableViewCell
{
  UILabel *moveInLabel;
  UILabel *moveOutLabel;
}

@property (nonatomic, strong) UILabel *leaseMonthsLabel;
@property (nonatomic, strong) UIButton *moveInDateLabel;
@property (nonatomic, strong) UIButton *moveOutDateLabel;

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) highlightMoveInDate;
- (void) highlightMoveOutDate;
- (void) highlightNothing;
- (void) loadResidence: (OMBResidence *) object;
- (void) setMoveInDateLabelText: (NSString *) string;
- (void) setMoveOutDateLabelText: (NSString *) string;

@end
