//
//  OMBHomebaseBuyerViewController.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 1/6/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBViewController.h"

@class OMBAlertView;
@class OMBScrollView;

@interface OMBHomebaseRenterViewController : OMBViewController
<UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate>
{
  UIButton *activityButton;
  UIButton *addRemoveRoommatesButton;
  OMBAlertView *alert;
  UIView *backView;
  CGFloat backViewOffsetY;
  UIView *buttonsView;
  UIBarButtonItem *editBarButtonItem;
  OMBScrollView *imagesScrollView;
  NSMutableArray *imageViewArray;
  UIView *middleDivider; // For the buttons view
  UIButton *paymentsButton;
  int selectedSegmentIndex;
  UITapGestureRecognizer *tapGesture;
}

// Tables
@property (nonatomic, strong) UITableView *activityTableView;
@property (nonatomic, strong) UITableView *paymentsTableView;

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) switchToPaymentsTableView;

@end
