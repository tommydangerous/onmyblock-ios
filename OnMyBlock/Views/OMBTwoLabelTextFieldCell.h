//
//  OMBTwoLabelTextFieldCell.h
//  OnMyBlock
//
//  Created by Paul Aguilar on 2/18/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBTableViewCell.h"

@interface OMBTwoLabelTextFieldCell : OMBTableViewCell

@property (nonatomic, strong) UIImageView *firstIconImageView;
@property (nonatomic, strong) TextFieldPadding *firstTextField;
@property (nonatomic, strong) UILabel *firstTextFieldLabel;
@property (nonatomic, strong) UIImageView *secondIconImageView;
@property (nonatomic, strong) TextFieldPadding *secondTextField;
@property (nonatomic, strong) UILabel *secondTextFieldLabel;

@property (nonatomic, strong) UIView *viewBackground;
//Added for handling Expiry date
@property (nonatomic, strong) TextFieldPadding *thirdTextField;
@property (nonatomic, strong) UILabel *labelSeparator;

#pragma mark - Methods

#pragma mark - Class Methods

+ (CGFloat) heightForCellWithIconImageView;
+ (CGFloat) heightForCellWithLeftLabelIconImageView;

#pragma mark - Instance Methods

- (void) setFrameUsingIconImageView;
- (void) setFrameUsingLabelSize:(CGSize)size;
- (void) setFrameUsingLeftLabelIconImageView;

@end
