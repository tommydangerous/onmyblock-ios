    //
//  OMBResidenceDetailImageCollectionViewCell.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 1/26/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBResidenceDetailImageCollectionViewCell.h"

#import "OMBCenteredImageView.h"
#import "OMBResidence.h"
#import "OMBResidenceImage.h"
#import "UIImageView+WebCache.h"

@implementation OMBResidenceDetailImageCollectionViewCell

#pragma mark - Initialzer

- (id) initWithFrame: (CGRect) rect
{
  if (!(self = [super initWithFrame: rect])) return nil;

  self.centeredImageView = [[OMBCenteredImageView alloc] initWithFrame: self.bounds];
  [self addSubview:self.centeredImageView];

  return self;
}

#pragma mark - Methods

#pragma mark - Class Methods

+ (NSString *) reuseIdentifierString
{
  return NSStringFromClass([self class]);
}

#pragma mark - Instance Methods

- (void) loadResidenceImage: (OMBResidenceImage *) residenceImage
{
  __weak typeof (self.centeredImageView) weakImageView = self.centeredImageView;
  [self.centeredImageView.imageView setImageWithURL: residenceImage.imageURL
    placeholderImage: nil options: SDWebImageRetryFailed completed: 
      ^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        if (error || !image) {
          weakImageView.image = [OMBResidence placeholderImage];
        }
        if (error) {
          NSLog(@"Error: %@, For: %@", error, residenceImage.imageURL);
        }
        else {
          weakImageView.image = image;
        }
      }
    ];
}

@end
