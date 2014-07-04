//
//  OMBMapResidenceDetailCell.m
//  OnMyBlock
//
//  Created by Paul Aguilar on 4/4/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBMapResidenceDetailCell.h"

#import "NSString+Extensions.h"
#import "OMBCenteredImageView.h"
#import "OMBResidence.h"
#import "OMBResidenceCoverPhotoDownloader.h"
#import "OMBViewController.h"
#import "UIFont+OnMyBlock.h"
#import "UIColor+Extensions.h"
#import "UIImageView+WebCache.h"

@interface OMBMapResidenceDetailCell ()
{
  OMBCenteredImageView *coverPhoto;
  UILabel *bedBathLabel;
  UILabel *rentLabel;
  UILabel *titleLabel;
}

@end

@implementation OMBMapResidenceDetailCell

#pragma mark - Initialize

- (id) initWithStyle: (UITableViewCellStyle) style
reuseIdentifier: (NSString *) reuseIdentifier
{
  if (!(self = [super initWithStyle: style reuseIdentifier: reuseIdentifier]))
    return nil;

  self.backgroundColor = [UIColor whiteColor];

  CGRect screen   = [UIScreen mainScreen].bounds;
  CGFloat padding = OMBPadding;
  CGFloat heightCell   = (screen.size.height * 0.5f) / 3.0f;
  CGFloat originLabely = (heightCell - (33 + 22 + (padding * 0.5f))) * 0.5f;

  // Image residence
  coverPhoto = [[OMBCenteredImageView alloc] init];
  coverPhoto.frame = CGRectMake(0.0f, 0.0f, heightCell, heightCell);
  coverPhoto.image = [OMBResidence placeholderImage];
  [self.contentView addSubview: coverPhoto];

  rentLabel = [UILabel new];
  rentLabel.font = [UIFont mediumLargeTextFont];
  rentLabel.frame = CGRectMake(coverPhoto.frame.origin.x +
    coverPhoto.frame.size.width + (padding * 0.5f), originLabely,
      0.0f, 33.f);
  rentLabel.textAlignment = NSTextAlignmentLeft;
  rentLabel.textColor = [UIColor textColor];
  [self.contentView addSubview: rentLabel];

  bedBathLabel = [UILabel new];
  bedBathLabel.font = [UIFont normalTextFont];
  bedBathLabel.frame = CGRectMake(self.frame.size.width * 0.5f,
    rentLabel.frame.origin.y + (padding * 0.25f), 0.f, 22.f);
  bedBathLabel.textAlignment = rentLabel.textAlignment;
  bedBathLabel.textColor = [UIColor textColor];
  [self.contentView addSubview: bedBathLabel];

  titleLabel = [UILabel new];
  titleLabel.font = [UIFont normalTextFont];
  titleLabel.frame = CGRectMake(rentLabel.frame.origin.x,
    rentLabel.frame.origin.y + rentLabel.frame.size.height +
      padding * 0.25f, self.frame.size.width - (heightCell + (padding * 1.5f)), 
        22.f);
  titleLabel.textAlignment = rentLabel.textAlignment;
  titleLabel.textColor = [UIColor grayMedium];
  [self.contentView addSubview: titleLabel];

  return self;
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) loadResidenceData:(OMBResidence *)object;
{
  _residence = object;

  CGRect screen = [UIScreen mainScreen].bounds;
  CGFloat padding = OMBPadding;
  CGFloat heightCell = (screen.size.height * 0.5f) / 3.0f;

  // Image
  NSString *sizeKey = [NSString stringWithFormat: @"%f,%f",
    coverPhoto.frame.size.width, coverPhoto.frame.size.height];
  UIImage *image = [object coverPhotoForSizeKey: sizeKey];
  if (image) {
    coverPhoto.image = image;
  }
  else {
    __weak typeof(coverPhoto) weakCoverPhoto = coverPhoto;
    [object downloadCoverPhotoWithCompletion: ^(NSError *error) {
      [weakCoverPhoto.imageView setImageWithURL:
         object.coverPhotoURL placeholderImage: nil
           options: SDWebImageRetryFailed completed:
           ^(UIImage *img, NSError *error, SDImageCacheType cacheType) {
            if (img && !error) {
              weakCoverPhoto.image = img;
              [object.coverPhotoSizeDictionary setObject:
                weakCoverPhoto.image forKey: sizeKey];
            }
            else {
              weakCoverPhoto.image = [OMBResidence placeholderImage];
            }
         }
       ];
    }];
  }

  // Rent
  rentLabel.text = [NSString numberToCurrencyString:_residence.minRent];
  CGFloat rentWidth = [rentLabel.text boundingRectWithSize:
    CGSizeMake(screen.size.width - heightCell - padding, 
      rentLabel.frame.size.height) font: rentLabel.font].size.width;
  CGRect rentRect = rentLabel.frame;
  rentRect.size.width = rentWidth;
  rentLabel.frame = rentRect;

  // Bedrooms / Bathrooms

  // Bedrooms
  NSString *bedsString = @"bd";
  // if (_residence.bedrooms == 1)
  //   bedsString = @"bed";
  NSString *bedsNumberString;
  if (_residence.bedrooms == (int) _residence.bedrooms)
    bedsNumberString = [NSString stringWithFormat: @"%i",
      (int) _residence.bedrooms];
  else
    bedsNumberString = [NSString stringWithFormat: @"%.01f",
      _residence.bedrooms];
  NSString *beds = [NSString stringWithFormat: @"%@ %@",
    bedsNumberString, bedsString];
  // Bathrooms
  NSString *bathsString = @"ba";
  // if (_residence.bathrooms == 1)
  //   bathsString = @"bath";
  NSString *bathsNumberString;
  if (_residence.bathrooms == (int) _residence.bathrooms)
    bathsNumberString = [NSString stringWithFormat: @"%i",
      (int) _residence.bathrooms];
  else
    bathsNumberString = [NSString stringWithFormat: @"%.01f",
      _residence.bathrooms];
  NSString *baths = [NSString stringWithFormat: @"%@ %@",
    bathsNumberString, bathsString];

  bedBathLabel.text = [NSString stringWithFormat: @"%@ / %@", beds, baths];
  CGRect bedBathRect = bedBathLabel.frame;
  bedBathRect.origin.x = rentLabel.frame.origin.x +
    rentLabel.frame.size.width + padding * 0.5f;
  CGFloat maxWidtBedBath = screen.size.width -
    bedBathRect.origin.x - padding;
  CGFloat widthBedBath = [bedBathLabel.text
    boundingRectWithSize:CGSizeMake(
      maxWidtBedBath, bedBathLabel.frame.size.height)
        font:bedBathLabel.font].size.width;
  if(widthBedBath > maxWidtBedBath)
    widthBedBath = maxWidtBedBath;
  bedBathRect.size.width = widthBedBath;
  bedBathLabel.frame = bedBathRect;

  // Address or title
  titleLabel.text = [self.residence addressOrTitle];
}

@end
