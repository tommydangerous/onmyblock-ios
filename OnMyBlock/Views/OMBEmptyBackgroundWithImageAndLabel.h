//
//  OMBEmptyBackgroundWithImageAndLabel.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 1/31/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBView.h"

@interface OMBEmptyBackgroundWithImageAndLabel : OMBView

@property (nonatomic, strong) UIButton *startButton;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *label;

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) setLabelText: (NSString *) string;
- (void) setButtonText: (NSString *) string;
@end
