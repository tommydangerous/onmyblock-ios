//
//  OMBAppDelegate.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 10/17/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import <FacebookSDK/FacebookSDK.h>
#import <UIKit/UIKit.h>

extern NSString *const FBSessionStateChangedNotification;

@class MFSideMenuContainerViewController;
@class OMBMenuViewController;
@class OMBNavigationController;
@class OMBTabBarController;

@interface OMBAppDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic, strong) OMBNavigationController *loginViewController;
@property (nonatomic, strong) MFSideMenuContainerViewController *menuContainer;
@property (nonatomic, strong) OMBMenuViewController *rightMenu;
@property (nonatomic, strong) OMBTabBarController *tabBarController;
@property (nonatomic, strong) UIWindow *window;

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) openSession;
- (void) showLogin;
- (void) showSignUp;

@end
