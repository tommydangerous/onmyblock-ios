//
//  OMBCenteredImageView.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 11/29/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OMBCenteredImageView : UIView
{
  float height;
  float width;
}

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UIImageView *imageView;

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) setImage: (UIImage *) object;

@end
