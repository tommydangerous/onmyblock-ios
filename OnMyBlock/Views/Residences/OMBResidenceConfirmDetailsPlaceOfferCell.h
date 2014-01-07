//
//  OMBResidenceConfirmDetailsPlaceOfferCell.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/23/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBTableViewCell.h"

@class TextFieldPadding;

@interface OMBResidenceConfirmDetailsPlaceOfferCell : OMBTableViewCell

@property (nonatomic, strong) UILabel *currentOfferLabel;
@property (nonatomic, strong) TextFieldPadding *yourOfferTextField;

@end
