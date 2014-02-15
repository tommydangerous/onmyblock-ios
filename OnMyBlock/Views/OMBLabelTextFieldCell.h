//
//  OMBLabelTextFieldCell.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/27/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBTableViewCell.h"

@interface OMBLabelTextFieldCell : OMBTableViewCell

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) TextFieldPadding *textField;
@property (nonatomic, strong) UILabel *textFieldLabel;

#pragma mark - Methods

#pragma mark - Class Methods

+ (CGFloat) heightForCellWithIconImageView;

#pragma mark - Instance Methods

- (void) setFrameUsingIconImageView;
- (void) setFrameUsingSize: (CGSize) size;
- (void) setFramesUsingString: (NSString *) string;

@end
