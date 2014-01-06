//
//  OMBHomebaseBuyerViewController.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 1/6/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBViewController.h"

@interface OMBHomebaseRenterViewController : OMBViewController
<UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate>
{
  UIButton *activityButton;
  UIButton *addRemoveRoommatesButton;
  UIView *backView;
  CGFloat backViewOffsetY;
  UIView *buttonsView;
  UIScrollView *imagesScrollView;
  NSMutableArray *imageViewArray;
  UIButton *paymentsButton;
  int selectedSegmentIndex;
}

// Tables
@property (nonatomic, strong) UITableView *activityTableView;
@property (nonatomic, strong) UITableView *paymentsTableView;

@end
