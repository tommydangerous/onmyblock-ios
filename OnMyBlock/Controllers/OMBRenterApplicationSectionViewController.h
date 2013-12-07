//
//  OMBRenterApplicationSectionViewController.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/5/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBTableViewController.h"

@class OMBUser;

@interface OMBRenterApplicationSectionViewController : OMBTableViewController
{
  OMBUser *user;
}

#pragma mark - Initializer

- (id) initWithUser: (OMBUser *) object;

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) addModel;
- (void) setAddBarButtonItem;
- (void) setupForTable;

@end
