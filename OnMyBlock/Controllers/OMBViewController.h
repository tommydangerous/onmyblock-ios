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

@interface OMBViewController : GAITrackedViewController
{
  UIBarButtonItem *doneEditingBarButtonItem;
  UIBarButtonItem *menuBarButtonItem;
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (OMBAppDelegate *) appDelegate;
- (void) setMenuBarButtonItem;
- (void) showAlertViewWithError: (NSError *) error;
- (void) showDoneEditingBarButtonItem;
- (void) showMenuBarButtonItem;

@end
