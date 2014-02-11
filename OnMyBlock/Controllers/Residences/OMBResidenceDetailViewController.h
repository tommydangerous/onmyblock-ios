//
//  OMBResidenceDetailViewController.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 10/21/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import <MapKit/MapKit.h>

#import "OMBViewController.h"

@class LEffectLabel;
@class OMBBlurView;
@class OMBCloseButtonView;
@class OMBCollectionView;
@class OMBExtendedHitAreaViewContainer;
@class OMBGradientView;
@class OMBMessageDetailViewController;
@class OMBResidence;
@class OMBResidenceImageSlideViewController;

@interface OMBResidenceDetailViewController : OMBViewController
<MKMapViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate,
  UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate, 
    UITextViewDelegate>
{
  UIActivityIndicatorView *activityIndicatorView;
  CGFloat backViewOffsetY;
  OMBBlurView *blurView;
  NSTimer *countdownTimer;
  CGFloat currentOfferOriginY;
  LEffectLabel *effectLabel;
  UIImage *favoritedImage;
  OMBGradientView *gradientView;
  OMBExtendedHitAreaViewContainer *headerView;
  OMBCollectionView *imageCollectionView;
  UIScrollView *imageScrollView;
  OMBCloseButtonView *imageScrollViewCloseButton;
  MKMapView *map;
  OMBMessageDetailViewController *messageDetailViewController;
  UIImage *notFavoritedImage;
  OMBResidence *residence;
}

@property (nonatomic, strong) OMBResidenceImageSlideViewController
  *imageSlideViewController;

@property (nonatomic, strong) UIButton *bookItButton;
@property (nonatomic, strong) UIView *bottomButtonView;
@property (nonatomic, strong) UIButton *contactMeButton;
@property (nonatomic, strong) UILabel *countDownTimerLabel;
@property (nonatomic, strong) UILabel *currentOfferLabel;
@property (nonatomic, strong) UIButton *favoritesButton;
@property (nonatomic, strong) UILabel *numberOfOffersLabel;
@property (nonatomic, strong) UILabel *pageOfImagesLabel;
@property (nonatomic, strong) UITableView *table;

#pragma mark - Initializer

- (id) initWithResidence: (OMBResidence *) object;

#pragma mark - Methods

#pragma mark - Instance Methods

@end
