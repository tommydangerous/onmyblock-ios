//
//  OMBResidenceDetailImageCollectionViewCell.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 1/26/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBCollectionViewCell.h"

@class OMBCenteredImageView;
@class OMBResidenceImage;

@interface OMBResidenceDetailImageCollectionViewCell : OMBCollectionViewCell

@property (nonatomic, strong) OMBCenteredImageView *centeredImageView;

#pragma mark - Methods

#pragma mark - Class Methods

+ (NSString *) reuseIdentifierString;

#pragma mark - Instance Methods

- (void) loadResidenceImage: (OMBResidenceImage *) residenceImage;

@end
