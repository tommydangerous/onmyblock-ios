//
//  OMBRenterApplicationSectionViewController.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/5/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBTableViewController.h"

#import "OMBRenterApplication.h"

@class OMBUser;

@interface OMBRenterApplicationSectionViewController : OMBTableViewController
<UIActionSheetDelegate>
{
  UIBarButtonItem *addBarButtonItem;
  UIBarButtonItem *doneBarButtonItem;
  BOOL isEditing;
  NSIndexPath *selectedIndexPath;
  UIBarButtonItem *saveBarButtonItem;
  UIActionSheet *sheet;
  BOOL showedAddModelViewControllerForTheFirstTime;
  OMBUser *user;
}

#pragma mark - Initializer

- (id) initWithUser: (OMBUser *) object;

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) addModel;
- (void) done;
- (void) save;
- (void) setAddBarButtonItem;

@end
