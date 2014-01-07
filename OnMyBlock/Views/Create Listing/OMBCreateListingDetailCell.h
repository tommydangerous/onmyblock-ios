//
//  OMBCreateListingDetailCell.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/27/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBTableViewCell.h"

@interface OMBCreateListingDetailCell : OMBTableViewCell

// Bedrooms, Bathrooms, Month Lease, etc.
@property (nonatomic, strong) UILabel *detailNameLabel;
@property (nonatomic, strong) UIButton *minusButton;
@property (nonatomic, strong) UIButton *plusButton;
// 5, 4, 3, 2, 1, etc.
@property (nonatomic, strong) UILabel *valueLabel;

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) setFramesForSubviewsWithSize: (CGSize) size;

@end
