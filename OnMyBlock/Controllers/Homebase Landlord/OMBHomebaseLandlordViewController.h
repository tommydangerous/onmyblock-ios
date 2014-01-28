//
//  OMBHomebaseLandlordViewController.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 1/4/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBViewController.h"

@class DRNRealTimeBlurView;
@class OMBBlurView;

@interface OMBHomebaseLandlordViewController : OMBViewController
<UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate>
{
  UIButton *activityButton;
  OMBBlurView *backView;
  CGFloat backViewOffsetY;
  DRNRealTimeBlurView *blurView;
  UIView *buttonsView;
  UIBarButtonItem *inboxBarButtonItem;
  UIButton *paymentsButton;
  int selectedSegmentIndex;
  UIView *welcomeView;
}

// Tables
@property (nonatomic, strong) UITableView *activityTableView;
@property (nonatomic, strong) UITableView *paymentsTableView;

@end
