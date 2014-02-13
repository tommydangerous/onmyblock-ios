//
//  UIImage+Color.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 10/23/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "UIImage+Color.h"

@implementation UIImage (Color)

+ (UIImage *) changeColorForImage:(UIImage *)image toColor:(UIColor*)color {
 UIGraphicsBeginImageContext(image.size);
 
 CGRect contextRect;
 contextRect.origin.x = 0.0f;
 contextRect.origin.y = 0.0f;
 contextRect.size = [image size];
 // Retrieve source image and begin image context
 CGSize itemImageSize = [image size];
 CGPoint itemImagePosition; 
 itemImagePosition.x = ceilf((contextRect.size.width - itemImageSize.width) / 2);
 itemImagePosition.y = ceilf((contextRect.size.height - itemImageSize.height) );
 
 UIGraphicsBeginImageContext(contextRect.size);
 
 CGContextRef c = UIGraphicsGetCurrentContext();
 // Setup shadow
 // Setup transparency layer and clip to mask
 CGContextBeginTransparencyLayer(c, NULL);
 CGContextScaleCTM(c, 1.0, -1.0);
 CGContextClipToMask(c, CGRectMake(itemImagePosition.x, -itemImagePosition.y, itemImageSize.width, -itemImageSize.height), [image CGImage]);
 // Fill and end the transparency layer
 
 
 const float* colors = CGColorGetComponents( color.CGColor ); 
 CGContextSetRGBFillColor(c, colors[0], colors[1], colors[2], .75);
 
 contextRect.size.height = -contextRect.size.height;
 contextRect.size.height -= 15;
 CGContextFillRect(c, contextRect);
 CGContextEndTransparencyLayer(c);
 
 UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
 UIGraphicsEndImageContext();
 return img;
}

+ (UIImage *) imageNamed: (NSString *) name withColor: (UIColor *) color
{
  UIImage *img = [UIImage imageNamed:name];

  // begin a new image context, to draw our colored image onto
  UIGraphicsBeginImageContext(img.size);

  // get a reference to that context we created
  CGContextRef context = UIGraphicsGetCurrentContext();

  // set the fill color
  [color setFill];

  // translate/flip the graphics context 
  // (for transforming from CG* coords to UI* coords
  CGContextTranslateCTM(context, 0, img.size.height);
  CGContextScaleCTM(context, 1.0, -1.0);

  // set the blend mode to color burn, and the original image
  CGContextSetBlendMode(context, kCGBlendModeColorBurn);
  CGRect rect = CGRectMake(0, 0, img.size.width, img.size.height);
  CGContextDrawImage(context, rect, img.CGImage);

  // set a mask that matches the shape of the image, 
  // then draw (color burn) a colored rectangle
  CGContextClipToMask(context, rect, img.CGImage);
  CGContextAddRect(context, rect);
  CGContextDrawPath(context,kCGPathFill);

  // generate a new UIImage from the graphics context we drew onto
  UIImage *coloredImg = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();

  //return the color-burned image
  return coloredImg;
}

+ (UIImage *) imageWithColor: (UIColor *) color
{
  CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
  UIGraphicsBeginImageContext(rect.size);
  CGContextRef context = UIGraphicsGetCurrentContext();

  CGContextSetFillColorWithColor(context, [color CGColor]);
  CGContextFillRect(context, rect);

  UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();

  return image;
}

@end
