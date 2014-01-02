//
//  OMBMapFilterPlusMinusCell.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 1/2/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBTableViewCell.h"

@interface OMBMapFilterPlusMinusCell : OMBTableViewCell

@property (nonatomic, strong) NSNumber *currentValue;
@property (nonatomic, strong) UIButton *minusButton;
@property (nonatomic, strong) UIButton *plusButton;
@property (nonatomic, strong) UILabel *valueLabel;

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) changeCurrentValue: (UIButton *) button;
- (void) setValueLabelText;

@end
