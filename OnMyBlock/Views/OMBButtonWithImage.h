//
//  OMBButtonWithImage.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 1/29/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBButton.h"

#import "UIColor+Extensions.h"
#import "UIImage+Color.h"

@interface OMBButtonWithImage : OMBButton
{
  UIImageView *imageView;
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) setImage: (UIImage *) image;

@end
