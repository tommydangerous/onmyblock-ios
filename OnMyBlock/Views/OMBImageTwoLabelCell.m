//
//  OMBImageTwoLabelCell.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 1/6/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBImageTwoLabelCell.h"

@implementation OMBImageTwoLabelCell

#pragma mark - Initializer

- (id) initWithStyle: (UITableViewCellStyle) style 
reuseIdentifier: (NSString *) reuseIdentifier
{
  if (!(self = [super initWithStyle: style reuseIdentifier: reuseIdentifier])) 
    return nil;

  CGRect screen       = [[UIScreen mainScreen] bounds];
  CGFloat screenWidth = screen.size.width;
  CGFloat padding     = 20.0f;

  // Image
  CGFloat imageSize = 22.0f + 22.0f;
  objectImageView.frame = CGRectMake(padding, padding, imageSize, imageSize);
  objectImageView.layer.cornerRadius = imageSize * 0.5f;

  // Top
  CGFloat topLabelOriginX = objectImageView.frame.origin.x + 
    objectImageView.frame.size.width + padding;
  topLabel.frame = CGRectMake(topLabelOriginX, padding, 
    screenWidth - (topLabelOriginX + padding), 22.0f);

  // Middle
  middleLabel.frame = CGRectMake(topLabel.frame.origin.x,
    topLabel.frame.origin.y + topLabel.frame.size.height,
      topLabel.frame.size.width - padding, topLabel.frame.size.height);

  bottomLabel.hidden = YES;

  return self;
}

#pragma mark - Methods

#pragma mark - Class Methods

+ (CGFloat) heightForCell
{
  CGFloat padding = 20.0f;
  return padding + 22.0f + 22.0f + padding;
}

@end
