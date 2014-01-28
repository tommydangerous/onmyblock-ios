//
//  OMBResidenceDetailImageCollectionViewCell.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 1/26/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBResidenceDetailImageCollectionViewCell.h"

#import "OMBCenteredImageView.h"
#import "OMBResidenceImage.h"

@implementation OMBResidenceDetailImageCollectionViewCell

#pragma mark - Initialzer

- (id) initWithFrame: (CGRect) rect
{
  if (!(self = [super initWithFrame: rect])) return nil;

  _imageView = [[OMBCenteredImageView alloc] initWithFrame: self.bounds];
  [self addSubview: _imageView];

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
  _imageView.image = residenceImage.image;
}

@end
