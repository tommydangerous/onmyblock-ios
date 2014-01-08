//
//  OMBRentDepositInfoCell.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 1/7/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBTableViewCell.h"

@interface OMBRentDepositInfoCell : OMBTableViewCell

@property (nonatomic, strong) TextFieldPadding *depositTextField;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) TextFieldPadding *rentTextField;

@end
