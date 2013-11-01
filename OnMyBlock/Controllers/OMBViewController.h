//
//  OMBViewController.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 10/18/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "OMBAppDelegate.h"
#import "OMBTabBarController.h"

@interface OMBViewController : UIViewController
{
  UIBarButtonItem *doneEditingBarButtonItem;
  UIBarButtonItem *menuBarButtonItem;
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) showDoneEditingBarButtonItem;
- (void) showMenuBarButtonItem;

@end
