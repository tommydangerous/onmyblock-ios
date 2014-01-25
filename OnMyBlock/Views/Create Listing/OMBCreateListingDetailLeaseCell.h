//
//  OMBCreateListingDetailLeaseCell.h
//  OnMyBlock
//
//  Created by Paul Aguilar on 1/23/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBTableViewCell.h"

@class TextFieldPadding;
@interface OMBCreateListingDetailLeaseCell : OMBTableViewCell

@property (nonatomic, strong) UILabel *detailNameLabel;
@property (nonatomic, strong) TextFieldPadding *lenghtLease;

@end
