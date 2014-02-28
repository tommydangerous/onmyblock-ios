//
//  OMBManageListingsViewController.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/26/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBTableViewController.h"

@class OMBActivityView;

@class AMBlurView;

@interface OMBManageListingsViewController : OMBTableViewController
{
  UIButton *createListingButton;
  AMBlurView *createListingView;
  NSMutableArray *imagesArray;
  OMBActivityView *activityView;
}

@end
