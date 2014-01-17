//
//  OMBResidenceDetailViewController.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 10/21/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import <MapKit/MapKit.h>

#import "OMBViewController.h"

@class OMBGradientView;
@class OMBMessageDetailViewController;
@class OMBResidence;
@class OMBResidenceImageSlideViewController;

@interface OMBResidenceDetailViewController : OMBViewController
<MKMapViewDelegate, UIScrollViewDelegate, UITableViewDataSource, 
  UITableViewDelegate, UITextViewDelegate>
{
  UIActivityIndicatorView *activityIndicatorView;
  NSTimer *countdownTimer;
  UIImage *favoritedImage;
  OMBMessageDetailViewController *messageDetailViewController;
  UIImage *notFavoritedImage;
  OMBResidence *residence;
}

@property (nonatomic, strong) UIScrollView *imagesScrollView;
@property (nonatomic, strong) OMBResidenceImageSlideViewController
  *imageSlideViewController;
// Array of image views for the images scroll view
@property (nonatomic, strong) NSMutableArray *imageViewArray;
@property (nonatomic, strong) MKMapView *miniMap;
@property (nonatomic, strong) UILabel *pageOfImagesLabel;
@property (nonatomic, strong) UITableView *table;

// Views not in cells
@property (nonatomic, strong) UIButton *bookItButton;
@property (nonatomic, strong) UIView *bottomButtonView;
@property (nonatomic, strong) UIButton *contactMeButton;
@property (nonatomic, strong) UILabel *countDownTimerLabel;
@property (nonatomic, strong) UILabel *currentOfferLabel;
@property (nonatomic, strong) UIButton *favoritesButton;
@property (nonatomic, strong) OMBGradientView *gradientView;
@property (nonatomic, strong) UIView *imagesView;
@property (nonatomic, strong) UILabel *numberOfOffersLabel;

#pragma mark - Initializer

- (id) initWithResidence: (OMBResidence *) object;

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) addImageViewsToImageScrollView;
// - (void) addSimilarResidence: (OMBResidence *) object;
- (void) adjustPageOfImagesLabelFrame;
- (int) currentPageOfImages;

@end
