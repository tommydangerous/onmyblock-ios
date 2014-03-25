//
//  OMBOtherUserProfileHeaderCell.h
//  OnMyBlock
//
//  Created by Paul Aguilar on 3/24/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBTableViewCell.h"

@interface OMBOtherUserProfileHeaderCell : OMBTableViewCell

@property UIImageView *iconView;
@property (nonatomic, strong) UILabel *headLabel;

#pragma mark - Methods

#pragma mark - Class Methods

+ (CGFloat) heightForCell;

@end
