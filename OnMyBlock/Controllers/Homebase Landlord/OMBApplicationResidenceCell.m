//
//  OMBApplicationResidenceCell.m
//  OnMyBlock
//
//  Created by Paul Aguilar on 6/6/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBApplicationResidenceCell.h"

#import "OMBResidence.h"
#import "UIImageView+WebCache.h"

@implementation OMBApplicationResidenceCell

#pragma mark - Initializer

- (id) initWithStyle: (UITableViewCellStyle) style
     reuseIdentifier: (NSString *) reuseIdentifier
{
  if (!(self = [super initWithStyle: style reuseIdentifier: reuseIdentifier]))
    return nil;
  
  self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
  
  return self;
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) loadResidence: (OMBResidence *) object
{
  // Image
  NSString *sizeKey = [NSString stringWithFormat: @"%f,%f",
    objectImageView.bounds.size.width, objectImageView.bounds.size.height];
  UIImage *image = [object coverPhotoForSizeKey: sizeKey];
  if (image) {
    objectImageView.image = image;
  }
  else {
    __weak typeof(objectImageView) weakObjectImageView = objectImageView;
    [object downloadCoverPhotoWithCompletion: ^(NSError *error) {
      [weakObjectImageView.imageView setImageWithURL:
       object.coverPhotoURL placeholderImage: nil
                                             options: SDWebImageRetryFailed completed:
       ^(UIImage *img, NSError *error, SDImageCacheType cacheType) {
         weakObjectImageView.image = img;
         [object.coverPhotoSizeDictionary setObject:
          weakObjectImageView.image forKey: sizeKey];
       }
       ];
    }];
    objectImageView.image = [OMBResidence placeholderImage];
  }
  // Title
  if (object.title && [object.title length])
    topLabel.text = object.title;
  else
    topLabel.text = [object.address capitalizedString];
  // Address
  middleLabel.text = [object.address capitalizedString];
  // City, state
  thirdLabel.text = [NSString stringWithFormat: @"%@, %@",
    [object.city capitalizedString], object.state];
  
  fourthlabel.text =  [NSString stringWithFormat:
    @"%.0f bd / %.0f ba", object.bedrooms, object.bathrooms];
}

@end
