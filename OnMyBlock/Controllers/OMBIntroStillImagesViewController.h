//
//  OMBIntroStillImagesViewController.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/12/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBViewController.h"

@class DDPageControl;
@class OMBLoginViewController;

@interface OMBIntroStillImagesViewController : OMBViewController
<UIScrollViewDelegate>
{
  UIView *closeButtonView;
}

// Views that do not scroll
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic, strong) DDPageControl *pageControl;
@property (nonatomic, strong) UIScrollView *scroll;

// Controllers
@property (nonatomic, strong) OMBLoginViewController *loginViewController;

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) scrollToPage: (int) page;
- (void) setupForLoggedInUser;
- (void) setupForLoggedOutUser;
- (void) showLogin;

@end
