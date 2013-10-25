//
//  OMBResidenceDetailViewController.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 10/21/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBViewController.h"

@class OMBResidence;

@interface OMBResidenceDetailViewController : OMBViewController
<UIScrollViewDelegate>
{
  OMBResidence *residence;
  UIScrollView *imagesScrollView;
  UIScrollView *mainScrollView;
  NSMutableArray *subviews;
}

// Array of image views for the images scroll view
@property (nonatomic, strong) NSMutableArray *imageViewArray;

#pragma mark - Initializer

- (id) initWithResidence: (OMBResidence *) object;

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) addImageViewsToImageScrollView;

@end
