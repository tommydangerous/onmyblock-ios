//
//  OMBTabBarController.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 10/18/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OMBNavigationController;

@interface OMBTabBarController : UITabBarController

@property (nonatomic, strong) OMBNavigationController *favoritesViewController;
@property (nonatomic, strong) OMBNavigationController *mapViewController;

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) switchToViewController: (OMBNavigationController *) vc;

@end
