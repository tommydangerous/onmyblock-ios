//
//  OMBResidenceCollectionViewCell.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 10/24/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OMBResidence;

@interface OMBResidenceCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong, readonly) UILabel *bedBathLabel;
@property (nonatomic, strong, readonly) UIImageView *imageView;
@property (nonatomic, strong, readonly) UILabel *rentLabel;

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) loadResidenceData: (OMBResidence *) residence;

@end
