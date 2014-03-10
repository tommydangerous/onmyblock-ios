//
//  OMBFinishListingAmenityCell.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/28/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBFinishListingAmenityCell.h"

#import "OMBViewController.h"
#import "UIImage+Resize.h"

@interface OMBFinishListingAmenityCell ()
{
  UILabel *amenityLabel;
  UIImage *checkmarkImage;
  UIImage *checkmarkImageFilled;
  UIImageView *checkmarkImageView;
}

@end

@implementation OMBFinishListingAmenityCell

#pragma mark - Initializer

- (id) initWithStyle: (UITableViewCellStyle) style 
reuseIdentifier: (NSString *) reuseIdentifier
{
  if (!(self = [super initWithStyle: style 
    reuseIdentifier: reuseIdentifier])) return nil;

  CGRect screen = [[UIScreen mainScreen] bounds];
  CGFloat screenWidth = screen.size.width;
  CGFloat padding     = OMBPadding;
  
  amenityLabel = [UILabel new];
  amenityLabel.frame = CGRectMake(padding, 0.0f, screenWidth - (padding * 2),
    [OMBFinishListingAmenityCell heightForCell]);
  [self.contentView addSubview: amenityLabel];

  // Checkmark image view
  CGFloat imageWidth = OMBPadding;
  checkmarkImageView = [UIImageView new];
  checkmarkImageView.frame = CGRectMake(screenWidth - (imageWidth + padding),
    ([OMBFinishListingAmenityCell heightForCell] - imageWidth) * 0.5f,
      imageWidth, imageWidth);
  [self.contentView addSubview: checkmarkImageView];

  // Checkmark images
  checkmarkImage = [UIImage image: 
    [UIImage imageNamed: @"checkmark_outline.png"] 
      size: checkmarkImageView.bounds.size];
  checkmarkImageFilled = [UIImage image: 
    [UIImage imageNamed: @"checkmark_outline_filled.png"] 
      size: checkmarkImageView.bounds.size];

  return self; 
}

#pragma mark - Methods

#pragma mark - Class Methods

+ (CGFloat) heightForCell
{
  // 58.0f
  return OMBStandardButtonHeight;
}

#pragma mark - Instance Methods

- (void) setAmenityName: (NSString *) amenity checked: (BOOL) checked
{
  amenityLabel.text = [amenity capitalizedString];
  if (checked) {
    amenityLabel.font      = [UIFont normalTextFontBold];
    amenityLabel.textColor = [UIColor textColor];
    checkmarkImageView.alpha = 1.0f;
    checkmarkImageView.image = checkmarkImageFilled;
  }
  else {
    amenityLabel.font      = [UIFont normalTextFont];
    amenityLabel.textColor = [UIColor grayMedium];
    checkmarkImageView.alpha = 0.3f;
    checkmarkImageView.image = checkmarkImage;
  }
}

@end
