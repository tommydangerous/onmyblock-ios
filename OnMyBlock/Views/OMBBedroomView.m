//
//  OMBBedroomView.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 11/25/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBBedroomView.h"

@implementation OMBBedroomView

- (id) initWithFrame: (CGRect) rect
{
  if (!(self = [super initWithFrame: rect])) return nil;
  // Bed
  // image 405 x 246
  UIImage *bedImage = [UIImage imageNamed: @"bed_image.png"];
  float bedImageHeight = bedImage.size.height;
  float bedImageWidth  = bedImage.size.width;
  // image view
  UIImageView *bedImageView = [[UIImageView alloc] init];
  float bedImageViewWidth  = self.frame.size.width;
  float bedImageViewHeight = bedImageViewWidth * 
    (bedImageHeight / bedImageWidth);
  bedImageView.frame = CGRectMake(0, 
    (self.frame.size.height - bedImageViewHeight), 
      bedImageViewWidth, bedImageViewHeight);
  bedImageView.image = bedImage;
  [self addSubview: bedImageView];

  // Picture frame
  UIImage *pictureFrameImage = [UIImage imageNamed: @"picture_frame_image.png"];
  float pictureFrameImageHeight = pictureFrameImage.size.height;
  float pictureFrameImageWidth  = pictureFrameImage.size.width;
  // image view
  UIImageView *pictureFrameImageView = [[UIImageView alloc] init];
  float pictureFrameImageViewWidth  = self.frame.size.width * 0.7;
  float pictureFrameImageViewHeight = pictureFrameImageViewWidth * 
    (pictureFrameImageHeight / pictureFrameImageWidth);
  pictureFrameImageView.frame = CGRectMake(
    (-1 * (pictureFrameImageWidth * 0.5)), 0, 
      pictureFrameImageViewWidth, pictureFrameImageViewHeight);
  pictureFrameImageView.image = pictureFrameImage;
  [self addSubview: pictureFrameImageView];

  return self;
}

@end
