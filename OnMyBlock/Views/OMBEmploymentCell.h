//
//  OMBEmploymentCell.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/10/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBTableViewCell.h"

@class OMBEmployment;

@interface OMBEmploymentCell : OMBTableViewCell
{
  UILabel *companyNameLabel;
  UILabel *startDateEndDateLabel;
  UILabel *titleIncomeLabel;
}

@property (nonatomic, strong) UIButton *companyWebsiteButton;
@property (nonatomic, weak) id delegate;
@property (nonatomic, weak) OMBEmployment *employment;

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) loadData: (OMBEmployment *) object;

@end
