//
//  OMBStudentOrLandlordView.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 1/28/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBView.h"

@class AMBlurView;
@class OMBBlurView;
@class OMBCloseButtonView;

@interface OMBStudentOrLandlordView : OMBView
{
  OMBBlurView *blurView;
  AMBlurView *boxView;
}

@property (nonatomic, strong) OMBCloseButtonView *closeButtonView;
@property (nonatomic, strong) UIButton *landlordButton;
@property (nonatomic, strong) UIButton *studentButton;

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) hide;
- (void) showFromView: (UIView *) view;

@end
