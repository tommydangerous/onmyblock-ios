//
//  OMBResidenceDetailCell.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/17/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBTableViewCell.h"

#import "OMBLabel.h"
#import "UIColor+Extensions.h"

@interface OMBResidenceDetailCell : OMBTableViewCell

@property (nonatomic, strong) OMBLabel *titleLabel;

#pragma mark - Methods

#pragma mark - Class Methods

+ (CGFloat) heightForCell;

@end
