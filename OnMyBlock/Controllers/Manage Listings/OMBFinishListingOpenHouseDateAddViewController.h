//
//  OMBFinishListingOpenHouseDateAddViewController.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 1/13/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBTableViewController.h"

@class OMBOpenHouse;
@class OMBResidence;

@interface OMBFinishListingOpenHouseDateAddViewController : 
  OMBTableViewController
<UITextFieldDelegate>
{
  UIBarButtonItem *doneBarButtonItem;
  BOOL isEditing;
  OMBOpenHouse *openHouse;
  OMBResidence *residence;
  UIBarButtonItem *saveBarButtonItem;
}

#pragma mark - Initializer

- (id) initWithResidence: (OMBResidence *) object;

@end
