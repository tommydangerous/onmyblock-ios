//
//  OMBGradientView.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 11/16/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

extern const CGPoint HORIZONTAL_START_POINT;
extern const CGPoint HORIZONTAL_END_POINT;
extern const CGPoint VERTICAL_START_POINT;
extern const CGPoint VERTICAL_END_POINT;

@interface OMBGradientView : UIView

// An Array of UIColors for the gradient
@property (nonatomic, readwrite) NSArray *colors;
@property (nonatomic, readonly) CAGradientLayer *gradientLayer;
// Specifies that the gradient should be drawn horizontally
@property (nonatomic, getter = isHorizontal) BOOL horizontal;

@end
