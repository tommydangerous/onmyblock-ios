//
//  OMBResidenceDetailViewController.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 10/21/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBViewController.h"

@class OMBResidence;
@class OMBResidenceImageSlideViewController;

@interface OMBResidenceDetailViewController : OMBViewController
<UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate>
{
  OMBResidence *residence;
}

@property (nonatomic, strong) UILabel *addressLabel;
@property (nonatomic, strong) UIButton *addToFavoritesButton;
@property (nonatomic, strong) UIScrollView *imagesScrollView;
@property (nonatomic, strong) UIView *infoView;
@property (nonatomic, strong) OMBResidenceImageSlideViewController
  *imageSlideViewController;
// Array of image views for the images scroll view
@property (nonatomic, strong) NSMutableArray *imageViewArray;
@property (nonatomic, strong) UILabel *pageOfImagesLabel;
@property (nonatomic, strong) UILabel *rentLabel;
@property (nonatomic, strong) UITableView *table;

#pragma mark - Initializer

- (id) initWithResidence: (OMBResidence *) object;

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) addImageViewsToImageScrollView;
- (int) currentPageOfImages;

@end
