//
//  UILabel+Image.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 4/15/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "UILabel+Image.h"

@implementation UILabel (Image)

- (UIImage *)grabImage {
    // Create a "canvas" (image context) to draw in.
    // UIGraphicsBeginImageContext([self bounds].size);
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, 0.0);

    // Make the CALayer to draw in our "canvas".
    [[self layer] renderInContext: UIGraphicsGetCurrentContext()];

    // Fetch an UIImage of our "canvas".
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();

    // Stop the "canvas" from accepting any input.
    UIGraphicsEndImageContext();

    // Return the image.
    return image;
}

@end
