//
//  OMBCreateListingPropertyTypeCell.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/26/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBTableViewCell.h"

@interface OMBCreateListingPropertyTypeCell : OMBTableViewCell

@property (nonatomic, strong) UIImageView *propertyTypeImageView;
@property (nonatomic, strong) UILabel *propertyTypeLabel;

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) setFramesForSubviewsWithSize: (CGSize) size;

@end
