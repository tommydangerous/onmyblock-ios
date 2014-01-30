//
//  OMBRenterProfileUserInfoCell.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 1/28/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBTableViewCell.h"

@class OMBUser;

@interface OMBRenterProfileUserInfoCell : OMBTableViewCell

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UILabel *valueLabel;

#pragma mark - Methods

#pragma mark - Class Methods

+ (CGFloat) widthForLabel;

#pragma mark - Instance Methods

- (void) loadUserAbout: (OMBUser *) object;
- (void) reset;

@end
