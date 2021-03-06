//
//  OMBHomebaseLandlordViewController.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 1/4/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBViewController.h"

@class DRNRealTimeBlurView;
@class OMBActivityViewFullScreen;
@class OMBBlurView;

@interface OMBHomebaseLandlordViewControllerOLD : OMBViewController
<UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate>
{
  UIButton *activityButton;
  OMBActivityViewFullScreen *activityViewFullScreen;
  OMBBlurView *backView;
  CGFloat backViewOffsetY;
  DRNRealTimeBlurView *blurView;
  UIView *buttonsView;
  UIBarButtonItem *inboxBarButtonItem;
  UIButton *paymentsButton;
  UIRefreshControl *refreshControl;
  int selectedSegmentIndex;
  UIView *welcomeView;
}

// Tables
@property (nonatomic, strong) UITableView *activityTableView;
@property (nonatomic, strong) UITableView *paymentsTableView;

@end
