//
//  OMBResidenceImageSlideViewController.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 10/25/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBViewController.h"

@class OMBResidence;
@class OMBResidenceDetailViewController;

@interface OMBResidenceImageSlideViewController : OMBViewController
<UIScrollViewDelegate>
{
  OMBResidence *residence;
}

@property (nonatomic, strong) UIScrollView *imageSlideScrollView;
@property (nonatomic, weak) OMBResidenceDetailViewController 
  *residenceDetailViewController;

#pragma mark - Initializer

- (id) initWithResidence: (OMBResidence *) object;

@end
