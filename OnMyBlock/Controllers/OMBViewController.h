//
//  OMBViewController.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 10/18/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GAITrackedViewController.h"

#import "OMBAppDelegate.h"
#import "OMBTabBarController.h"
#import "OMBUser.h"
#import "UIFont+OnMyBlock.h"

extern CGFloat const OMBPadding;
extern CGFloat const OMBStandardButtonHeight;
extern CGFloat const OMBStandardHeight;

@interface OMBViewController : GAITrackedViewController
{
  UIBarButtonItem *backBarButtonItem;
  UIBarButtonItem *cancelBarButtonItem;
  UIBarButtonItem *doneBarButtonItem;
  UIBarButtonItem *menuBarButtonItem;
  UIBarButtonItem *saveBarButtonItem;
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (OMBAppDelegate *) appDelegate;
- (void) back;
- (void) cancel;
- (void) done;
- (void) save;
- (void) setMenuBarButtonItem;
- (void) showAlertViewWithError: (NSError *) error;

@end
