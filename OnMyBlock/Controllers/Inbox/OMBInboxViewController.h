//
//  OMBInboxViewController.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/24/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBTableViewController.h"

@interface OMBInboxViewController : OMBTableViewController

@property (nonatomic, strong) UIAlertView *alertView;
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) UIDynamicAnimator *animator;
@property (nonatomic, strong) UIView *redSquare;
@property (nonatomic, strong) UISnapBehavior *snapBehavior;

@end
