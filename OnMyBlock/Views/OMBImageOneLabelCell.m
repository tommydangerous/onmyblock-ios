//
//  OMBImageOneLabelCell.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 1/7/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBImageOneLabelCell.h"

#import "OMBViewController.h"

@implementation OMBImageOneLabelCell

#pragma mark - Initializer

- (id) initWithStyle: (UITableViewCellStyle) style
reuseIdentifier: (NSString *) reuseIdentifier
{
  if (!(self = [super initWithStyle: style reuseIdentifier: reuseIdentifier]))
    return nil;

  CGRect screen       = [[UIScreen mainScreen] bounds];
  CGFloat screenWidth = screen.size.width;
  CGFloat paddingX = 20.0f;
  CGFloat paddingY = 10.0f;

  // Image
  CGFloat imageSize = [OMBImageOneLabelCell heightForCell] - (paddingY * 2);
  objectImageView.frame = CGRectMake(paddingX, paddingY, imageSize, imageSize);
  objectImageView.layer.cornerRadius = imageSize * 0.5f;

  // Top
  CGFloat topLabelOriginX = objectImageView.frame.origin.x +
    objectImageView.frame.size.width + paddingX;
  topLabel.font = [UIFont fontWithName: @"HelveticaNeue-Light" size: 15];
  topLabel.frame = CGRectMake(topLabelOriginX, paddingY,
    screenWidth - (topLabelOriginX + paddingX),
      objectImageView.frame.size.height);

  middleLabel.hidden = YES;
  bottomLabel.hidden = YES;

  return self;
}

#pragma mark - Methods

#pragma mark - Class Methods

+ (CGFloat) heightForCell
{
  CGFloat paddingY = 10.0f;
  return paddingY + 38.0f + paddingY;
}

+ (CGSize) sizeForImage
{
  return CGSizeMake([OMBImageOneLabelCell heightForCell] - OMBPadding,
    [OMBImageOneLabelCell heightForCell] - OMBPadding);
}

#pragma mark - Instance Methods

- (void) setFont: (UIFont *) font
{
  topLabel.font = font;
}

- (void) setImage: (UIImage *) image text: (NSString *) text
{
  objectImageView.image = image;
  topLabel.text = text;
}

- (void) setTextColor: (UIColor *) color
{
  topLabel.textColor = color;
}

@end
