//
//  OMBLabelTextFieldCell.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/27/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBTableViewCell.h"

@interface OMBLabelTextFieldCell : OMBTableViewCell

@property (nonatomic, strong) TextFieldPadding *textField;
@property (nonatomic, strong) UILabel *textFieldLabel;

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) setFrameUsingSize: (CGSize) size;
- (void) setFramesUsingString: (NSString *) string;

@end
