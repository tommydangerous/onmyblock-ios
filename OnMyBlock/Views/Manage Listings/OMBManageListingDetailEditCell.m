//
//  OMBManageListingDetailEditCell.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 4/15/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBManageListingDetailEditCell.h"

#import "OMBViewController.h"
#import "UIColor+Extensions.h"
#import "UIFont+OnMyBlock.h"

@interface OMBManageListingDetailEditCell ()
{
  UIImageView *imageView;
}

@end

@implementation OMBManageListingDetailEditCell

#pragma mark - Initializer

- (id) initWithStyle: (UITableViewCellStyle) style
reuseIdentifier: (NSString *) reuseIdentifier
{
  if (!(self = [super initWithStyle: style reuseIdentifier: reuseIdentifier]))
    return nil;

  CGRect screen = [[UIScreen mainScreen] bounds];
  CGFloat padding = OMBPadding;

  CGFloat imageWidth = [OMBManageListingDetailEditCell sizeForImage].width;
  imageView = [UIImageView new];
  imageView.alpha = 0.3f;
  imageView.frame = CGRectMake(padding,
    ([OMBManageListingDetailEditCell heightForCell] - imageWidth) * 0.5f,
      imageWidth, imageWidth);
  [self.contentView addSubview: imageView];

  CGFloat originX = imageView.frame.origin.x + imageView.frame.size.width +
    padding;
  _topLabel = [UILabel new];
  _topLabel.font = [UIFont normalTextFontBold];
  _topLabel.frame = CGRectMake(originX, padding,
    screen.size.width - (originX + padding), 22.0f);
  _topLabel.textColor = [UIColor textColor];
  [self.contentView addSubview: _topLabel];

  _middleLabel = [UILabel new];
  _middleLabel.font = [UIFont normalSmallTextFont];
  _middleLabel.frame = CGRectMake(_topLabel.frame.origin.x,
    _topLabel.frame.origin.y + _topLabel.frame.size.height,
      _topLabel.frame.size.width, 22.0f);
  _middleLabel.textColor = [UIColor grayDark];
  [self.contentView addSubview: _middleLabel];

  UILabel *editLabel = [UILabel new];
  editLabel.font = [UIFont normalSmallTextFontBold];
  editLabel.frame = CGRectMake(originX + _middleLabel.frame.size.width -
    (padding * 2), _middleLabel.frame.origin.y, padding * 2,
      _middleLabel.frame.size.height);
  editLabel.text = @"Edit";
  editLabel.textAlignment = NSTextAlignmentRight;
  editLabel.textColor = [UIColor blue];
  [self.contentView addSubview: editLabel];

  _bottomLabel = [UILabel new];
  _bottomLabel.font = [UIFont normalSmallTextFont];
  _bottomLabel.frame = CGRectMake(_topLabel.frame.origin.x,
    _middleLabel.frame.origin.y + _middleLabel.frame.size.height,
      _topLabel.frame.size.width, _middleLabel.frame.size.height);
  _bottomLabel.textColor = [UIColor grayDark];
  [self.contentView addSubview: _bottomLabel];

  return self;
}

#pragma mark - Methods

#pragma mark - Class Methods

+ (CGFloat) heightForCell
{
  return OMBPadding + 22.0f + 22.0f + 22.0f + OMBPadding;
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
