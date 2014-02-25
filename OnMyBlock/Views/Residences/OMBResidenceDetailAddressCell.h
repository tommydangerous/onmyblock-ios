//
//  OMBResidenceDetailAddressCell.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/17/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBResidenceDetailCell.h"

@interface OMBResidenceDetailAddressCell : OMBResidenceDetailCell

@property (nonatomic, strong) UILabel *addressLabel;
@property (nonatomic, strong) UILabel *bedBathLeaseMonthLabel;
@property (nonatomic, strong) UILabel *mainLabel;
@property (nonatomic, strong) UILabel *propertyTypeLabel;

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) resize;

@end
