//
//  OMBPaymentMethodsViewController.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/11/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBTableViewController.h"

@interface OMBPayoutMethodsViewController : OMBTableViewController
{
  UIBarButtonItem *addBarButtonItem;
  UIView *noPayoutMethodsView;
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) showCancelBarButtonItem;

@end
