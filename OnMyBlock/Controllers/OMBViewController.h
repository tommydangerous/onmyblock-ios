//
//  OMBViewController.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 10/18/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Mixpanel/Mixpanel.h>

#import "Flurry.h"
#import "GAI.h"
#import "GAIDictionaryBuilder.h"
#import "GAITrackedViewController.h"

#import "OMBAppDelegate.h"
#import "OMBTabBarController.h"
#import "OMBUser.h"
#import "UIFont+OnMyBlock.h"

extern CGFloat const OMBCornerRadius;
extern CGFloat const OMBKeyboardHeight;
extern CGFloat const OMBPadding;
extern CGFloat const OMBStandardButtonHeight;
extern CGFloat const OMBStandardDuration;
extern CGFloat const OMBStandardHeight;

@interface OMBViewController : GAITrackedViewController
{
  UIBarButtonItem *backBarButtonItem;
  UIBarButtonItem *cancelBarButtonItem;
  UIBarButtonItem *doneBarButtonItem;
  UIBarButtonItem *menuBarButtonItem;
  UIBarButtonItem *saveBarButtonItem;
  UIBarButtonItem *shareBarButtonItem;
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (OMBAppDelegate *) appDelegate;
- (void) containerStartSpinning;
- (void) containerStartSpinningFullScreen;
- (void) containerStopSpinning;
- (void) containerStopSpinningFullScreen;
- (void) back;
- (void) cancel;
- (void) done;
- (void) save;
- (CGRect) screen;
- (void) setMenuBarButtonItem;
- (void) shareButtonSelected;
- (void) showAlertViewWithError: (NSError *) error;
- (NSUserDefaults *) userDefaults;

@end
