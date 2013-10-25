//
//  OMBAppDelegate.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 10/17/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MFSideMenuContainerViewController;
@class OMBMenuViewController;
@class OMBTabBarController;

@interface OMBAppDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic, strong) MFSideMenuContainerViewController *menuContainer;
@property (nonatomic, strong) OMBMenuViewController *rightMenu;
@property (nonatomic, strong) OMBTabBarController *tabBarController;
@property (nonatomic, strong) UIWindow *window;

@end
