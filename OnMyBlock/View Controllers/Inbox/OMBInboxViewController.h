//
//  OMBInboxViewController.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/24/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBTableViewController.h"

#import "OMBConnectionProtocol.h"

@class OMBActivityView;
@class OMBEmptyBackgroundWithImageAndLabel;
@class OMBMessageDetailViewController;

@interface OMBInboxViewController : OMBTableViewController 
<OMBConnectionProtocol>
{
  OMBActivityView *activityView;
  OMBMessageDetailViewController *messageDetailViewController;
  OMBEmptyBackgroundWithImageAndLabel *noMessagesView;
  UIRefreshControl *refreshControl;
}

@property (nonatomic, strong) UIAlertView *alertView;
@property (nonatomic, strong) UIDynamicAnimator *animator;
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) UIView *redSquare;
@property (nonatomic, strong) UISnapBehavior *snapBehavior;

@end
