//
//  OMBPropertyInfoView.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 10/18/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

@class OMBResidence;

@interface OMBPropertyInfoView : UIView
{
  UIButton *addToFavoritesButton;
  UIImageView *arrowImageView;
  UILabel *bedBathLabel;
  UIImage *minusFavoriteImage;
  UIImage *plusFavoriteImage;
  UILabel *rentLabel;
}

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) OMBResidence *residence;

#pragma mark - Methods

#pragma mark Instance Methods

- (void) loadResidenceData: (OMBResidence *) object;

@end
