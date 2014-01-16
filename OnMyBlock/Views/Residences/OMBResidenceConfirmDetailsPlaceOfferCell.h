//
//  OMBResidenceConfirmDetailsPlaceOfferCell.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/23/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBTableViewCell.h"

@class TextFieldPadding;

@interface OMBResidenceConfirmDetailsPlaceOfferCell : OMBTableViewCell

@property (nonatomic, strong) UILabel *currentOfferLabel;
@property (nonatomic, strong) UIButton *nextStepButton;
@property (nonatomic, strong) TextFieldPadding *yourOfferTextField;

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) disableNextStepButton;
- (void) enableNextStepButton;

@end
