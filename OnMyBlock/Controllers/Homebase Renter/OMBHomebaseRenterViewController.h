//
//  OMBHomebaseBuyerViewController.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 1/6/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBViewController.h"

#import "PayPalMobile.h"

@class OMBAlertView;
@class OMBOffer;
@class OMBScrollView;

@interface OMBHomebaseRenterViewController : OMBViewController
<PayPalPaymentDelegate, UIScrollViewDelegate, UITableViewDataSource, 
  UITableViewDelegate>
{
  UIButton *activityButton;
  UIButton *addRemoveRoommatesButton;
  OMBAlertView *alert;
  UIView *backView;
  CGFloat backViewOffsetY;
  UIView *buttonsView;
  BOOL cameFromSettingUpPayoutMethods;
  BOOL charging;
  UIBarButtonItem *editBarButtonItem;
  OMBScrollView *imagesScrollView;
  NSMutableArray *imageViewArray;
  UIView *middleDivider; // For the buttons view
  UIButton *paymentsButton;
  OMBOffer *selectedOffer;
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
