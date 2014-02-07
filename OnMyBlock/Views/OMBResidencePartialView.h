//
//  OMBResidencePartialView.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 11/14/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const OMBEmptyResidencePartialViewCell;

@class OMBGradientView;
@class OMBResidence;

@interface OMBResidencePartialView : UIView
<UICollectionViewDataSource, UICollectionViewDelegate, 
  UICollectionViewDelegateFlowLayout>
{
  UIActivityIndicatorView *activityIndicatorView;
  UILabel *addressLabel;
  UIButton *addToFavoritesButton;
  OMBGradientView *addToFavoritesButtonView;
  UIImageView *arrowImageView;
  UILabel *bedBathLabel;
  OMBGradientView *infoView;
  BOOL isDownloadingResidenceImages;
  UIImage *minusFavoriteImage;
  UILabel *offersAndTimeLabel;
  UIImage *plusFavoriteImage;
  UILabel *rentLabel;
}

@property (nonatomic, strong) UICollectionView *imagesFilmstrip;
@property (nonatomic, weak) OMBResidence *residence;
@property (nonatomic, copy) 
  void (^selected) (OMBResidence *residence, NSInteger imageIndex);

#pragma mark - Methods

#pragma mark Instance Methods

- (void) cancelResidenceCoverPhotoDownload;
- (void) downloadResidenceImages;
- (void) loadResidenceData: (OMBResidence *) object;
- (void) resetFilmstrip;

@end
