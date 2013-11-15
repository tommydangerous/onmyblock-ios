//
//  OMBResidencePartialView.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 11/14/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OMBResidence;

@interface OMBResidencePartialView : UIView
{
  UIActivityIndicatorView *activityIndicatorView;
  UILabel *addressLabel;
  UIButton *addToFavoritesButton;
  UIImageView *arrowImageView;
  UILabel *bedBathLabel;
  UIView *infoView;
  UIImage *minusFavoriteImage;
  UIImage *plusFavoriteImage;
  UILabel *rentLabel;
}

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, weak) OMBResidence *residence;

#pragma mark - Methods

#pragma mark Instance Methods

- (void) loadResidenceData: (OMBResidence *) object;

@end
