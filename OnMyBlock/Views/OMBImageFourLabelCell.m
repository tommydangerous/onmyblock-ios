//
//  OMBImageFourLabelCell.m
//  OnMyBlock
//
//  Created by Paul Aguilar on 6/6/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBImageFourLabelCell.h"

@implementation OMBImageFourLabelCell

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
  CGFloat imageSize = 22.0f + 22.0f + 22.0f;
  CGFloat imageOrigin = ([OMBImageFourLabelCell heightForCell] - imageSize) * .5f;
  
  objectImageView = [[OMBCenteredImageView alloc] init];
  objectImageView.frame = CGRectMake(padding, imageOrigin, imageSize, imageSize);
  objectImageView.layer.cornerRadius = imageSize * 0.5f;
  [self.contentView addSubview: objectImageView];
  
  // Top
  topLabel = [UILabel new];
  topLabel.font = [UIFont fontWithName: @"HelveticaNeue-Medium" size: 15];
  CGFloat topLabelOriginX = objectImageView.frame.origin.x +
  objectImageView.frame.size.width + padding;
  topLabel.frame = CGRectMake(topLabelOriginX, padding,
     screenWidth - (topLabelOriginX + padding), 22.0f);
  topLabel.textColor = [UIColor textColor];
  [self.contentView addSubview: topLabel];
  
  // Middle
  middleLabel = [UILabel new];
  middleLabel.font = [UIFont fontWithName: @"HelveticaNeue-Light" size: 15];
  middleLabel.frame = CGRectMake(topLabel.frame.origin.x,
    topLabel.frame.origin.y + topLabel.frame.size.height,
    topLabel.frame.size.width - padding, topLabel.frame.size.height);
  middleLabel.textColor = [UIColor grayMedium];
  [self.contentView addSubview: middleLabel];
  
  // Bottom
  thirdLabel = [UILabel new];
  thirdLabel.font = middleLabel.font;
  thirdLabel.frame = CGRectMake(middleLabel.frame.origin.x,
    middleLabel.frame.origin.y + middleLabel.frame.size.height,
    middleLabel.frame.size.width, middleLabel.frame.size.height);
  thirdLabel.textColor = middleLabel.textColor;
  [self.contentView addSubview: thirdLabel];
  
  
  // Bottom
  fourthlabel = [UILabel new];
  fourthlabel.font = thirdLabel.font;
  fourthlabel.frame = CGRectMake(thirdLabel.frame.origin.x,
    thirdLabel.frame.origin.y + thirdLabel.frame.size.height,
    thirdLabel.frame.size.width, thirdLabel.frame.size.height);
  fourthlabel.textColor = thirdLabel.textColor;
  [self.contentView addSubview: fourthlabel];
  
  return self;
}

#pragma mark - Methods

#pragma mark - Class Methods

+ (CGFloat) heightForCell
{
  CGFloat padding = 20.0f;
  return padding + 22.0f + 22.0f + 22.0f + 22.f + padding;
}

#pragma mark - Instance Methods

- (void) setImageViewAlpha: (CGFloat) value
{
  objectImageView.alpha = value;
}

- (void) setImageViewCircular: (BOOL) isCircular
{
  if (isCircular) {
    objectImageView.layer.cornerRadius =
    objectImageView.frame.size.height * 0.5f;
  }
  else {
    objectImageView.layer.cornerRadius = 0.0f;
  }
}

@end
