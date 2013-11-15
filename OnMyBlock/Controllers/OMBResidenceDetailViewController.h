//
//  OMBResidenceDetailViewController.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 10/21/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import <MapKit/MapKit.h>

#import "OMBViewController.h"

@class OMBResidence;
@class OMBResidenceImageSlideViewController;

@interface OMBResidenceDetailViewController : OMBViewController
<MKMapViewDelegate, UIScrollViewDelegate, UITableViewDataSource, 
  UITableViewDelegate, UITextViewDelegate>
{
  UIActivityIndicatorView *activityIndicatorView;
  UIButton *bottomButton;
  UIButton *callButton;
  CALayer *descriptionBorderBottom;
  UIImage *favoritePinkImage;
  UIImage *favoriteWhiteImage;
  CALayer *infoViewBorderBottom;
  OMBResidence *residence;
  BOOL showContactTextView;
  NSMutableArray *similarResidences;
}

@property (nonatomic, strong) UILabel *addressLabel;
@property (nonatomic, strong) UIButton *addToFavoritesButton;
@property (nonatomic, strong) UIView *addToFavoritesView;
@property (nonatomic, strong) UILabel *availableLabel;
@property (nonatomic, strong) UIView *availableView;
@property (nonatomic, strong) UILabel *bathLabel;
@property (nonatomic, strong) UILabel *bathSubLabel;
@property (nonatomic, strong) UILabel *bedLabel;
@property (nonatomic, strong) UILabel *bedSubLabel;
@property (nonatomic, strong) UIButton *contactButton;
@property (nonatomic, strong) UITextView *contactTextView;
@property (nonatomic, strong) UIView *contactView;
@property (nonatomic, strong) UILabel *descriptionLabel;
@property (nonatomic, strong) UIView *descriptionView;
@property (nonatomic, strong) UIScrollView *imagesScrollView;
@property (nonatomic, strong) UIView *infoView;
@property (nonatomic, strong) OMBResidenceImageSlideViewController
  *imageSlideViewController;
// Array of image views for the images scroll view
@property (nonatomic, strong) NSMutableArray *imageViewArray;
@property (nonatomic, strong) UILabel *leaseMonthLabel;
@property (nonatomic, strong) UIView *leaseMonthView;
@property (nonatomic, strong) UIView *map;
@property (nonatomic, strong) MKMapView *miniMap;
@property (nonatomic, strong) UILabel *pageOfImagesLabel;
@property (nonatomic, strong) UILabel *rentLabel;
@property (nonatomic, strong) UIView *similarResidenceBottomView;
@property (nonatomic, strong) UIView *similarResidencesView;
@property (nonatomic, strong) UILabel *squareFeetLabel;
@property (nonatomic, strong) UILabel *squareFeetSubLabel;
@property (nonatomic, strong) UITableView *table;

#pragma mark - Initializer

- (id) initWithResidence: (OMBResidence *) object;

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) addImageViewsToImageScrollView;
- (void) addSimilarResidence: (OMBResidence *) object;
- (int) currentPageOfImages;

@end
