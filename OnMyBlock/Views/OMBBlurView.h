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
{
  UIImageView *imageView;
}

@property (nonatomic) CGFloat blurRadius;
@property (nonatomic, strong) UIColor *tintColor;

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) refreshWithView: (UIView *) view;

@end
