//
//  OMBFinishListingSectionViewController.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/27/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBTableViewController.h"

@class OMBResidence;

@interface OMBFinishListingSectionViewController : OMBTableViewController
{
  BOOL isEditing;
  OMBResidence *residence;
}

#pragma mark - Initializer

- (id) initWithResidence: (OMBResidence *) object;

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) save;

@end
