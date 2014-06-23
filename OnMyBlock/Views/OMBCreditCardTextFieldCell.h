//
//  OMBCreditCardTextFieldCell.h
//  OnMyBlock
//
//  Created by Paul Aguilar on 6/23/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBTwoLabelTextFieldCell.h"

@interface OMBCreditCardTextFieldCell : OMBTwoLabelTextFieldCell
{
  UILabel *expirationSeparator;
}

@property (nonatomic, strong) TextFieldPadding *yearTextField;

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) setFrameUsingIconImageView;

@end
