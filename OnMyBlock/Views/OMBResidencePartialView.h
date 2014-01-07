//
//  OMBResidencePartialView.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 11/14/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OMBGradientView;
@class OMBResidence;

@interface OMBResidencePartialView : UIView
{
  UIActivityIndicatorView *activityIndicatorView;
  UILabel *addressLabel;
  UIButton *addToFavoritesButton;
  OMBGradientView *addToFavoritesButtonView;
  UIImageView *arrowImageView;
  UILabel *bedBathLabel;
  OMBGradientView *infoView;
  UIImage *minusFavoriteImage;
  UILabel *offersAndTimeLabel;
  UIImage *plusFavoriteImage;
  UILabel *rentLabel;
}

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, weak) OMBResidence *residence;

#pragma mark - Methods

#pragma mark Instance Methods

- (void) loadResidenceData: (OMBResidence *) object;

@end
