//
//  OMBPayoutMethodCell.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/11/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBTableViewCell.h"

@interface OMBPayoutMethodCell : OMBTableViewCell

@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UIView *iconView;
@property (nonatomic, strong) UIColor *iconViewBackgroundColor;

@end
