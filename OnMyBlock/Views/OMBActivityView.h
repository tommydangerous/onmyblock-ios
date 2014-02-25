//
//  OMBActivityView.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/16/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OMBCurvedLineView;

@interface OMBActivityView : UIView
{
  UIActivityIndicatorView *activityIndicatorView;
  UIView *circle;
  OMBCurvedLineView *line;
}

@property (nonatomic) BOOL isSpinning;
@property (nonatomic, strong) UIView *spinner;
@property (nonatomic, strong) UIView *spinnerView;

#pragma mark - Initializer

- (id) initWithAppleSpinner;
- (id) initWithColor: (UIColor *) color;

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) startSpinning;
- (void) stopSpinning;

@end
