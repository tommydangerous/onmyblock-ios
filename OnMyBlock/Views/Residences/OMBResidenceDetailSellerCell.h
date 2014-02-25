//
//  OMBResidenceDetailSellerCell.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/17/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBResidenceDetailCell.h"

@class OMBCenteredImageView;
@class OMBResidence;

@interface OMBResidenceDetailSellerCell : OMBResidenceDetailCell

@property (nonatomic, strong) UILabel *aboutLabel;
@property (nonatomic, strong) OMBCenteredImageView *sellerImageView;

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) loadResidenceData: (OMBResidence *) residence;

@end
