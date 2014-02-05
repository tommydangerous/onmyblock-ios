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

@property (nonatomic, strong) UIButton *moveInDateButton;
@property (nonatomic, strong) UIButton *moveOutDateButton;

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) loadResidence: (OMBResidence *) object;

@end
