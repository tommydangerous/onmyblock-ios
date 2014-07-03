//
//  OMBImageTwoTextFieldCell.h
//  OnMyBlock
//
//  Created by Paul Aguilar on 7/3/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBTableViewCell.h"

@class OMBCenteredImageView;
@class OMBGradientView;

@interface OMBImageTwoTextFieldCell : OMBTableViewCell
{
  UIImageView *cameraImageView;
  OMBGradientView *gradientView;
  UILabel *separatorTextfield;
  UIView *tapView;
}

@property (nonatomic, strong) OMBCenteredImageView *userImage;

@property (nonatomic, strong) UIImageView *firstIconImageView;
@property (nonatomic, strong) TextFieldPadding *firstTextField;

@property (nonatomic, strong) UIImageView *secondIconImageView;
@property (nonatomic, strong) TextFieldPadding *secondTextField;

#pragma mark - Methods

#pragma mark - Instance Methods

- (void)addGestureToImage:(UIGestureRecognizer *)gesture;
- (void)setupWithImage:(UIImage *)image;

@end
