//
//  OMBNeedHelpCell.h
//  OnMyBlock
//
//  Created by Paul Aguilar on 8/18/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBTableViewCell.h"

@interface OMBNeedHelpCell : OMBTableViewCell
{
  UIImageView *backgroundView;
}

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *secondLabel;

#pragma mark - Methods

#pragma mark - Instance Methods

- (void)setBackgroundImage:(NSString *)nameImage;

@end
