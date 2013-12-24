//
//  OMBResidenceBookItCell.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/21/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBTableViewCell.h"

@interface OMBResidenceBookItCell : OMBTableViewCell

@property (nonatomic, strong) UILabel *descriptionLabel;
@property (nonatomic, strong) UILabel *offerLabel;
@property (nonatomic, strong) UILabel *titleLabel;

#pragma mark - Methods

#pragma mark - Class Methods

+ (CGFloat) heightForCell;

#pragma mark - Instance Methods

- (void) setPlaceOfferText;
- (void) setRentItNowText;

@end
