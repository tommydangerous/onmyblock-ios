//
//  OMBManageListingDetailEditCell.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 4/15/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBTableViewCell.h"

@interface OMBManageListingDetailEditCell : OMBTableViewCell

@property (nonatomic, strong) UILabel *bottomLabel;
@property (nonatomic, strong) UILabel *middleLabel;
@property (nonatomic, strong) UILabel *topLabel;

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) setImage: (UIImage *) image;

@end
