//
//  OMBBlurView.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 1/27/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import <Accelerate/Accelerate.h>
#import <UIKit/UIKit.h>

@interface OMBBlurView : UIView

@property (nonatomic) CGFloat blurRadius;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIColor *tintColor;

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) refreshWithImage: (UIImage *) image;
- (void) refreshWithView: (UIView *) view;

@end
