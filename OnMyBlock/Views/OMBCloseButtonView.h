//
//  OMBCloseButtonView.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 1/15/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OMBCloseButtonView : UIView

@property (nonatomic, strong) UIButton *closeButton;

#pragma mark - Initializer

- (id) initWithFrame: (CGRect) rect color: (UIColor *) color;

@end
