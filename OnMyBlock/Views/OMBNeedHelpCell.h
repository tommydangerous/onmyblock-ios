//
//  OMBNeedHelpCell.h
//  OnMyBlock
//
//  Created by Paul Aguilar on 8/18/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBTableViewCell.h"

@class OMBBlurView;

@interface OMBNeedHelpCell : OMBTableViewCell
{
  OMBBlurView *backgroundView;
  UIView *tintView;
}

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *secondLabel;

#pragma mark - Methods

#pragma mark - Instance Methods

- (void)addCallButton;
- (void)disableTintView;
- (void)setBackgroundImage:(NSString *)nameImage withBlur:(BOOL)blur;

@end
