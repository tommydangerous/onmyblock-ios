//
//  OMBNavigationController.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 10/18/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OMBNavigationController : UINavigationController
<UINavigationControllerDelegate>

@property (nonatomic, strong) dispatch_block_t completionBlock;

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) pushViewController: (UIViewController *) viewController
                   animated: (BOOL) animated
                 completion: (dispatch_block_t) completion;

@end
