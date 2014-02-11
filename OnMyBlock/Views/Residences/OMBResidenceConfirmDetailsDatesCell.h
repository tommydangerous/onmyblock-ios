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
@property (nonatomic, strong) UIView *moveInBackground;
@property (nonatomic, strong) UIButton *moveInButton;
@property (nonatomic, strong) UILabel *moveInDateLabel;
@property (nonatomic, strong) UIView *moveOutBackground;
@property (nonatomic, strong) UIButton *moveOutButton;
@property (nonatomic, strong) UILabel *moveOutDateLabel;

#pragma mark - Methods

#pragma mark - Class Methods

+ (CGFloat) heightForCellWithNoLeaseMonthLabel;

#pragma mark - Instance Methods

- (void) highlightMoveInDate;
- (void) highlightMoveOutDate;
- (void) highlightNothing;
- (void) loadResidence: (OMBResidence *) object;

@end