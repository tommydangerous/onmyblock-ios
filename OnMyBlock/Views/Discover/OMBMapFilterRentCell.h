//
//  OMBMapFilterRentCell.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/20/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBTableViewCell.h"

@class TextFieldPadding;

@interface OMBMapFilterRentCell : OMBTableViewCell

//@property (nonatomic, strong) TextFieldPadding *maxRentTextField;
@property (nonatomic, strong) TextFieldPadding *rentRangeTextField;

#pragma mark - Methods

#pragma mark - Class Methods

+ (CGFloat) widthForTextField;

@end
