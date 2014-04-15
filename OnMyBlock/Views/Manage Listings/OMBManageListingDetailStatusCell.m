//
//  OMBManageListingDetailStatusCell.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 4/15/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBManageListingDetailStatusCell.h"

#import "OMBViewController.h"

@interface OMBManageListingDetailStatusCell ()
{
  UIImageView *imageView;
}

@end

@implementation OMBManageListingDetailStatusCell

#pragma mark - Initializer

- (id) initWithStyle: (UITableViewCellStyle) style
reuseIdentifier: (NSString *)reuseIdentifier
{
  if (!(self = [super initWithStyle: style reuseIdentifier: reuseIdentifier]))
    return nil;

  CGRect screen = [[UIScreen mainScreen] bounds];
  CGFloat padding = OMBPadding;

  CGFloat imageWidth = [OMBManageListingDetailStatusCell sizeForImage].width;
  imageView = [UIImageView new];
  imageView.alpha = 0.3f;
  imageView.frame = CGRectMake(padding,
    ([OMBManageListingDetailStatusCell heightForCell] - imageWidth) * 0.5f,
      imageWidth, imageWidth);
  [self.contentView addSubview: imageView];

  CGFloat originX = imageView.frame.origin.x + imageView.frame.size.width +
    padding;
  self.textFieldLabel.font = [UIFont normalTextFontBold];
  self.textFieldLabel.frame = CGRectMake(originX, padding,
    screen.size.width - (originX + padding), 22.0f);
  self.textFieldLabel.textColor = [UIColor textColor];

  switchButton.frame = CGRectMake(originX +
    self.textFieldLabel.frame.size.width - switchButton.frame.size.width,
      ([OMBManageListingDetailStatusCell heightForCell] -
        switchButton.frame.size.height) * 0.5f,
          switchButton.frame.size.width, switchButton.frame.size.height);
  switchButton.onTintColor = [UIColor blue];

  return self;
}

#pragma mark - Methods

#pragma mark - Class Methods

+ (CGFloat) heightForCell
{
  return OMBStandardButtonHeight;
}

+ (CGSize) sizeForImage
{
  return CGSizeMake(OMBStandardButtonHeight - OMBPadding,
    OMBStandardButtonHeight - OMBPadding);
}

#pragma mark - Instance Methods

- (void) setImage: (UIImage *) image
{
  imageView.image = image;
}

@end
